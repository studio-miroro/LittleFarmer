extends Node2D

class_name Storage
@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var inventory:Control = get_node("/root/"+main+"/UI/Interactive/Inventory")
@onready var tip:Control = get_node("/root/"+main+"/UI/Feedback/Tooltip")
@onready var grid:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid") 
@onready var player:CharacterBody2D = get_node("/root/"+main+"/Player")
#@onready var shadow:Sprite2D = get_node("/root/"+main+"/Shadow/StorageShadow")
@onready var sprite:Sprite2D = $Sprite2D

var menu:bool = false
var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" = tr("storage_lvl1.caption"),
		"description" = tr("storage_lvl1.description"),
		"slots" = 12,
		"default" = load("res://assets/resources/buildings/storage/level_1/object_0.png"),
		"hover" = load("res://assets/resources/buildings/storage/level_1/object_1.png"),
		"shadow" = load("res://assets/resources/buildings/storage/level_1/shadow.png"),
	},
	2: {
		"caption" = tr("storage_lvl2.caption"),
		"description" = tr("storage_lvl2.description"),
		"slots" = 24,
		"default" = load("res://assets/resources/buildings/storage/level_2/object_0.png"),
		"hover" = load("res://assets/resources/buildings/storage/level_2/object_1.png"),
		"shadow" = load("res://assets/resources/buildings/storage/level_2/shadow.png"),
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
			#	print_debug("\n"+str(data:Node2D.get_system_datetime()) + " ERROR: The object shadow sprite is missing.")
		else:
			data.debug("There is no key at index " + str(level), "error")
	else:
		data.debug("Index " + str(level) + " is not in the dictionary.", "error")

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
				data.debug("The specified sprite cannot be installed.", "error")
		else:
			data.debug("There is no key at index " + str(level), "error")
	else:
		data.debug("Index " + str(level) + " is not in the dictionary.", "error")

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
