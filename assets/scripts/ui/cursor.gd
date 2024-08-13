extends Node2D

@onready var cursor_static:CompressedTexture2D = load("res://assets/resources/ui/cursor/cursor_static.png")
@onready var cursor_active:CompressedTexture2D = load("res://assets/resources/ui/cursor/cursor_active.png")

func _ready():
	Input.set_custom_mouse_cursor(
		cursor_static, 
		Input.CURSOR_ARROW, 
		Vector2(0,0)
		)
		
func _input(event) -> void:
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		Input.set_custom_mouse_cursor(
			cursor_active,
			Input.CURSOR_ARROW, 
			Vector2(0,0)
			)
			
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_released():
		Input.set_custom_mouse_cursor(
			cursor_static,
			Input.CURSOR_ARROW, 
			Vector2(0,0)
			)
