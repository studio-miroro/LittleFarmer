extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var build:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting")
@onready var mailbox:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Mailbox")
@onready var storage:Node2D = get_node("/root/" + main_scene + "/Buildings/Storage")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")
@onready var node:PackedScene = load("res://assets/nodes/UI/Inventory/slot.tscn")
@onready var anim:AnimationPlayer = $Animation

@onready var info:BoxContainer = $Panel/HBoxContainer/ItemInfo/VBoxContainer
@onready var scroll_info:ScrollContainer = $Panel/HBoxContainer/ItemInfo
@onready var slots:GridContainer = $Panel/HBoxContainer/Slots/GridContainer
@onready var scroll_slots:ScrollContainer = $Panel/HBoxContainer/Slots

@onready var icon:TextureRect = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Icon/Icon
@onready var caption:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Caption/Caption
@onready var description:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Description/Description
@onready var specifications:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Specifications/Specifications
@onready var type:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Type/Type
@onready var button:Button = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Button/Button
@onready var list:Label = $Panel/StorageItemList

var menu:bool = false
var inventory_items:Dictionary = {}

var item_index
var button_index:int
enum item_type {
	NOTHING,
	SEEDS,
}

func _ready():
	check_window()
	reset_data()
	
func _process(_delta):
	if !blur.state:
		if Input.is_action_just_pressed("inventory"):
			window()
	else:
		if (Input.is_action_just_pressed("pause") && menu) or (Input.is_action_just_pressed("inventory") && menu):
			close()

func load_content(data:Dictionary) -> void:
	inventory_items = data

func open() -> void:
	menu = true
	pause.other_menu = true
	blur.blur(true)
	anim.play("open")
	create_all_items()
	update_string_capacity()

func close() -> void:
	menu = false
	pause.other_menu = false
	blur.blur(false)
	anim.play("close")
	remove_inventory_slots()

func get_data(index) -> void:
	if menu:
		var item = Items.new()
		self.item_index = index
		scroll_info.scroll_vertical = 0

		if item.content.has(int(index)):
			if item.content[int(index)].has("icon"):
				if typeof(item.content[int(index)]["icon"]) == TYPE_OBJECT:
					icon.visible = true
					icon.texture = item.content[int(index)]["icon"]
				else:
					icon.visible = false
					push_error("[ID: "+str(index)+"] The key stores a non-Compressed 2D Texture.")
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
				icon.visible = false

			if item.content[int(index)].has("caption"):
				if typeof(item.content[int(index)]["caption"]) == TYPE_STRING:
					caption.visible = true
					caption.text = item.content[int(index)]["caption"]
				else:
					caption.visible = false
					push_error("[ID: "+str(index)+"] The 'caption' key has a non-string type.")
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'caption' key.")
				caption.visible = false

			if item.content[int(index)].has("description"):
				if typeof(item.content[int(index)]["description"]) == TYPE_STRING:
					description.visible = true
					description.text = item.content[int(index)]["description"]
				else:
					description.visible = false
					push_error("[ID: "+str(index)+"] The 'description' key has a non-string type.")
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'description' key.")
				description.visible = false

			if item.content[int(index)].has("specifications"):
				if item.content[int(index)].get("specifications") != {}:
					specifications.visible = true
					specifications.text = ""
					for i in item.content[int(index)]["specifications"]:
						get_specifications(int(index), i)
				else:
					specifications.visible = false
					push_warning("[ID: "+str(index)+"] The 'specifications' key is empty.")
			else:
				specifications.visible = false

			if item.content[int(index)].has("type"):
				if typeof(item.content[int(index)]["type"]) == TYPE_STRING:
					type.visible = true
					type.text = "\nТип: " + item.content[int(index)]["type"] + "\n"
					check_item_type(item.content[int(index)]["type"])
				else:
					type.visible = false
					push_error("[ID: "+str(index)+"] The 'type' key has a non-string type.")
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'type' key.")
		else:
			push_error("The object does not have the 'type' key.")

func reset_data() -> void:
	icon.visible = false
	caption.visible = false
	description.visible = false
	specifications.visible = false
	type.visible = false
	list.visible = false
	button.visible = false

func get_items() -> Dictionary:
	return inventory_items

func create_all_items() -> void:
	for item in inventory_items:
		if Items.new().content.has(int(item)):
			item_create(item)

func remove_inventory_slots() -> void:
	for item in slots.get_children():
		slots.remove_child(item)
		item.queue_free()

func item_create(id) -> void:
	var slot = node.instantiate()
	check_amount(id)
	if inventory_items.has(id):
		if inventory_items[id]["amount"] > 0:
			slots.add_child(slot)
			slot.set_data(id, inventory_items[id]["amount"])
		else:
			remove_item(id)
			push_error("Invalid item index: " + str(id))

func update_string_capacity() -> void:
	if has_node("/root/" + main_scene + "/Buildings"):
		if has_node("/root/" + main_scene + "/Buildings/Storage"):
			if storage.object[storage.level].has("slots"):
				var text = "Вместимость:"
				list.text = text + " " + str(get_all_items()) + "/" + str(storage.object[storage.level]["slots"])
				list.visible = true
			else:
				push_error("The 'slots' element does not exist.")
				list.visible = false
		else:
			push_error("In the parent of 'Buildings'  there is no child node 'Storage'")
	else:
		push_error("There is no parent of 'Buildings' in the '" + main_scene + "' scene")

func get_all_items() -> int:
	if slots:
		var item:int = 0
		if inventory_items != {}:
			for i in inventory_items:
				if Items.new().content.has(int(i)):
					item += 1
		return item
	else:
		push_error("Cannot load parent.")
		return 0

func add_item(id:int, amount:int) -> void:
	if inventory_items.has(id):
		inventory_items[id]["amount"] += amount
	else:
		inventory_items[id] = {"amount": amount}
		
func subject_item(item_id, item_amount:int) -> void:
	for key in inventory_items:
		if item_id == key:
			inventory_items[item_id]["amount"] -= item_amount 

func remove_item(id) -> void:
	for key in inventory_items:
		if id == key:
			inventory_items.erase(key)

func get_item_amount(item_id) -> int:
	if inventory_items.has(item_id) and inventory_items[item_id].has("amount"):
		if inventory_items[item_id]["amount"] > 0:
			return inventory_items[item_id]["amount"]
		else:
			return 0
	return 0

func check_item_amount(id) -> bool:
	if inventory_items.has(id):
		if inventory_items[id].has("amount"):
			if inventory_items[id]["amount"] > 0:
				return true
			else:
				remove_item(id)
				return false
		else: return false
	return false

func check_amount(index) -> void:
	if inventory_items.has(index):
		if inventory_items[index].has("amount"):
			if inventory_items[index]["amount"] > Items.new().content["max"]:
				inventory_items[index]["amount"] = Items.new().content["max"]
			if inventory_items[index]["amount"] < 0:
				inventory_items[index]["amount"] = 0
		else:
			push_warning("[ID: " + str(index) + "] The 'amount' element does not exist in the inventory dictionary (array).")
			inventory_items[index]["amount"] = 1

func get_specifications(index, i) -> void:
	if typeof(Items.new().content[index]["specifications"][i]) == TYPE_STRING and specifications.text is String:
		specifications.text = specifications.text + "\n• " + get_tip(i) + ": "+ Items.new().content[index]["specifications"][i]
	else:
		push_error("[ID: "+str(index)+"] The '"+ str(i) +"' element is not a string.")


func get_tip(tip:String) -> String:
	match tip:
		"growth":
			return "Время роста"
		"productivity":
			return "Урожайность"
		"conditions":
			return "Условия"
		_:
			return ""

func check_item_type(i_type:String) -> void:
	match i_type:
		"Семена":
			button_index = item_type.SEEDS
			button.text = tr("Посадить семена")
			button.visible = true
		_:
			button_index = item_type.NOTHING
			button.visible = false

func _on_button_pressed():
	match button_index:
		item_type.SEEDS:
			close()
			if Items.new().content.has(int(item_index)):
				if Items.new().content[int(item_index)].has("crop"):
					grid.inventory_item = item_index
					grid.plantID = Items.new().content[int(item_index)]["crop"]
					grid.mode = grid.modes.PLANTED
					grid.visible = true
				else:
					push_error("The 'crop' key does not exist")
			else:
				push_error("The numerical ID (" + item_index + ") of this crop is missing in the main file crops.gd")
		_:
			pass

func window() -> void:
	if menu:
		close()
	else:
		open()

func check_window() -> void:
	visible = menu

func _on_close_pressed():
	if menu:
		close()
