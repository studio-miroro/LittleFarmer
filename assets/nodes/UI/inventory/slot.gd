extends Control

@onready var inventory:Control = get_node("/root/World/UI/HUD/Inventory")
@onready var icon:TextureRect = $Button/Icon
@onready var amount:Label = $Button/Amount

var item = InventoryItems.new()
var id:int

func _ready():
	amount.visible = false

func set_data(index) -> void:
	if item.content.has(index):
		self.id = index
	else:
		push_error("Invalid index: " + str(index))

func test(id) -> bool:
	if item.content.has(id):
		return true
	return false

func _on_button_pressed():
	inventory.get_data(id)
