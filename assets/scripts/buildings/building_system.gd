extends Node

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/" + main_scene)
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var buildings:Node = get_node("/root/" + main_scene + "/Buildings")
@onready var tilemap:Node2D = get_node("/root/" + main_scene + "/Tilemap")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")
@onready var collision:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid/GridCollision")

func get_buildings() -> Dictionary:
	var data_dict = {}
	for building in buildings.get_children():
		if building.has_method("get_data"):
			data_dict[building.name] = building.get_data()
	return data_dict

func build_content(build_name:String, level:int) -> void:
	for building in buildings.get_children():
		if building.name == build_name:
			if building.has_method("load_data"):
				building.load_data(level)
			else:
				data.debug("The '" + str(building.name) + "' node does not have the 'load_data' method.", "error")

func build(tile_mouse_pos:Vector2i, building_id:int, building_node:PackedScene, node_shadow:CompressedTexture2D) -> void:
	#var shadow_group:CanvasGroup = get_node("/root/" + main_scene + "/Shadow")
	var building:Node2D = building_node.instantiate()
	var blueprints = Blueprints.new()
	if !collision.building_collision_check(collision.building_layer):
		tilemap.set_cell(collision.building_layer, tile_mouse_pos, 0, Vector2i(0,3))
		building.set_position(tilemap.map_to_local(tile_mouse_pos))
		building.z_index = collision.building_layer
		add_child(building)
		#shadow_group.create_shadow(tile_mouse_pos, node_shadow)
		if blueprints.content[building_id]["type"]["node"].has("name"):
			building.name = blueprints.content[building_id]["type"]["node"]["name"] + "_1"
		else:
			building.name = "untitled_object_1"