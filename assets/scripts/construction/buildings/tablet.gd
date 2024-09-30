extends Node2D

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var pause:Control = get_node("/root/"+main+"/UI/Inveractive/Pause")
@onready var tip:Control = get_node("/root/"+main+"/UI/Feedback/Tooltip")
@onready var grid:Node2D = get_node("/root/"+main+"/Buildings/Grid")
@onready var player:CharacterBody2D = get_node("/root/"+main+"/Camera")
@onready var sprite:Sprite2D = $Sprite2D

var max_distance:int = 250
var object:Dictionary = {
	"caption" = tr("tablet.caption"),
	"description" = tr("tablet.description"),
	"default" = load("res://assets/resources/buildings/tablet/tablet_0.png"),
	"hover" = load("res://assets/resources/buildings/tablet/tablet_1.png"),
}

func _ready():
	if object.has("default"):
		if typeof(object["default"]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object["default"]
		else:
			data.debug("The specified sprite cannot be installed.", "error")
	else:
		data.debug("The specified key is missing.", "error")

func _change_sprite(type:bool) -> void:
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.modes.NOTHING and distance < max_distance:
			_check_sprite("hover")
			if object.has("caption")\
			and object.has("description"):
				tip.tooltip(
					object["caption"]+"\n"
					+object["description"]
				)
			else:
				data.debug("Check the 'caption', 'description' elements.", "error")
	else:
		_check_sprite("default")
		tip.tooltip("")
	
func _check_sprite(key:String) -> void:
	if object.has(key):
		if typeof(object[key]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object[key]
		else:
			data.debug("The specified sprite cannot be installed.", "error")
	else:
		data.debug("The specified key is missing.", "error")

func _on_area_2d_mouse_entered() -> void:
	if !blur.state:
		_change_sprite(true)

func _on_area_2d_mouse_exited() -> void:
	_change_sprite(false)
