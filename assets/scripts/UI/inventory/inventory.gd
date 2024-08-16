extends Control

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")
@onready var build:Control = get_node("/root/World/User Interface/Windows/Crafting")
@onready var mailbox:Control = get_node("/root/World/User Interface/Windows/Mailbox")
@onready var node:PackedScene = load("res://assets/nodes/UI/Inventory/slot.tscn")
@onready var anim:AnimationPlayer = $Animation

@onready var info:BoxContainer = $Panel/HBoxContainer/ItemInfo/VBoxContainer
@onready var scroll_info:ScrollContainer = $Panel/HBoxContainer/ItemInfo
@onready var slots:GridContainer = $Panel/HBoxContainer/Slots/GridContainer
@onready var scroll_slots:ScrollContainer = $Panel/HBoxContainer/Slots

@onready var icon:TextureRect = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Icon
@onready var caption:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Caption/Caption
@onready var description:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Description/Description
@onready var specifications:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Specifications/Specifications
@onready var type:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Type/Type
@onready var button:Button = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Button/Button
@onready var list:Label = $Panel/StorageItemList

var menu:bool = false
var storage:Object = Storage.new()
var inventory_items:Dictionary = {}
enum item_type {
	seed,
}

func _ready():
	check_window()
	reset_data()

func _process(_delta):
	if !pause.paused\
	and !build.menu\
	and !mailbox.menu:
		if Input.is_action_just_pressed("inventory"):
			window()
		if Input.is_action_just_pressed("pause") and menu:
			close()

func open() -> void:
	menu = true
	pause.other_menu = true
	blur.blur(true)
	anim.play("open")
	list_slots(0, inventory_items)
	update_list()

func close() -> void:
	menu = false
	pause.other_menu = false
	blur.blur(false)
	anim.play("close")
	delete_slots()

func load(data:Dictionary) -> void:
	print(data)
	#inventory_items[data]

func get_data(index) -> void:
	if menu:
		var item = Items.new()
		scroll_info.scroll_vertical = 0
		if item.content.has(index):
			if item.content[index].has("icon"):
				if typeof(item.content[index]["icon"]) == TYPE_OBJECT:
					icon.visible = true
					icon.texture = item.content[index]["icon"]
				else:
					icon.visible = false
					push_error("[ID: "+str(index)+"] The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(item.content[index]["icon"])))
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
				icon.visible = false

			if item.content[index].has("caption"):
				if typeof(item.content[index]["caption"]) == TYPE_STRING:
					caption.visible = true
					caption.text = item.content[index]["caption"]
				else:
					caption.visible = false
					push_error("[ID: "+str(index)+"] The 'caption' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["caption"])))
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'caption' key.")
				caption.visible = false

			if item.content[index].has("description"):
				if typeof(item.content[index]["description"]) == TYPE_STRING:
					description.visible = true
					description.text = item.content[index]["description"]
				else:
					description.visible = false
					push_error("[ID: "+str(index)+"] The 'description' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["description"])))
			else:
				push_error("[ID: "+str(index)+"] The object does not have the 'description' key.")
				description.visible = false

			if item.content[index].has("specifications"):
				if item.content[index].get("specifications") != {}:
					specifications.visible = true
					specifications.text = ""
					for i in item.content[index]["specifications"]:
						get_specifications(index, i)
				else:
					specifications.visible = false
					push_error("[ID: "+str(index)+"] The 'specifications' key is empty.")
			else:
				specifications.visible = false
				push_error("[ID: "+str(index)+"] The 'specifications' key does not exist.")

			if item.content[index].has("type"):
				if typeof(item.content[index]["type"]) == TYPE_STRING:
					type.visible = true
					type.text = "\nТип: " + item.content[index]["type"] + "\n"
					check_item_type(item.content[index]["type"])
				else:
					type.visible = false
					push_error("[ID: "+str(index)+"] The 'type' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["type"])))
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

func list_slots(index:int, list:Dictionary):
	match index:
		0:
			for i in list:
				item_create(i)
		_: pass

func delete_slots() -> void:
	for child in slots.get_children():
		slots.remove_child(child)
		child.queue_free()

func item_create(i) -> void:
	var slot = node.instantiate()
	check_amount(i)
	if inventory_items[i]["amount"] > 0:
		slots.add_child(slot)
		slot.set_data(i, inventory_items[i]["amount"])
	else:
		remove_item(i)

func update_list() -> void:
	if storage.object[storage.level].has("slots"):
		var text = "Вместимость:"
		list.text = text + " " + str(list_slots_return()) + "/" + str(storage.object[storage.level]["slots"])
		list.visible = true
	else:
		push_error("The 'slots' element does not exist.")
		list.visible = false

func list_slots_return():
	if slots:
		var item:int = 0
		if slots.get_children() != []:
			for child in slots.get_children():
				item += 1
		return item
	else:
		push_error("Cannot load parent.")

func add_item(id:int, amount:int) -> void:
	if inventory_items.has(id):
		inventory_items[id]["amount"] += amount
	else:
		inventory_items[id] = {"amount": amount}
		
func remove_item(id:int):
	for key in inventory_items:
		if id == key:
			inventory_items.erase(key)

func check_slots() -> bool:
	if list_slots_return() <= storage.object[storage.level]["slots"]:
		return true
	else:
		return false

func check_amount(index) -> void:
	if inventory_items[index].has("amount"):
		if inventory_items[index]["amount"] > Items.new().content["max"]:
			inventory_items[index]["amount"] = Items.new().content["max"]
		if inventory_items[index]["amount"] < 0:
			inventory_items[index]["amount"] = 0
	else:
		push_warning("[ID: "+str(index)+"] The 'amount' element does not exist in the inventory dictionary (array).")
		inventory_items[index]["amount"] = 1

func get_specifications(index, i) -> void:
	if typeof(Items.new().content[index]["specifications"][i]) == TYPE_STRING and specifications.text is String:
		specifications.text = specifications.text + "\n• " + get_tip(i) + ": "+ Items.new().content[index]["specifications"][i]
	else:
		push_error("[ID: "+str(index)+"] The '"+ str(i) +"' element is not a string. Variant.type: " + str(typeof(Items.new().content[index]["specifications"][i])))

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
			button.visible = true
		_:
			button.visible = false

func window() -> void:
	if menu:
		close()
	else:
		open()

func check_window() -> void:
	visible = menu

func _on_button_pressed():
	print("Test")

func _on_close_pressed():
	if menu:
		close()
