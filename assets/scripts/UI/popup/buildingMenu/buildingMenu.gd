extends Control

class_name BuildingMenu

@onready var node = load("res://assets/nodes/UI/popup/itemBuildingMenu.tscn")
@onready var animation = $AnimationPlayer
@onready var blur = get_node("/root/World/UI/Blur")
@onready var pause_node = get_node("/root/World/UI/Pause")

@onready var container:GridContainer = get_node("/root/World/UI/Pop-up Menu/BuildingMenu/Panel/HBoxContainer/Items/GridContainer")
@onready var caption:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectCaption
@onready var description:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectDescription
@onready var button:Button = $Panel/HBoxContainer/Info/VBoxContainer/Button

var pause = PauseMenu.new()
var store = StoreBuilding.new()

var items:int = 0
var access:Array = [1,2,3,4,5]
var isOpen:bool = false

func _ready():
	pause_node.lock = false
	isOpen = false
	blur.blur(false)
	animation.play("transform_reset")
	check_items(items, access)

func _process(delta):
	if !pause.paused:
		if Input.is_action_just_pressed("inventory"):
			window()
		if Input.is_action_just_pressed("menu") and isOpen:
			close()

func window():
	if isOpen:
		close()
	else:
		open()

func check_items(item:int, array:Array):
	if isOpen:
		for i in array:
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
	if store.content.has(index):
		if store.content[index].has("caption"):
			if typeof(store.content[index]["caption"]) == TYPE_STRING and caption.text is String:
				caption.text = str(store.content[index]["caption"])
			else:
				push_error("The 'caption' key has a non-string type. Variant.type: " + str(typeof(store.content[index]["caption"])))
		else:
			push_error("The object does not have the 'caption' key.")
			
		if store.content[index].has("description"):
			if typeof(store.content[index]["description"]) == TYPE_STRING and description.text is String:
				description.text = str(store.content[index]["description"])
			else:
				push_error("The 'description' key has a non-string type. Variant.type: " + str(typeof(store.content[index]["description"])))
		else:
			push_error("The object does not have the 'description' key.")
			
		button.visible = true
	else:
		push_error("Invalid index: " + str(index))
		button.visible = false

func check_window():
	visible = isOpen
	
func open():
	pause_node.lock = true
	isOpen = true
	blur.blur(true)
	animation.play("transform")
	check_items(items, access)
	
func close():
	pause_node.lock = false
	isOpen = false
	blur.blur(false)
	animation.play("transform_reset")
	check_items(items, access)

func reset_data():
	caption.text = ""
	description.text = ""
	button.visible = false

func _on_button_pressed():
	window()
