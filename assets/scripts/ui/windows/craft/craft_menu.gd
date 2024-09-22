extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager:Node2D = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var notice:Control = get_node("/root/" + main_scene + "/User Interface/System/Notifications")
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var blueprint:PackedScene = load("res://assets/nodes/ui/windows/craft/blueprint.tscn")
@onready var container:GridContainer = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting/Panel/HBoxContainer/Items/GridContainer")
@onready var build_button:Button = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting/Panel/HBoxContainer/Info/VBoxContainer/Button/Craft")
@onready var caption:Label = $Panel/HBoxContainer/Info/VBoxContainer/Caption/ObjectCaption
@onready var description:Label = $Panel/HBoxContainer/Info/VBoxContainer/Description/ObjectDescription
@onready var resources:Label = $Panel/HBoxContainer/Info/VBoxContainer/Resources/ObjectResources
@onready var time_create:Label = $Panel/HBoxContainer/Info/VBoxContainer/Time/ObjectCreationTime
@onready var button:Button = $Panel/HBoxContainer/Info/VBoxContainer/Button/Craft
@onready var anim:AnimationPlayer = $AnimationPlayer

var index:int
var menu:bool = false
var access:Array[int] = [1,2,3,4,5,6]

var items:Object = Items.new()
var blueprints:Object = Blueprints.new()
var materials:Object = BuildingMaterials.new()

func _ready():
	check_window()
	reset_data()
	check_blueprints_status()

func check_blueprints_status():
	var items_to_remove = []
	for i in access:
		if !blueprints.content.has(i):
			items_to_remove.append(i)
	for item in items_to_remove:
		access.erase(item)
	print_debug("\n"+str(manager.get_system_datetime()) + " INFO: Due to inventory overflow, an item with the following ID was destroyed: " + str(items_to_remove))
	
func _process(_delta):
	if !pause.paused\
	and !inventory.menu:
		if Input.is_action_just_pressed("pause") and menu:
			close()

func window() -> void:
	if menu:
		close()
	else:
		open()

func open() -> void:
	menu = true
	pause.other_menu = true
	blur.blur(true)
	anim.play("open")
	start_info()
	delete_all_blueprints()
	check_blueprints()
	
func close() -> void:
	menu = false
	pause.other_menu = false
	blur.blur(false)
	anim.play("close")
	delete_all_blueprints()

func start_info() -> void:
	var start_caption = tr("startinfo_header.craft")
	var start_description = tr("startinfo_description.craft")
	caption.text = start_caption
	description.text = start_description
	time_create.text = ""
	button.visible = false

func check_blueprints() -> void:
	if menu:
		for id in access:
			create_item(id)

func create_item(id) -> void:
	var item = blueprint.instantiate()
	if item.check_node(id):
		container.add_child(item)
		item.set_data(id)
	else:
		print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: Cannot load node. Invalid index: " + str(id))

func delete_all_blueprints() -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func get_data(id):
	self.index = id
	button.id = id
	if blueprints.content.has(int(index)):
		if blueprints.content[int(index)].has("caption"):
			if typeof(blueprints.content[int(index)]["caption"]) == TYPE_STRING and caption.text is String:
				caption.text = str(blueprints.content[int(index)]["caption"])
				caption.visible = true
			else:
				caption.text = ""
				caption.visible = false
				print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The 'caption' key has a non-string type. Variant.type: " + str(typeof(blueprints.content[index]["caption"])))
		else:
			print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The object does not have the 'caption' key.")
			description.visible = false
			
		if blueprints.content[id].has("description"):
			if typeof(blueprints.content[id]["description"]) == TYPE_STRING and description.text is String:
				description.text = blueprints.content[id]["description"] + "\n"
				description.visible = true
			else:
				print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The 'description' key has a non-string type. Variant.type: " + str(typeof(blueprints.content[index]["description"])))
				description.visible = false
		else:
			print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The object does not have the 'description' key.")
			description.visible = false
		
		if blueprints.content[id].has("resource"):
			var resources_label = tr("necessary_resources.craft")
			resources.visible = true
			resources.text = resources_label + ":"
			
			if blueprints.content[id].get("resource") != {}:
				for i in blueprints.content[id]["resource"]:
					check_material(id, i)
			else:
				resources.visible = false
		else:
			resources.visible = false
			button.disabled = false
		
		if blueprints.content[id].has("time"):
			if typeof(blueprints.content[id]["time"]) == TYPE_INT and description.text is String:
				if blueprints.content[id]["time"] > 0:
					var creation_time_label = tr("creation_time.craft")
					var creation_time_seconds = tr("time.craft")
					time_create.text = creation_time_label + ": " + str(blueprints.content[id]["time"]) +  creation_time_seconds
					time_create.visible = true
				else:
					time_create.visible = false
			else:
				print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The 'time' key has a non-integer type. Variant.type: " + str(typeof(blueprints.content[id]["time"])))
				time_create.visible = false
		else:
			print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The object does not have the 'time' key.")
			time_create.visible = false
		
		button.text = check_blueprint_type(id)
		button.visible = true
	else:
		button.visible = false

func blueprints_load(data:int) -> void:
	access.clear()
	access.append(data)

func check_blueprint_type(id) -> String:
	if blueprints.content.has(id):
		if blueprints.content[id].has("type"):
			var type_array = blueprints.content[index]["type"].keys() 
			match type_array[0]:
				"node":
					return tr("node.button_craft")
				"upgrade":
					return tr("upgrade.button_craft")
				"terrain":
					return tr("terrain.button_craft")
				_:
					return ""
	return "???"

func check_material(id, key) -> void:
	if resource(key) != null:
		if check_items(key) != null:
				if typeof(blueprints.content[id]["resource"][key]) != TYPE_STRING:
					resources.text = resources.text + "\n• " + str(resource(key)) + " (" + str(check_items(key)) + "/" + str(round(blueprints.content[index]["resource"][key])) + ")"
					check_button(id, key)
				else:
					print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The key '" + str(key) + "' does not blueprints an integer or float: " + str(typeof(blueprints.content[index]["resource"][key])))
		else:
			push_warning("The '" + str(key)+ "' material cannot be returned as a string. This material will not be taken into account.")
	else:
		print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: Invalid material: " + str(key))

func check_button(id, key = null) -> void:
	if blueprints.content[id].has("resource"):
		if blueprints.content[id]["resource"].has(key):
			if check_items(key) >= blueprints.content[id]["resource"][key]:
				button.disabled = false
			else:
				button.disabled = true
		else:
			button.disabled = false

func resource(key) -> Variant:
	if key in materials.resources:
		if items.content[materials.resources[key]].has("caption"):
			return items.content[materials.resources[key]]["caption"]
	return null

func check_items(key) -> Variant:
	if key in materials.resources:
		if inventory.inventory_items.has(materials.resources[key]):
			return inventory.inventory_items[materials.resources[key]]["amount"]
	return 0

func get_blueprints() -> Array:
	return access

func reset_data() -> void:
	caption.text = ""
	description.text = ""
	resources.visible = false
	time_create.visible = false
	button.visible = false

func check_window() -> void:
	visible = menu

func _on_button_pressed() -> void:
	window()
