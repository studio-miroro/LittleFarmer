extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid") 
@onready var player = get_node("/root/World/Player")
@onready var fume = get_node("/root/World/Buildings/House/Fume")
@onready var ext:Sprite2D = $Sprite2D_2
@onready var sprite:Sprite2D = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" 		= "Дом",
		"description" 	= "Простой домик.",
		"default" 		= preload("res://Assets/Resources/Buildings/House/Level-1/object_0.png"),
		"hover" 		= preload("res://Assets/Resources/Buildings/House/Level-1/object_1.png"),
	},
	2: {
		"caption" 		= "Дом",
		"description" 	= "Улучшенный деревянный домик.",
		"default" 		= preload("res://Assets/Resources/Buildings/House/Level-2/object_0.png"),
		"hover" 		= preload("res://Assets/Resources/Buildings/House/Level-2/object_1.png"),
		"ext_default" 	= preload("res://assets/resources/buildings/house/level-2/ext_0.png"),
		"ext_hover" 	= preload("res://assets/resources/buildings/house/level-2/ext_1.png"),
		"fume" 			= true,
	}
}

func _ready():
	if object.has(level):
		if object[level].has("default"):
			sprite.texture = object[level]["default"]
			check_key("fume")
			check_key("ext")
				
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func check_key(key:String):
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
		if grid.mode == grid.gridmode.NOTHING\
		and distance < max_distance:
			if object.has(level):
				if object[level].has("hover"):
					sprite.texture = object[level]["hover"]
					ui.tooltip(get_global_mouse_position(), object[level]["caption"], object[level]["description"], level, 0, true)
					if object[level].get("ext_hover"):
						if typeof(object[level]["ext_hover"]) == TYPE_OBJECT and ext.texture is CompressedTexture2D:
							ext.texture = object[level]["ext_hover"]
						else:
							push_error("Error: The 'ext_hover' key stores a type that is not an object.")
				else:
					push_error("There is no key at index " + str(level) + ".")
			else:
				push_error("Index " + str(level) + " is not in the dictionary.")
	else:
		if object.has(level):
			if object[level].has("default"):
				sprite.texture = object[level]["default"]
				ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
				if object[level].get("ext_default"):
					if typeof(object[level]["ext_default"]) == TYPE_OBJECT\
					and ext.texture is CompressedTexture2D:
						ext.texture = object[level]["ext_default"]
					else:
						push_error("Error: The 'ext_default' key stores a type that is not an object.")
			else:
				push_error("There is no object at index " + str(level) + ".")
		else:
			push_error("Index " + str(level) + " is not in the dictionary.")

func get_data(keys:String):
	match keys:
		"level":
			return level

func _on_area_2d_mouse_entered():
	change_sprite(true)

func _on_area_2d_mouse_exited():
	change_sprite(false)
