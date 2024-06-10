extends Node

@onready var tilemap = get_node("/root/World/Tilemap")
@onready var cycle = get_node("/root/World/Cycle")
@onready var camera = get_node("/root/World/Player")
@onready var grid = get_node("/root/World/Buildings/Grid")
@onready var gridCollision = get_node("/root/World/Buildings/Grid/GridCollision")
@onready var farming = get_node("/root/World/Farming")
@onready var plant_node = preload("res://assets/nodes/farming/plant.tscn")
@onready var CustomVar = preload("res://assets/scripts/farming/plant.gd")
var path = "user://save.json" 
enum bootMenu {new,load}
var mode = bootMenu.new
var objectID = 0

func _process(delta):
	if Input.is_action_just_pressed("nothing"):
		print("Childs in Farming: ")
		for childs in farming.get_children():
			print(childs)

func gamesave():
	var json = JSON.new()
	var pizda = merge_dictionaries(get_children_data(farming), get_content())
	var json_string = JSON.stringify(pizda, "\t")
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_string(json_string)
	print(json_string)
	file.close()
	print("Save")

func file_load(file_path:String):
	var file = FileAccess.open(file_path,FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var parse_result = JSON.parse_string(json_string)
		return parse_result
	else:
		print("file not found: ", file_path)
		return {}

func get_key(group:String,key:String):
	var file = file_load(path)
	if file.has(str(group))\
	and typeof(file[str(group)]) == TYPE_DICTIONARY:
		var container = file[str(group)]
		if container.has(str(key)):
			return container[str(key)]
		return -1
		
func create_terrain(check:int, layer:int, key_layer:String, terrain_set:int, terrain:int):
	match check:
		0:
			var string_array = get_key("vectors", key_layer)
			var vector_array = []
			for str in string_array:
				var cleaned_str = str.replace("(", "").replace(")", "")
				var components = cleaned_str.split(",")
				var x = components[0].to_float()
				var y = components[1].to_float()
				vector_array.append(Vector2(x, y))
			
			for vector in vector_array:
				tilemap.set_cells_terrain_connect(
					layer,
					vector_array,
					terrain_set,
					terrain
					)
		1:
			var string_array = get_key("vectors", key_layer)
			var vector_array = []
			for str in string_array:
				var cleaned_str = str.replace("(", "").replace(")", "")
				var components = cleaned_str.split(",")
				var x = components[0].to_float()
				var y = components[1].to_float()
				vector_array.append(Vector2(x, y))
			
			for vector in vector_array:
					tilemap.set_cell(
						layer,
						vector,
						0,
						Vector2i(0,3)
					)
		2: 
			var string_array = get_key("vectors", key_layer)
			var vector_array = []
			for str in string_array:
				var cleaned_str = str.replace("(", "").replace(")", "")
				var components = cleaned_str.split(",")
				var x = components[0].to_float()
				var y = components[1].to_float()
				vector_array.append(Vector2(x, y))
			for vector in vector_array:
				return vector_array
				

func get_content() -> Dictionary:
	return {
		"game": {
			"version": ProjectSettings.get_setting("application/config/version"),
		},
		"player": {
			"X": camera.position.x,
			"Y": camera.position.y,
		},
		"world": {
			"time.year": gamedata.year,
			"time.month": gamedata.month,
			"time.week": gamedata.week,
			"time.day": gamedata.day,
			"time.hour": gamedata.hour,
			"time.minute": gamedata.minute,
		},
		"vectors": {
			"ground": grid.get_used_cells(gridCollision.ground_layer),
			"farmland": grid.get_used_cells(gridCollision.farming_layer),
			"watering": grid.get_used_cells(gridCollision.watering_layer),
			"plant.collision": grid.get_used_cells(gridCollision.seeds_layer),
			"plants": get_position_children(farming),
		}
	}
	
func gameload() -> void:
	time_load()
	terrains_remove()
	camera.position.x = get_key("player", "X")
	camera.position.y = get_key("player", "Y")
	create_nodes(farming, plant_node, create_terrain(2,gridCollision.seeds_layer, "plants", -1,-1))
	create_terrain(0,gridCollision.ground_layer,"ground",gridCollision.ground_terrain_set,gridCollision.ground_terrain)
	create_terrain(0,gridCollision.farming_layer,"farmland",gridCollision.farming_terrain_set,gridCollision.farming_terrain)
	create_terrain(0,gridCollision.watering_layer,"watering",gridCollision.watering_terrain_set,gridCollision.watering_terrain)
	create_terrain(1,gridCollision.seeds_layer,"plant.collision",-1,-1)
	print("--- \n * Game Load * \n---")

func get_position_children(parent:Node2D) -> Array:
	var children = parent.get_children()
	var coordinates = []
	for child in children:
		if child is Node2D:
			coordinates.append(tilemap.local_to_map(child.global_position))
	return coordinates

func create_nodes(parent:Node2D, node: PackedScene, positions: Array) -> void:
	remove_all_child(parent)
	for position in positions:
		var object = node.instantiate()
		if position is Vector2:
			objectID +=1
			object.name = "Plant_" + str(objectID)
			var object_name = "Plant_" + str(objectID)
			object.global_position = tilemap.map_to_local(position)
			object.z_index = 6
			print("[" + str(objectID) + "]" + " Node created: " + str(position))
			if object.has_method("check_node"):
				parent.add_child(object)
				plant_load(object, object_name, position)
			else:
				push_error("Cannot load node.")

func remove_all_child(parent: Node2D):
	var atlas_coords = Vector2i(0,3)
	var source_id = 0
	erase_cells(gridCollision.seeds_layer)
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	objectID = 0
	
func erase_cells(layer: int):
	var used_cells = tilemap.get_used_cells(layer)
	for cell in used_cells:
		tilemap.erase_cell(layer, cell)
		
func get_children_data(parent_node: Node2D) -> Dictionary:
	var data_dict = {}
	for child in parent_node.get_children():
		if child.has_method("get_data"):
			var child_data = child.get_data()
			data_dict[child.name] = child_data
	return data_dict

func merge_dictionaries(target_dict: Dictionary, original_dict: Dictionary) -> Dictionary:
	for key in original_dict.keys():
		var original_value = original_dict[key]
		if target_dict.has(key):
			var target_value = target_dict[key]
			if typeof(target_value) == TYPE_DICTIONARY and typeof(original_value) == TYPE_DICTIONARY:
				target_dict[key] = merge_dictionaries(target_value, original_value)
			else:
				target_dict[key] = target_value
		else:
			target_dict[key] = original_value
	return target_dict


func plant_load(object:Node2D, object_name:String, position):
	var plant_id = get_key(object_name, "plantID")
	var condition = get_key(object_name, "condition")
	var degree = get_key(object_name, "degree")
	var region_rect_x = get_key(object_name, "region_rect.x")
	var region_rect_y = get_key(object_name, "region_rect.y")
	var level = get_key(object_name, "level_growth")

	if plant_id != null and condition != null and degree != null:
		object.set_data(plant_id, condition, degree, region_rect_x, region_rect_y, level, position)
	else:
		push_error("Data missing for node: " + object_name)

## Funcs
func terrains_remove() -> void:
	if grid.get_used_cells(gridCollision.ground_layer) != []:
		tilemap.set_cells_terrain_connect(
		gridCollision.ground_layer,
		grid.get_used_cells(gridCollision.ground_layer),
		gridCollision.ground_terrain_set,
		-1)
	if grid.get_used_cells(gridCollision.farming_layer) != []:
		tilemap.set_cells_terrain_connect(
		gridCollision.farming_layer,
		grid.get_used_cells(gridCollision.farming_layer),
		gridCollision.farming_terrain_set,
		-1)
	if grid.get_used_cells(gridCollision.watering_layer) != []:
		tilemap.set_cells_terrain_connect(
		gridCollision.watering_layer,
		grid.get_used_cells(gridCollision.watering_layer),
		gridCollision.watering_terrain_set,
		-1)

func time_load() -> void:
	gamedata.year = get_key("world", "time.year")
	gamedata.month = get_key("world", "time.month")
	gamedata.week = get_key("world", "time.week")
	gamedata.day = get_key("world", "time.day")
	gamedata.hour = get_key("world", "time.hour")
	gamedata.minute = get_key("world", "time.minute")
	cycle.timeset()
