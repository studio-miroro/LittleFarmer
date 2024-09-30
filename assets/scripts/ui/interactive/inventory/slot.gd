extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/" + main_scene)
@onready var tip:Control = get_node("/root/" + main_scene + "/UI/Feedback/Tooltip")
@onready var inventory:Control = get_node("/root/" + main_scene + "/UI/Interactive/Inventory")
@onready var mailbox:Control = get_node("/root/" + main_scene + "/UI/Interactive/Mailbox")
@onready var signmenu:Control = get_node("/root/" + main_scene + "/UI/Interactive/BuildingsMenu/SignMenu")
@onready var buildings:Node = get_node("/root/" + main_scene + "/ConstructionManager")
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/Decorative/Blur")
@onready var icon:TextureRect = $Button/Icon
@onready var amount_label:Label = $Button/Amount

var id
var amount:int
var item:Object = Items.new()

func set_data(index, item_amount) -> void:
	self.id = index
	if item.content.has(int(id)):
		self.amount = item_amount
		if item.content[int(id)].has("icon"):
			if typeof(item.content[int(id)]["icon"]) == TYPE_OBJECT:
				icon.texture = item.content[int(id)]["icon"]
				icon.visible = true
			else:
				icon.visible = false
				data.debug("[ID: "+str(index)+"] The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(item.content[id]["icon"])), "error")
		else:
			icon.visible = false
			data.debug("[ID: "+str(index)+"] The object does not have the 'icon' key.", "error")
		
		if typeof(amount) == TYPE_INT and amount > 0:
			if amount > 1:
				amount_label.visible = true
				if amount > item.maximum:
					amount = item.maximum
				amount_label.text = str(amount)
			else:
				amount_label.visible = false
		else:
			data.debug("[ID: "+str(index)+"] The object does not have the 'icon' key.", "error")
			amount_label.visible = false
	else:
		data.debug("Invalid index: " + str(index), "error")

func _on_button_mouse_entered():
	if mailbox.menu:
		if item.content.has(int(id)):
			if item.content[int(id)].has("caption"):
				var item_amount:String = tr("x")
				tip.tooltip(
					item.content[int(id)]["caption"] + " [" + item_amount + str(amount) + "]"
					)
			else:
				print_debug("The 'caption' key is missing.", "error")
		else:
			data.debug("Invalid item ID: " + str(id))

	if signmenu.menu:
		if item.content.has(int(id)):
			if item.content[int(id)].has("caption"):
				tip.tooltip(
					item.content[int(id)]["caption"]
					)
			else:
				data.debug("The 'caption' key is missing.", "error")
		else:
			data.debug("Invalid item ID: " + str(id), "warning")

func _on_button_mouse_exited():
	if mailbox.menu\
	|| signmenu.menu:
		tip.tooltip("")

func _on_button_pressed():
	if inventory.visible:
			inventory.get_data(id)

	if signmenu.visible:
		if blur.state:
			for i in buildings.get_children():
				if i.name == signmenu.sign_name:
					i.set_sign_sprite(int(id))
					signmenu._close()
