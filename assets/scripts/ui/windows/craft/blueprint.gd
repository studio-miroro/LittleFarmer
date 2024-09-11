extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var build = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting")
@onready var icon:TextureRect = $Button/HBoxContainer/MarginContainer/Icon
@onready var caption:Label = $Button/HBoxContainer/Caption
@onready var index:int

var blueprints = Blueprints.new()

func set_data(id) -> void:
	if blueprints.content.has(id):
		self.index = id
		if blueprints.content[id].has("caption"):
			if typeof(blueprints.content[id]["caption"]) == TYPE_STRING and caption.text is String:
				caption.text = str(blueprints.content[index]["caption"])
			else:
				push_error("The 'caption' key has a non-string type. Variant.type: " + str(typeof(blueprints.content[id]["caption"])))
		else:
			push_error("The object does not have the 'caption' key.")

		if blueprints.content[id].has("icon"):
			if typeof(blueprints.content[id]["icon"]) == TYPE_OBJECT and icon.texture is CompressedTexture2D:
				icon.texture = blueprints.content[index]["icon"]
			else:
				push_error("The key stores a non-Compressed 2D Texture. Variant.type: " + str(typeof(blueprints.content[id]["icon"])))
		else:
			push_error("The object does not have the 'icon' key.")
		visible = true
	else:
		push_error("Invalid object index: " + str(id))
		queue_free()

func check_node(id) -> bool:
	if blueprints.content.has(id):
		return true
	return false

func _on_button_pressed() -> void:
	build.get_data(index)
