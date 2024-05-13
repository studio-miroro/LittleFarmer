extends Node2D

@onready var object_sprite:Sprite2D = $Sprite2D
@export var sprite_default = preload("res://levels/world/tilesets/building/mailbox/object_0.png")
@export var sprite_hover = preload("res://levels/world/tilesets/building/mailbox/object_1.png")
@onready var player = get_node("/root/World/Player")
var max_distance:int = 250

var object = preload("res://levels/world/ui/object info/object_info.tscn")
var object_name:String = "Почтовой ящик"
var object_description:String = "Здесь хранятся письма"
var object_level = 0

func _input(event):
	if get_node("/root/World/UI/Pause").paused or game_variables.mode != game_variables.gamemode.NOTHING:
		object_sprite.texture = sprite_default
	
func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !get_node("/root/World/UI/Pause").paused\
	and game_variables.mode == game_variables.gamemode.NOTHING\
	and distance < max_distance:
		object_sprite.texture = sprite_hover
		get_node("/root/World/UI/ObjectInfo").object(get_global_mouse_position(), object_name, object_description, object_level, 0, true)

func _on_area_2d_mouse_exited():
	if !get_node("/root/World/UI/Pause").paused:
		object_sprite.texture = sprite_default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)
	else:
		object_sprite.texture = sprite_default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)
