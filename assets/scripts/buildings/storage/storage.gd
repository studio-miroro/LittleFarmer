extends Node2D

class_name Storage
@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/UI/Windows/Pause")
@onready var tip:Control = get_node("/root/" + main_scene + "/UI/GUI/Tooltip")
@onready var inventory:Control = get_node("/root/" + main_scene + "/UI/Windows/Inventory")
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/GUI/Blur")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid") 
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")
#@onready var shadow:Sprite2D = get_node("/root/" + main_scene + "/Shadow/StorageShadow")
@onready var sprite:Sprite2D = $Sprite2D

var menu:bool = false
var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" = tr("storage_lvl1.caption"),
		"description" = tr("storage_lvl1.description"),
		"slots" = 12,
		"default" = load("res://Assets/Resources/Buildings/Storage/Level-1/object_0.png"),
		"hover" = load("res://Assets/Resources/Buildings/Storage/Level-1/object_1.png"),
		"shadow" = load("res://Assets/Resources/Buildings/Storage/Level-1/shadow.png"),
	},
	2: {
		"caption" = tr("storage_lvl2.caption"),
		"description" = tr("storage_lvl2.description"),
		"slots" = 24,
		"default" = load("res://Assets/Resources/Buildings/Storage/Level-2/object_0.png"),
		"hover" = load("res://Assets/Resources/Buildings/Storage/Level-2/object_1.png"),
		"shadow" = load("res://Assets/Resources/Buildings/Storage/Level-2/shadow.png"),
	},
}

func _input(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and menu:
		inventory.open()
		menu = false

func _ready():
	update()

func update():
	if object.has(level):
		if object[level].has("default"):
			sprite.texture = object[level]["default"]
			#if object[level].has("shadow"):
			#	shadow.texture = object[level]["shadow"]
			#else:
			#	print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The object shadow sprite is missing.")
		else:
			print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: There is no key at index " + str(level) + ".")
	else:
		print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: Index " + str(level) + " is not in the dictionary.")

func _change_sprite(type:bool):
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.modes.NOTHING and distance < max_distance:
			_check_sprite("hover")
			var level_text = tr("object.level")
			tip.tooltip(
				str(object[level]["caption"]) + "\n" +
				str(object[level]["description"]) + "\n" +
				str(level_text) + str(level)
				)
			menu = true
	else:
		_check_sprite("default")
		tip.tooltip("")
		menu = false

func _check_sprite(key:String):
	if object.has(level):
		if object[level].has(key):
			if typeof(object[level][key]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
				sprite.texture = object[level][key]
			else:
				print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The specified sprite cannot be installed.")
		else:
			print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: There is no key at index " + str(level) + ".")
	else:
		print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: Index " + str(level) + " is not in the dictionary.")

func get_data():
	if object.has(level):
		return {"level": level}

func load_data(obj_level:int) -> void:
	self.level = obj_level
	update()

func _on_area_2d_mouse_entered():
	if !blur.state:
		_change_sprite(true)

func _on_area_2d_mouse_exited():
	_change_sprite(false)
