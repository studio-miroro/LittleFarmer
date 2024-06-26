extends Control

class_name BuildingMenu
@onready var anim	= $AnimationPlayer
var pause			= PauseMenu.new()
var open:bool 		= false

func _ready():
	check_window()
	
func _process(delta):
	if !pause.paused:
		if Input.is_action_just_pressed("inventory"):
			window()
	
func check_window():
	visible = open
	
func window():
	if !pause.paused:
		if open:
			open = false
			anim.play("transform_reset")
		else:
			open = true
			anim.play("transform")

func _on_button_pressed():
	window()
