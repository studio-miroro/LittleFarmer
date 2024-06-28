extends Control

class_name BuildingMenu

@onready var node					 = load("res://assets/nodes/UI/popup/itemBuildingMenu.tscn")
@onready var animation				 = $AnimationPlayer
@onready var blur					 = get_node("/root/World/UI/Blur")

@onready var container:GridContainer = get_node("/root/World/UI/Pop-up Menu/BuildingMenu/Panel/HBoxContainer/Items/GridContainer")
@onready var caption:Label			= $Panel/HBoxContainer/Info/VBoxContainer/ObjectCaption
@onready var description:Label		= $Panel/HBoxContainer/Info/VBoxContainer/ObjectDescription
@onready var button:Button			= $Panel/HBoxContainer/Info/VBoxContainer/Button

var access:int		= 0
var items:Array		= [1,2,3,4,5]

var pause			= PauseMenu.new()
var store			= StoreBuilding.new()
var open:bool 		= false

func _ready():
	open = false
	blur.blur(false, false)
	get_node("/root/World/Player").switch = false
	animation.play("transform_reset")
	reset_data()

func _process(delta):
	if !pause.paused:
		if Input.is_action_just_pressed("inventory"):
			window()

func window():
		if open:
			open = false
			blur.blur(false, false)
			get_node("/root/World/Player").switch = false
			animation.play("transform_reset")
			check_items(access, items)
		else:
			open = true
			blur.blur(true, true)
			get_node("/root/World/Player").switch = true
			animation.play("transform")
			check_items(access, items)

func check_items(item:int, dictionary):
	if open:
		for i in dictionary:
			create_item(i)
	else:
		delete_all_items(container)

func create_item(i):
	var item = node.instantiate()
	if item.test():
		container.add_child(item)
		item.set_data(i)
	else:
		push_error("Cannot load node.")
	
func delete_all_items(parent):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

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
