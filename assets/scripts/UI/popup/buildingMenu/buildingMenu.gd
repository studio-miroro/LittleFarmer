extends Control

class_name BuildingMenu
@onready var node:PackedScene = load("res://assets/nodes/UI/popup/itemBuildingMenu.tscn")
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var blur:Control = get_node("/root/World/UI/Blur")
@onready var inventory:Control = get_node("/root/World/UI/HUD/Inventory")
@onready var pause:Control = get_node("/root/World/UI/Pause")

@onready var container:GridContainer = get_node("/root/World/UI/Pop-up Menu/BuildingMenu/Panel/HBoxContainer/Items/GridContainer")
@onready var caption:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectCaption
@onready var description:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectDescription
@onready var resources:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectResources
@onready var timeCreate:Label = $Panel/HBoxContainer/Info/VBoxContainer/ObjectCreationTime
@onready var button:Button = $Panel/HBoxContainer/Info/VBoxContainer/Button

var items:Object = Items.new()
var store:Object = StoreBuilding.new()
var constructionMaterials:Object = BuildingMaterials.new()

var access:Array = [1,2,3,4,5,6,7,8,9,10]
var menu:bool = false

func _ready():
	pause.lock = false
	menu = false
	blur.blur(false)
	anim.play("transform_reset")
	check_blueprints(access)

func _process(delta):
	if !pause.paused\
	and !inventory.menu:
		if Input.is_action_just_pressed("menu") and menu:
			close()

func window():
	if menu:
		close()
	else:
		open()

func open():
	pause.lock = true
	menu = true
	blur.blur(true)
	anim.play("transform")
	start_info()
	check_blueprints(access)
	
func close():
	pause.lock = false
	menu = false
	blur.blur(false)
	anim.play("transform_reset")
	check_blueprints(access)

func start_info():
	caption.text = "* Информация *"
	description.text = "Начните строительство, выбрав доступные чертежи слева."
	timeCreate.text = ""
	button.visible = false

func check_blueprints(array:Array):
	if menu:
		for i in array:
			create_item(i)
	else:
		delete_all_blueprints(container)

func create_item(i):
	var item = node.instantiate()
	if item.test(i):
		container.add_child(item)
		item.set_data(i)
	else:
		push_error("Cannot load node. Invalid index: " + str(i))

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
				description.text = store.content[index]["description"] + "\n"
				description.visible = true
			else:
				push_error("The 'description' key has a non-string type. Variant.type: " + str(typeof(store.content[index]["description"])))
				description.visible = false
		else:
			push_error("The object does not have the 'description' key.")
			description.visible = false
		
		if store.content[index].has("resource"):
			resources.visible = true
			resources.text = "Необходимые ресурсы:"
			
			if store.content[index].get("resource") != {}:
				for i in store.content[index]["resource"]:
					check_material(index, i)
			else:
				push_warning("The drawing does not have the necessary resources for construction.")
				resources.visible = false
		else:
			push_error("The array of 'resources' does not exist in index: " + str(index))
			resources.visible = false
		
		if store.content[index].has("time"):
			if typeof(store.content[index]["time"]) == TYPE_INT and description.text is String:
				if store.content[index]["time"] > 0:
					timeCreate.text = "Время создания: " + str(store.content[index]["time"]) + " сек."
					timeCreate.visible = true
				else:
					timeCreate.visible = false
			else:
				push_error("The 'time' key has a non-integer type. Variant.type: " + str(typeof(store.content[index]["time"])))
				timeCreate.visible = false
		else:
			push_error("The object does not have the 'time' key.")
			timeCreate.visible = false
			
		button.visible = true
	else:
		button.visible = false

func check_material(index, key):
	if resource(key) != null:
		if typeof(store.content[index]["resource"][key]) != TYPE_STRING:
			resources.text = resources.text + "\n• " + str(resource(key)) + " (" + str(0) + "/" + str(round(store.content[index]["resource"][key])) + ")"
		else:
			push_error("The key '" + str(key) + "' does not store an integer or float: " + str(typeof(store.content[index]["resource"][key])))
	else:
		push_warning("The '" + str(key)+ "' material cannot be returned as a string. This material will not be taken into account.")
		
func resource(key):
	if key in constructionMaterials.resources:
		return constructionMaterials.resources[key]
	return null

func reset_data():
	caption.text = ""
	description.text = ""
	resources.visible = false
	timeCreate.visible = false
	button.visible = false

func check_window():
	visible = menu

func _on_button_pressed():
	window()
