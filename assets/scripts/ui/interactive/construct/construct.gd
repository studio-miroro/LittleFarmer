extends Control

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var notice:Control = get_node("/root/"+main+"/UI/Feedback/Notifications")
@onready var inventory:Control = get_node("/root/"+main+"/UI/Interactive/Inventory")
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var container:GridContainer = get_node("/root/"+main+"/UI/Interactive/Crafting/Panel/HBoxContainer/Items/GridContainer")
@onready var build_button:Button = get_node("/root/"+main+"/UI/Interactive/Crafting/Panel/HBoxContainer/Info/VBoxContainer/Button/Craft")

@onready var blueprint:PackedScene = load("res://assets/nodes/ui/interactive/construct/blueprint.tscn")
@onready var caption:Label = $Panel/HBoxContainer/Info/VBoxContainer/Caption/ObjectCaption
@onready var description:Label = $Panel/HBoxContainer/Info/VBoxContainer/Description/ObjectDescription
@onready var resources:Label = $Panel/HBoxContainer/Info/VBoxContainer/Resources/ObjectResources
@onready var time_create:Label = $Panel/HBoxContainer/Info/VBoxContainer/Time/ObjectCreationTime
@onready var button:Button = $Panel/HBoxContainer/Info/VBoxContainer/Button/Craft
@onready var anim:AnimationPlayer = $AnimationPlayer

var index:int
var menu:bool = false
var access:Array[int] = [1,2,3]
var all_items:bool

var items:Object = Items.new()
var blueprints:Object = Blueprints.new()
var materials:Object = BuildingMaterials.new()

func _ready():
	check_window()
	_reset_data()
	_remove_invalid_blueprints()

func _remove_invalid_blueprints() -> void:
	var items_to_remove = []
	for i in access:
		if !blueprints.content.has(i):
			items_to_remove.append(i)
	if items_to_remove != []:
		for item in items_to_remove:
			access.erase(item)
		data.debug("Unknown blueprints have been deleted: " + str(items_to_remove), "info")
	
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
	_start_info()
	_delete_all_blueprints()
	check_blueprints()
	
func close() -> void:
	menu = false
	pause.other_menu = false
	blur.blur(false)
	anim.play("close")
	_delete_all_blueprints()

func check_blueprints() -> void:
	if menu:
		for id in access:
			_create_item(id)

func _create_item(id) -> void:
	var item = blueprint.instantiate()
	if item.check_node(id):
		container.add_child(item)
		item.set_data(id)
	else:
		data.debug("Cannot load node. Invalid index: " + str(id), "error")

func _delete_all_blueprints() -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

func get_data(id):
	self.index = id
	button.id = id
	if blueprints.content.has(int(index)):
		if blueprints.content[int(index)].has("caption"):
			if blueprints.content[int(index)]["caption"] is String:
				caption.text = str(blueprints.content[int(index)]["caption"])
				caption.visible = true
			else:
				caption.text = ""
				caption.visible = false
				data.debug("The 'caption' key has a non-string type. Variant.type: " + str(typeof(blueprints.content[index]["caption"]), "error"))
		else:
			data.debug("The object does not have the 'caption' key.", "error")
			description.visible = false
			
		if blueprints.content[id].has("description"):
			if blueprints.content[id]["description"] is String:
				description.text = blueprints.content[id]["description"] + "\n"
				description.visible = true
			else:
				data.debug("The 'description' key has a non-string type. Variant.type: " + str(typeof(blueprints.content[index]["description"])), "error")
				description.visible = false
		else:
			data.debug("The object does not have the 'description' key.", "error")
			description.visible = false
		
		if blueprints.content[id].has("resource"):
			var resources_label = tr("necessary_resources.craft")
			resources.visible = true
			resources.text = resources_label + ":"

			get_all_required_items(id)
			check_all_required_items(id)
			if all_items:
				button.disabled = false
			else:
				button.disabled = true
		else:
			resources.visible = false
			button.disabled = false
		
		if blueprints.content[id].has("time"):
			if blueprints.content[id]["time"] is int:
				if blueprints.content[id]["time"] > 0:
					var creation_time_label = tr("creation_time.craft")
					var creation_time_seconds = tr("time.craft")
					time_create.text = creation_time_label + ": " + str(blueprints.content[id]["time"]) +  creation_time_seconds
					time_create.visible = true
				else:
					time_create.visible = false
			else:
				data.debug("The 'time' key has a non-integer type. Variant.type: " + str(typeof(blueprints.content[id]["time"])), "error")
				time_create.visible = false
		else:
			data.debug("The object does not have the 'time' key.", "error")
			time_create.visible = false
		
		button.text = check_blueprint_type(id)
		button.visible = true
	else:
		button.visible = false

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

func _get_resources(key) -> Variant:
	if key in materials.resources:
		if items.content[materials.resources[key]].has("caption"):
			return items.content[materials.resources[key]]["caption"]
	return null

func check_all_required_items(id) -> void:
	all_items = true
	for resource in blueprints.content[id]["resource"]:
		var required_amount = blueprints.content[id]["resource"][resource]
		var available_amount = inventory.get_item_amount(materials.resources[resource])
		if available_amount < required_amount:
			all_items = false
			break

func get_all_required_items(id) -> void:
	resources.text = ""
	for resource in blueprints.content[id]["resource"]:
		var required_amount = blueprints.content[id]["resource"][resource]
		var available_amount = inventory.get_item_amount(materials.resources[resource])
		var resource_caption = items.content[materials.resources[resource]]["caption"]
		resources.text += "• " + str(resource_caption) + " (" + str(available_amount) + "/" + str(required_amount) + ")\n"

func get_blueprints() -> Array:
	return access

func blueprints_load(content:int) -> void:
	access.append(content)

func blueprints_clear() -> void:
	access.clear()

func _start_info() -> void:
	var start_caption = tr("startinfo_header.craft")
	var start_description = tr("startinfo_description.craft")

	caption.text = start_caption
	description.text = start_description
	resources.text = ""
	time_create.text = ""
	caption.visible = true
	description.visible = true
	resources.visible = true
	time_create.visible = true
	button.visible = false

func _reset_data() -> void:
	caption.text = ""
	description.text = ""
	resources.text = ""
	time_create.text = ""
	caption.visible = false
	description.visible = false
	resources.visible = false
	time_create.visible = false
	button.visible = false

func check_window() -> void:
	visible = menu

func _on_button_pressed() -> void:
	window()
