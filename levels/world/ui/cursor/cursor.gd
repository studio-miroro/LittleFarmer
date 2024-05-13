extends Node2D

var cursor_static = preload("res://levels/world/ui/cursor/cursor_static.png")
var cursor_active = preload("res://levels/world/ui/cursor/cursor_active.png")

func _ready():
	Input.set_custom_mouse_cursor(
		cursor_static, 
		Input.CURSOR_ARROW, 
		Vector2(0,0)
		)
func _input(_event):
		if Input.is_action_just_pressed("click left"):
			Input.set_custom_mouse_cursor(
				cursor_active,
				Input.CURSOR_ARROW, 
				Vector2(0,0)
				)
		if Input.is_action_just_released("click left"):
			Input.set_custom_mouse_cursor(
				cursor_static,
				Input.CURSOR_ARROW, 
				Vector2(0,0)
				)
