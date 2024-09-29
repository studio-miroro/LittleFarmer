extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var menu:Node2D = get_node("/root/" + main_scene)
@onready var blackout:Control = get_node("/root/" + main_scene +"/Canvas/MainMenu/Blackout")
@onready var sprite:TextureRect = $VBoxContainer/Sprite/ButtonSprite
@onready var caption:Label = $VBoxContainer/Label/Scroll/Label
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var button:Button = $Button
var path:String = "res://levels/farm.tscn"
var button_state:bool

func _on_button_pressed():
	if !menu.clicked:
		menu.clicked = true
		blackout.blackout(true)
		await get_tree().create_timer(1.25).timeout
		GameLoader.loading(true)
		get_tree().change_scene_to_file(path)

func buttons_state(state:bool) -> void:
	match state:
		true:
			_hide()
		false:
			_show()

func _hide() -> void:
	anim.play("hide")
	button_state = false

func _show() -> void:
	anim.play("show")
	button_state = !false

func _check_window() -> void:
	visible = button_state
