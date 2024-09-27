extends Control

@onready var menu:Node2D = get_node("/root/" + str(get_tree().root.get_child(1).name))
@onready var blackout:Control = get_node("/root/Menu/CanvasLayer/Blackout")
@onready var sprite:TextureRect = $VBoxContainer/Sprite/ButtonSprite
@onready var caption:Label = $VBoxContainer/Label/Scroll/Label

func _on_button_pressed():
	if !menu.clicked:
		menu.clicked = true
		blackout.blackout(true)
		await get_tree().create_timer(1.25).timeout
		get_tree().quit()
