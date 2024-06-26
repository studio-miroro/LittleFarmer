extends Node2D

@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid")
@onready var player = get_node("/root/World/Player")
@onready var sprite:Sprite2D = $Sprite2D

var max_distance:int = 250
var object:Dictionary = {
	"default" 	= preload("res://assets/resources/buildings/mailbox/object_0.png"),
	"hover" 	= preload("res://assets/resources/buildings/mailbox/object_1.png"),
}

func _ready():
	if object.has("default"):
		if typeof(object["default"]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object["default"]
		else:
			push_error("The specified sprite cannot be installed.")
	else:
		push_error("The specified key is missing.")
	
func change_sprite(type:bool) -> void:
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.gridmode.NOTHING and distance < max_distance:
			check_sprite("hover")
	else:
		check_sprite("default")
	
func check_sprite(key:String):
	if object.has(key):
		if typeof(object[key]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object[key]
		else:
			push_error("The specified sprite cannot be installed.")
	else:
		push_error("The specified key is missing.")
	
func _on_area_2d_mouse_entered():
	if !pause.paused:
		change_sprite(true)

func _on_area_2d_mouse_exited():
	change_sprite(false)
