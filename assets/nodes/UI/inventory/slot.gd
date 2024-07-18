extends Control

@onready var inventory:Control = get_node("/root/World/UI/HUD/Inventory")
@onready var icon:TextureRect = $Button/Icon
@onready var amount:Label = $Button/Amount

var item:Object = Items.new()
var id:int

func _ready():
	amount.visible = false

func set_data(index,_amount) -> void:
	if item.content.has(index):
		self.id = index
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

func _on_button_pressed():
	inventory.get_data(id)
