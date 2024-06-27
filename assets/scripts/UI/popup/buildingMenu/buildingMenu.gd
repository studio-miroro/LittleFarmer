extends Control

class_name BuildingMenu
@onready var animation		= $AnimationPlayer
@onready var blur			= get_node("/root/World/UI/Blur")

@onready var caption:Label		= $Panel/HBoxContainer/Info/VBoxContainer/ObjectCaption
@onready var description:Label	= $Panel/HBoxContainer/Info/VBoxContainer/ObjectDescription
@onready var button:Button		= $Panel/HBoxContainer/Info/VBoxContainer/Button
var pause		= PauseMenu.new()
var store		= StoreBuilding.new()
var open:bool 	= false

func _ready():
	reset_data()

func _process(delta):
	if !pause.paused:
		if Input.is_action_just_pressed("inventory"):
			window()
	
func window():
		if open:
			blur.blur(false, false)
			get_node("/root/World/Player").switch = false
			open = false
			animation.play("transform_reset")
		else:
			blur.blur(true, true)
			get_node("/root/World/Player").switch = true
			open = true
			animation.play("transform")
			
func get_data(index:int):
	caption.text		= str(store.content[index]["caption"])
	description.text	= str(store.content[index]["description"])
	button.visible		= true

func check_window():
	visible = open

func reset_data():
	caption.text		= ""
	description.text 	= ""
	button.visible 		= false

func _on_button_pressed():
	window()
