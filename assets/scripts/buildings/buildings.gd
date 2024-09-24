extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager = get_node("/root/" + main_scene)
@onready var buildings:Node2D = get_node("/root/" + main_scene + "/Buildings")
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
				push_error("The '" + str(building.name) + "' node does not have the 'load_data' method.")

func build(tile_mouse_pos:Vector2i, building_node:PackedScene, building_layer:int, node_shadow:CompressedTexture2D) -> void:
	var shadow_group:CanvasGroup = get_node("/root/" + main_scene + "/Shadow")
	var node:Node2D = building_node.instantiate()

	tilemap.set_cell(building_layer, tile_mouse_pos, 0, Vector2i(0,3))
	node.set_position(tilemap.map_to_local(tile_mouse_pos))
	node.z_index = 6
	add_child(node)
	shadow_group.create_shadow(tile_mouse_pos, node_shadow)