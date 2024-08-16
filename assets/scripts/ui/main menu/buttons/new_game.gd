extends Control

@onready var blackout:Control = get_node("/root/Menu/CanvasLayer/Blackout")
@onready var sprite:TextureRect = $VBoxContainer/Sprite/ButtonSprite
@onready var caption:Label = $VBoxContainer/Label/Scroll/Label

@onready var path:String = "res://levels/farm.tscn"

func _on_button_pressed():
	blackout.blackout(true, 4)
	await get_tree().create_timer(1.25).timeout
	GameLoader.loading(false)
	get_tree().change_scene_to_file(path)
