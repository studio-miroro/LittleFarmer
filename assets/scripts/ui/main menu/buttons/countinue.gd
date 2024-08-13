extends Control

@onready var sprite:TextureRect = $VBoxContainer/Sprite/ButtonSprite
@onready var caption:Label = $VBoxContainer/Label/Scroll/Label

func _on_button_pressed():
	print("Game Countinue...")
