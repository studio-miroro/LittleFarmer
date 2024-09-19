extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var tip = get_node("/root/" + main_scene + "/User Interface/System/Tooltip")
@onready var pause = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var grid = get_node("/root/" + main_scene + "/Buildings/Grid") 
@onready var player = get_node("/root/" + main_scene + "/Camera")
@onready var fume = get_node("/root/" + main_scene + "/Buildings/House/Fume")
@onready var ext:Sprite2D = $Sprite2D_2
@onready var sprite:Sprite2D = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" = "Дом",
		"description" = "Простой домик.",
		# Sprites
		"default" = load("res://Assets/Resources/Buildings/House/Level-1/object_0.png"),
		"hover" = load("res://Assets/Resources/Buildings/House/Level-1/object_1.png"),
	},
	2: {
		"caption" = "Дом",
		"description" = "Улучшенный деревянный домик.",
		"fume" 	= true,
		# Sprites
		"default" = load("res://Assets/Resources/Buildings/House/Level-2/object_0.png"),
		"hover" = load("res://Assets/Resources/Buildings/House/Level-2/object_1.png"),
		"ext_default" = load("res://assets/resources/buildings/house/level-2/ext_0.png"),
		"ext_hover"= load("res://assets/resources/buildings/house/level-2/ext_1.png"),
		
	}
}
func _ready():
	update()

func update():
	if object.has(level):
		if object[level].has("default"):
			sprite.texture = object[level]["default"]
			check_key("fume")
			check_key("ext")
				
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func check_key(key:String) -> void:
	match key:
		"fume":
			fume.emitting = object[level].has(key)
			fume.visible = object[level].has(key)
		"ext":
			if object[level].has("ext_default"):
				if (typeof(object[level]["ext_default"]) and typeof(object[level]["ext_hover"]) == TYPE_OBJECT)\
				and ext.texture is CompressedTexture2D:
					ext.visible = true
				else:
					ext.visible = false

func change_sprite(type:bool) -> void:
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.modes.NOTHING and distance < max_distance:
			check_sprite("hover")
			tip.tooltip(
				str(object[level]["caption"]) + "\n" +
				str(object[level]["description"]) + "\n" +
				"Уровень: " + str(level)
				)
	else:
		check_sprite("default")
		tip.tooltip("")

func check_sprite(key:String) -> void:
	if object.has(level):
		if object[level].has(key):
			if typeof(object[level][key]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
				sprite.texture = object[level][key]
			else:
				push_error("The specified sprite cannot be installed.")
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func get_data():
	if object.has(level):
		return {"level": level}

func load_data(obj_level:int) -> void:
	self.level = obj_level
	update()

func _on_area_2d_mouse_entered():
	if !blur.state:
		change_sprite(true)

func _on_area_2d_mouse_exited():
	change_sprite(false)
