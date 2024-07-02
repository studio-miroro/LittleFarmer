extends Control

class_name BuildingMenu

@onready var node = load("res://assets/nodes/UI/popup/itemBuildingMenu.tscn")
@onready var animation = $AnimationPlayer
@onready var blur = get_node("/root/World/UI/Blur")
@onready var pause = get_node("/root/World/UI/Pause")

@onready var container:GridContainer = get_node("/root/World/UI/Pop-up Menu/BuildingMenu/Panel/HBoxContainer/Items/GridContainer")
@onready var caption:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectCaption
@onready var description:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectDescription
@onready var timeCreate:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectCreationTime
@onready var button:Button = $Panel/HBoxContainer/Info/VBoxContainer/Button

var store = StoreBuilding.new()

var blueprints:int = 0
var access:Array = [1,2,3,4,5]
var isOpen:bool = false

func _ready():
	pause.lock = false
	isOpen = false
	blur.blur(false)
	animation.play("transform_reset")
	check_blueprints(blueprints, access)

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

func open():
	pause.lock = true
	isOpen = true
	blur.blur(true)
	animation.play("transform")
	start_info()
	check_blueprints(blueprints, access)
	
func close():
	pause.lock = false
	isOpen = false
	blur.blur(false)
	animation.play("transform_reset")
	check_blueprints(blueprints, access)

func start_info():
	caption.text = "* Информация *"
	description.text = "Начните строительство, выбрав доступные чертежи слева."
	timeCreate.text = ""
	button.visible = false

func check_blueprints(item:int, array:Array):
	if isOpen:
		for i in array:
			create_item(i)
	else:
		delete_all_blueprints(container)

func create_item(i):
	var item = node.instantiate()
	if item.test():
		container.add_child(item)
		item.set_data(i)
	else:
		push_error("Cannot load node.")

func delete_all_blueprints(parent):
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

func get_data(index:int):
	if store.content.has(index):
		if store.content[index].has("caption"):
			if typeof(store.content[index]["caption"]) == TYPE_STRING and caption.text is String:
				caption.text = str(store.content[index]["caption"])
			else:
				caption.text = "Untitled blueprint"
				push_error("The 'caption' key has a non-string type. Variant.type: " + str(typeof(store.content[index]["caption"])))
		else:
			push_error("The object does not have the 'caption' key.")
			description.visible = false
			
		if store.content[index].has("description"):
			if typeof(store.content[index]["description"]) == TYPE_STRING and description.text is String:
				description.text = str(store.content[index]["description"])
				description.visible = true
			else:
				push_error("The 'description' key has a non-string type. Variant.type: " + str(typeof(store.content[index]["description"])))
				description.visible = false
		else:
			push_error("The object does not have the 'description' key.")
			description.visible = false
			
		if store.content[index].has("time"):
			if typeof(store.content[index]["time"]) == TYPE_INT and description.text is String:
				if store.content[index]["time"] > 0:
					timeCreate.text = "Время создания: " + str(store.content[index]["time"]) + " сек."
					timeCreate.visible = true
				else:
					timeCreate.visible = false
			else:
				push_error("The 'time' key has a non-string type. Variant.type: " + str(typeof(store.content[index]["time"])))
				timeCreate.visible = false
		else:
			push_error("The object does not have the 'time' key.")
			timeCreate.visible = false
			
		button.visible = true

func reset_data():
	caption.text = ""
	description.text = ""
	timeCreate.text = ""
	button.visible = false

func check_window():
	visible = isOpen

func _on_button_pressed():
	window()
