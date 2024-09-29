extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/UI/Windows/Pause")
@onready var tip:Control = get_node("/root/" + main_scene + "/UI/GUI/Tooltip")
@onready var sign_menu:Control = get_node("/root/" + main_scene + "/UI/BuildingsMenu/SignMenu")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/GUI/Blur")
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")
@onready var icon:TextureRect = $TextureRect
@onready var sprite:Sprite2D = $Sprite2D

var items = Items.new()
var max_distance:int = 250
var open_menu:bool = false
var object:Dictionary = {
	"description" = tr("sign.description"),
	"default" = load("res://assets/resources/buildings/sign/sign_0.png"),
	"hover" = load("res://assets/resources/buildings/sign/sign_1.png"),
}

func _ready():
	if object.has("default"):
		if typeof(object["default"]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object["default"]
		else:
			data.debug("The specified sprite cannot be installed.", "error")
	else:
		data.debug("The specified key is missing.", "error")

func set_sign_sprite(target_sprite):
	if items.content.has(target_sprite):
		if items.content[target_sprite].has("icon"):
			icon.texture = items.content[target_sprite]["icon"]
		else:
			data.debug("The object does not have the 'description' key", "error")
	else:
		data.debug("Invalid index: " + str(target_sprite), "error")

func _input(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed()\
	and open_menu:
		sign_menu._open(name)

func _change_sprite(type:bool) -> void:
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.modes.NOTHING and distance < max_distance:
			_check_sprite("hover")
			open_menu = true
	else:
		_check_sprite("default")
		tip.tooltip("")
		open_menu = false
	
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
