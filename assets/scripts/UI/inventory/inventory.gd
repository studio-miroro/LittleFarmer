extends Control

class_name Inventory
@onready var pause:Control = get_node("/root/World/UI/Pause")
@onready var blur:Control = get_node("/root/World/UI/Blur")
@onready var build:Control = get_node("/root/World/UI/Pop-up Menu/BuildingMenu")
@onready var node:PackedScene = load("res://assets/nodes/UI/inventory/slot.tscn")
@onready var anim:AnimationPlayer = $Animation

@onready var info:BoxContainer = $Panel/HBoxContainer/ItemInfo/VBoxContainer
@onready var scroll_info:ScrollContainer = $Panel/HBoxContainer/ItemInfo
@onready var slots:GridContainer = $Panel/HBoxContainer/Slots/GridContainer
@onready var scroll_slots:ScrollContainer = $Panel/HBoxContainer/Slots

@onready var icon:TextureRect = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Icon
@onready var caption:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Caption
@onready var description:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Description
@onready var specifications:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Specifications
@onready var type:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/Type
@onready var list:Label = $Panel/StorageItemList

var storage:Object = Storage.new()
var menu:bool = false
var _items:Dictionary = {}

func _ready():
	close()
	reset_data()

func _process(delta):
	if !pause.paused\
	and !build.menu:
		if Input.is_action_just_pressed("inventory") and blur.blur:
			window()
		if Input.is_action_just_pressed("menu") and menu:
			close()
		if Input.is_action_just_pressed("test"):
			_items[add(_items)] = {}

func window() -> void:
	if menu:
		close()
	else:
		open()

func open() -> void:
	pause.lock = true
	menu = true
	blur.blur(true)
	anim.play("open")
	list_slots(0,_items)
	update_list()

func close() -> void:
	pause.lock = false
	menu = false
	blur.blur(false)
	anim.play("close")
	delete_slots()

func get_data(index) -> void:
	var item = Items.new()
	scroll_info.scroll_vertical = 0
	if item.content.has(index):
		if item.content[index].has("icon"):
			if typeof(item.content[index]["icon"]) == TYPE_OBJECT and icon.texture is CompressedTexture2D:
				icon.visible = true
				icon.texture = item.content[index]["icon"]
			else:
				icon.visible = false
				push_error("[ID: "+str(index)+"] The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(item.content[index]["icon"])))
		else:
			push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
			icon.visible = false

		if item.content[index].has("caption"):
			if typeof(item.content[index]["caption"]) == TYPE_STRING and caption.text is String:
				caption.visible = true
				caption.text = item.content[index]["caption"]
			else:
				caption.visible = false
				push_error("[ID: "+str(index)+"] The 'caption' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["caption"])))
		else:
			push_error("[ID: "+str(index)+"] The object does not have the 'caption' key.")
			caption.visible = false

		if item.content[index].has("description"):
			if typeof(item.content[index]["description"]) == TYPE_STRING and description.text is String:
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
			if typeof(item.content[index]["type"]) == TYPE_STRING and type.text is String:
				type.visible = true
				type.text = "\nТип: " + item.content[index]["type"] + "\n\n"
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

func list_slots(index:int, list:Dictionary):
	match index:
		0:
			for i in list:
				item_create(i)
		1:
			var t:int
			for i in list:
				t+=1
			return t
		_:
			pass

func delete_slots() -> void:
	for child in slots.get_children():
		slots.remove_child(child)
		child.queue_free()

func item_create(i) -> void:
	var slot = node.instantiate()
	if slot.test(i):
		check_amount(i)
		slots.add_child(slot)
		slot.set_data(i, _items[i]["amount"])
	else:
		push_error("Cannot load node. Invalid index: " + str(i))

func update_list() -> void:
	if storage.object[storage.level].has("slots"):
		list.text = "Вместимость: " + str(list_slots_return()) + "/" + str(storage.object[storage.level]["slots"])
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
		return item
	else:
		push_error("Cannot load parent.")

func add(cs): # delete
	var item:int = 1
	for i in cs:
		item+=1
	return item

func check_slots() -> bool:
	if list_slots_return() <= storage.object[storage.level]["slots"]:
		return true
	else:
		return false

func check_amount(index) -> void:
	if _items[index].has("amount"):
		if _items[index]["amount"] > Items.new().content["max"]:
			_items[index]["amount"] = Items.new().content["max"]
	else:
		push_warning("[ID: "+str(index)+"] The 'amount' element does not exist in the inventory dictionary (array).")
		_items[index]["amount"] = 1

func get_specifications(index, i):
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
			

func check_window() -> void:
	visible = menu

func _on_button_pressed() -> void:
	close()
