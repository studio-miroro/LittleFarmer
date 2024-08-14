extends Control

#@onready var blackout:Control = get_node("/root/Menu/CanvasLayer/Blackout")
#@onready var sprite:TextureRect = $VBoxContainer/Sprite/ButtonSprite
#@onready var caption:Label = $VBoxContainer/Label/Scroll/Label

@onready var path = "res://levels/farm.tscn"

func _on_pressed():
	get_tree().change_scene_to_file(path)
