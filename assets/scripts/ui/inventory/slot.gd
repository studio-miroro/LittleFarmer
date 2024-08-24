extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var tip:Control = get_node("/root/" + main_scene + "/User Interface/System/Tooltip")
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var mailbox:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Mailbox")

@onready var icon:TextureRect = $Button/Icon
@onready var amount_label:Label = $Button/Amount

var item:Object = Items.new()

var id:int
var amount:int

func _ready():
	amount_label.visible = false

func set_data(index, item_amount) -> void:
	self.id = index
	if item.content.has(id):
		self.amount = item_amount
		if item.content[int(id)].has("icon"):
			if typeof(item.content[int(id)]["icon"]) == TYPE_OBJECT:
				icon.texture = item.content[int(id)]["icon"]
				icon.visible = true
			else:
				icon.visible = false
				push_error("[ID: "+str(index)+"] The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(item.content[id]["icon"])))
		else:
			icon.visible = false
			push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
		
		if typeof(amount) == TYPE_INT and amount > 0:
			if amount > 1:
				amount_label.visible = true
				if amount > item.content["max"]:
					amount = item.content["max"]
				amount_label.text = str(amount)
			else:
				amount_label.visible = false
		else:
			push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
			amount_label.visible = false
	else:
		push_error("Invalid index: " + str(index))

func _on_button_mouse_entered():
	if mailbox.menu:
		if item.content.has(id):
			if item.content[id].has("caption"):
				tip.tooltip(
					item.content[id]["caption"] + " [" + str(amount) + "шт]"
					)
			else:
				push_error("The 'caption' key is missing.")
		else:
			push_warning("Invalid item ID: " + str(id))

func _on_button_mouse_exited():
	if mailbox.menu:
		tip.tooltip("")

func _on_button_pressed():
	inventory.get_data(id)
