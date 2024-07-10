extends Control

class_name Inventory
@onready var pause:Control = get_node("/root/World/UI/Pause")
@onready var blur:Control = get_node("/root/World/UI/Blur")
@onready var node:PackedScene = load("res://assets/nodes/UI/inventory/slot.tscn")
@onready var anim:AnimationPlayer = $Animation

@onready var info:BoxContainer = $Panel/HBoxContainer/ItemInfo/VBoxContainer
@onready var scroll_info:ScrollContainer = $Panel/HBoxContainer/ItemInfo
@onready var slots:GridContainer = $Panel/HBoxContainer/Slots/GridContainer
@onready var scroll_slots:ScrollContainer = $Panel/HBoxContainer/Slots

@onready var icon:TextureRect = $Panel/HBoxContainer/ItemInfo/VBoxContainer/ObjectSprite
@onready var caption:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/ObjectCaption
@onready var description:Label = $Panel/HBoxContainer/ItemInfo/VBoxContainer/ObjectDescription
@onready var item_list:Label = $Panel/StorageItemList

var menu:bool = false
var limit:int = 8
var items:Dictionary = {
	1: {"amount" = 1},
	2: {"amount" = 1},
	3: {"amount" = 1},
	4: {"amount" = 1},
	5: {"amount" = 1},
	6: {"amount" = 1},
}

func _ready():
	close()
	reset_data()

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		window()

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
	list_slots(items)
	update_list()

func close() -> void:
	pause.lock = false
	menu = false
	blur.blur(false)
	anim.play("close")
	delete_slots()

func get_data(index):
	var item = InventoryItems.new()
	scroll_info.scroll_vertical = 0
	if item.content.has(index):
		if item.content[index].has("icon"):
			if typeof(item.content[index]["icon"]) == TYPE_OBJECT and icon.texture is CompressedTexture2D:
				icon.visible = true
				icon.texture = item.content[index]["icon"]
			else:
				icon.visible = true
				push_error("The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(item.content[index]["icon"])))
		else:
			push_error("The object does not have the 'icon' key.")
			icon.visible = false

		if item.content[index].has("caption"):
			if typeof(item.content[index]["caption"]) == TYPE_STRING and caption.text is String:
				caption.visible = true
				caption.text = item.content[index]["caption"]
			else:
				caption.visible = false
				push_error("The 'caption' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["caption"])))
		else:
			push_error("The object does not have the 'caption' key.")
			caption.visible = false

		if item.content[index].has("description"):
			if typeof(item.content[index]["description"]) == TYPE_STRING and description.text is String:
				description.visible = true
				description.text = item.content[index]["description"]
			else:
				description.visible = false
				push_error("The 'description' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["description"])))
		else:
			push_error("The object does not have the 'description' key.")
			description.visible = false

		if item.content[index].has("type"):
			if typeof(item.content[index]["type"]) == TYPE_STRING and description.text is String:
				description.visible = true
				description.text = description.text + "\n" + "\nТип: " + item.content[index]["type"] + "\n\n"
			else:
				push_error("The 'type' key has a non-string type. Variant.type: " + str(typeof(item.content[index]["type"])))
		else:
			push_error("The object does not have the 'type' key.")

func reset_data() -> void:
	icon.visible = false
	caption.visible = false
	description.visible = false
	item_list.visible = false

func list_slots(list:Dictionary):
	for i in list:
		item_create(i)

func delete_slots():
	for child in slots.get_children():
		slots.remove_child(child)
		child.queue_free()

func item_create(i):
	var slot = node.instantiate()
	if slot.test(i):
		slots.add_child(slot)
		slot.set_data(i)
	#else:
		#push_error("Cannot load node. Invalid index: " + str(i))

func update_list():
	item_list.text = "Вместимость: " + str(list_slots_return(items)) + "/" + str(limit)
	item_list.visible = true

func list_slots_return(list:Dictionary):
	var item:int 
	for i in list:
		item+=1
	return item

func check_window() -> void:
	visible = menu

func _on_button_pressed():
	window()
