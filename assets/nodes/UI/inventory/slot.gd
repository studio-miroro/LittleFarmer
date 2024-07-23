extends Control

@onready var tip:Control = get_node("/root/World/UI/HUD/Tooltip")
@onready var inventory:Control = get_node("/root/World/UI/HUD/Inventory")
@onready var mailbox:Control = get_node("/root/World/UI/Pop-up Menu/Mailbox")

@onready var icon:TextureRect = $Button/Icon
@onready var amount:Label = $Button/Amount

var item:Object = Items.new()

var id:int
var __amount:int

func _ready():
	amount.visible = false

func set_data(index,_amount) -> void:
	if item.content.has(index):
		self.id = index
		self.__amount = _amount
		if item.content[index].has("icon"):
			if typeof(item.content[index]["icon"]) == TYPE_OBJECT and icon.texture == CompressedTexture2D:
				icon.texture = item.content[index]["icon"]
			else:
				icon.visible = false
				push_error("[ID: "+str(index)+"] The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(item.content[index]["icon"])))
		else:
			icon.visible = false
			push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
		
		if typeof(_amount) == TYPE_INT and _amount > 0:
			if _amount > 1:
				amount.visible = true
				if _amount > item.content["max"]:
					_amount = item.content["max"]
				amount.text = str(_amount)
			else:
				amount.visible = false
		else:
			push_error("[ID: "+str(index)+"] The object does not have the 'icon' key.")
			amount.visible = false
	else:
		push_error("Invalid index: " + str(index))

func test(id) -> bool:
	if item.content.has(id):
		return true
	return false

func _on_button_mouse_entered():
	if mailbox.menu:
		if item.content.has(id):
			if item.content[id].has("caption"):
				tip.tooltip(
					item.content[id]["caption"] + " [" + str(__amount) + "шт]"
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
