extends Control

@onready var node:ColorRect = $ColorRect

var max_blur:float = 1.5
var min_blur:float = 0.0
var speed:float = 0.1
var value:float = 0
var state:bool = false

func _process(_delta):
	if state:
		if value < max_blur:
			value = value + speed
	else:
		if value > min_blur:
			value = value - speed

	node.material.set_shader_parameter("lod", value)

func blur(bluring:bool, change_scene:bool = false, path:String = "") -> void:
	var main_scene = str(get_tree().root.get_child(1).name)

	self.state = bluring
	get_node("/root/" + main_scene + "/User Interface/Hud")._visible(bluring)
	get_node("/root/" + main_scene + "/User Interface/System/Tooltip").tooltip()
	get_node("/root/" + main_scene + "/Camera").switch = bluring
	if bluring:
		if has_node("/root/" + main_scene + "/Buildings/"):
			if has_node("/root/" + main_scene + "/Buildings/House"):
				get_node("/root/" + main_scene + "/Buildings/House").change_sprite(false)
			if has_node("/root/" + main_scene + "/Buildings/Mailbox"):
				get_node("/root/" + main_scene + "/Buildings/Mailbox").change_sprite(false)
			if has_node("/root/" + main_scene + "/Buildings/Storage"):
				get_node("/root/" + main_scene + "/Buildings/Storage").change_sprite(false)
			if has_node("/root/" + main_scene + "/Buildings/Animal Stall"):
				get_node("/root/World/Buildings/Animal Stall").change_sprite(false)
			if has_node("/root/" + main_scene + "/Buildings/Silo"):
				get_node("/root/" + main_scene + "/Buildings/Silo").change_sprite(false)

	if (change_scene && path != ""):
		await get_tree().create_timer(1.25).timeout
		var result = get_tree().change_scene_to_file(path)

		if result == OK:
			get_tree().change_scene_to_file(path)
		else:
			match result:
				ERR_CANT_OPEN:
					push_warning("Error: Can't open the scene file.")

				ERR_FILE_NOT_FOUND:
					push_warning("Error: Scene file not found.")

				ERR_INVALID_DATA:
					push_warning("Error: Invalid scene file format.")

				ERR_FILE_CORRUPT:
					push_warning("Error: Scene file is corrupt.")

				ERR_UNAVAILABLE:
					push_warning("Error: The scene is unavailable.")

				_:
					push_warning("An unknown error occurred: ", result)
