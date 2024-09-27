extends Control

@onready var menu:Node2D = get_node("/root/" + str(get_tree().root.get_child(1).name))
@onready var blackout:Control = get_node("/root/Menu/CanvasLayer/Blackout")
@onready var sprite:TextureRect = $VBoxContainer/Sprite/ButtonSprite
@onready var caption:Label = $VBoxContainer/Label/Scroll/Label

@onready var path:String = "res://levels/farm.tscn"

func _on_button_pressed():
	if !menu.clicked:
		menu.clicked = true
		blackout.blackout(true)
		await get_tree().create_timer(1.25).timeout
		GameLoader.loading(true)
		get_tree().change_scene_to_file(path)
