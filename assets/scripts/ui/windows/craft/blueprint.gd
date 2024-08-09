extends Control

@onready var build = get_node("/root/World/User Interface/Windows/Crafting")
@onready var icon:TextureRect = $Button/HBoxContainer/MarginContainer/Icon
@onready var caption:Label = $Button/HBoxContainer/Caption
@onready var index:int

var store = StoreBuilding.new()

func set_data(id) -> void:
	if store.content.has(id):
		self.index = id
		if store.content[id].has("caption"):
			if typeof(store.content[id]["caption"]) == TYPE_STRING and caption.text is String:
				caption.text = str(store.content[index]["caption"])
			else:
				push_error("The 'caption' key has a non-string type. Variant.type: " + str(typeof(store.content[id]["caption"])))
		else:
			push_error("The object does not have the 'caption' key.")

		if store.content[id].has("icon"):
			if typeof(store.content[id]["icon"]) == TYPE_OBJECT and icon.texture is CompressedTexture2D:
				icon.texture = store.content[index]["icon"]
			else:
				push_error("The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(store.content[id]["icon"])))
		else:
			push_error("The object does not have the 'icon' key.")
		visible = true
	else:
		push_error("Invalid object index: " + str(id))
		queue_free()

func test(id) -> bool:
	if store.content.has(id):
		return true
	return false

func _on_button_pressed() -> void:
	build.get_data(index)