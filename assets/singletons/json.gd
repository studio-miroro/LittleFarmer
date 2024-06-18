extends Node

@onready var plant_node:PackedScene = preload("res://assets/nodes/farming/plant.tscn")
@onready var tilemap:TileMap 		= get_node("/root/World/Tilemap")
@onready var cycle:Node2D 			= get_node("/root/World/Cycle")
@onready var camera:Node2D 			= get_node("/root/World/Player")
@onready var grid:Node2D 			= get_node("/root/World/Buildings/Grid")
@onready var gridCollision:Node2D 	= get_node("/root/World/Buildings/Grid/GridCollision")
@onready var farming:Node2D 		= get_node("/root/World/Farming")
@onready var house:Node2D			= get_node("/root/World/Buildings/House")
@onready var storage:Node2D			= get_node("/root/World/Buildings/Storage")
@onready var animal_stall:Node2D	= get_node("/root/World/Buildings/Animal stall")
@onready var silo:Node2D			= get_node("/root/World/Buildings/Silo")

var object_created:int
var path = {
	game	= "user://game.json",
	world	= "user://world.json",
	player	= "user://player.json",
	builds	= "user://builds.json",
	plants	= "user://plants.json",
	vectors	= "user://vectors.json",
}

func gamesave() -> void:
	file_save(path.game, "Game")
	file_save(path.world, "World")
	file_save(path.player, "Player")
	file_save(path.builds, "Builds")
	file_save(path.plants, "Plants")
	file_save(path.vectors, "Vectors")

func gameload() -> void:
	remove_all_child(farming)
	terrains_remove()
	time_load()
	player_load()
	create_nodes(farming, plant_node, create_terrain(2, gridCollision.seeds_layer, path.vectors, "Plants", -1, -1))
	create_terrain(0, gridCollision.ground_layer, path.vectors, "Grounds", gridCollision.ground_terrain_set, gridCollision.ground_terrain)
	create_terrain(0, gridCollision.farming_layer, path.vectors, "Farmlands", gridCollision.farming_terrain_set, gridCollision.farming_terrain)
	create_terrain(0, gridCollision.watering_layer, path.vectors, "Waterings", gridCollision.watering_terrain_set, gridCollision.watering_terrain)
	create_terrain(1, gridCollision.seeds_layer, path.vectors, "Plants", 0, 0)

func file_save(path_file, content) -> void:
	var json_string = JSON.stringify(get_content(content), "\t")
	var file = FileAccess.open(path_file,FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	
func file_load(path_file) -> Dictionary:
	var file = FileAccess.open(path_file,FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		var parse_result = JSON.parse_string(json_string)
		return parse_result
	else:
		push_error("file not found: ", path)
		return {}
		
func get_key(path_file, group:String, key:String):
	var file = file_load(path_file)
	if file.has(str(group))\
	and typeof(file[str(group)]) == TYPE_DICTIONARY:
		var container = file[str(group)]
		if container.has(str(key)):
			return container[str(key)]
		return -1

func create_terrain(index:int, layer:int, path, key:String, terrain_set:int, terrain:int):
	match index:
		0:
			var string_array = get_key(path, "Vectors", key)
			var vector_array = []
			for str in string_array:
				var cleaned_str = str.replace("(", "").replace(")", "")
				var components = cleaned_str.split(",")
				var x = components[0].to_float()
				var y = components[1].to_float()
				vector_array.append(Vector2(x, y))
				
				tilemap.set_cells_terrain_connect(
					layer,
					vector_array,
					terrain_set,
					terrain
					)
		1:
			var string_array = get_key(path, "Vectors", key)
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
			var string_array = get_key(path, "Vectors", key)
			var vector_array = []
			for str in string_array:
				var cleaned_str = str.replace("(", "").replace(")", "")
				var components = cleaned_str.split(",")
				var x = components[0].to_float()
				var y = components[1].to_float()
				vector_array.append(Vector2(x, y))
				
			for vector in vector_array:
				return vector_array

func get_content(group:String):
	match group:
		"Game":
			return {
				"Game": {
					"Version": ProjectSettings.get_setting("application/config/version"),
				}
			}
		"Player":
			return {
				"Player": {
					"X": round(camera.position.x),
					"Y": round(camera.position.y),
					"Balance": camera.money,
				}
			}
		"World":
			return {
				"World": {
					"Year": cycle.year,
					"Month": cycle.month,
					"Week": cycle.week,
					"Day": cycle.day,
					"Hour": cycle.hour,
					"Minute": cycle.minute,
				}
			}
		"Vectors":
			return {
				"Vectors": {
					"Grounds": grid.get_used_cells(gridCollision.ground_layer),
					"Farmlands": grid.get_used_cells(gridCollision.farming_layer),
					"Waterings": grid.get_used_cells(gridCollision.watering_layer),	
					"Plants": get_position_children(farming),
				}
			}
		"Plants":
			return get_children_data(farming)
		"Builds":
			return {
				"House": {
					"Level": house.get_datat(),
				}
			}

func get_position_children(parent:Node2D) -> Array:
	var children = parent.get_children()
	var coordinates = []
	for child in children:
		if child is Node2D:
			coordinates.append(tilemap.local_to_map(child.global_position))
	return coordinates

func create_nodes(parent:Node2D, node: PackedScene, positions) -> void:
	if positions != null:
		for position in positions:
			var object = node.instantiate()
			if position is Vector2:
				object_created +=1
				object.name = "Plant_" + str(object_created)
				var object_name = "Plant_" + str(object_created)
				object.global_position = tilemap.map_to_local(position)
				object.z_index = 6
				if object.has_method("check_node"):
					parent.add_child(object)
					plant_load(object, object_name, position)
				else:
					push_error("Cannot load node.")
			else:
				push_error("Variable position is not of type Vector2")

func remove_all_child(parent: Node):
	erase_cells(gridCollision.seeds_layer)
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
	object_created = 0
	
func erase_cells(layer: int) -> void:
	var used_cells = tilemap.get_used_cells(layer)
	for cell in used_cells:
		tilemap.erase_cell(layer, cell)
	
func get_children_data(parent: Node) -> Dictionary:
	var data_dict = {}
	for child in parent.get_children():
		if child.has_method("get_data"):
			var child_data = child.get_data()
			data_dict[child.name] = child_data
	return data_dict

func plant_load(object:Node2D, object_name:String, position):
	var plant_id		= get_key(path.plants, object_name, "plantID")
	var condition		= get_key(path.plants, object_name, "condition")
	var degree			= get_key(path.plants, object_name, "degree")
	var region_rect_x 	= get_key(path.plants, object_name, "region_rect.x")
	var region_rect_y 	= get_key(path.plants, object_name, "region_rect.y")
	var level 			= get_key(path.plants, object_name, "level_growth")

	if plant_id != null\
	and condition != null\
	and degree != null\
	and region_rect_x != null\
	and region_rect_y != null\
	and level != null:
		object.set_data(plant_id, condition, degree, region_rect_x, region_rect_y, level, position)
	else:
		push_error("Data missing for node: " + object_name)

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
	cycle.year		= get_key(path.world, "World", "Year")
	cycle.month 	= get_key(path.world, "World", "Month")
	cycle.week		= get_key(path.world, "World", "Week")
	cycle.day		= get_key(path.world, "World", "Day")
	cycle.hour		= get_key(path.world, "World", "Hour")
	cycle.minute 	= get_key(path.world, "World", "Minute")
	cycle.timeset()

func player_load() -> void:
	camera.position.x 	= get_key(path.player, "Player", "X")
	camera.position.y 	= get_key(path.player, "Player", "Y")
	camera.money 		= get_key(path.player, "Player", "Balance")
