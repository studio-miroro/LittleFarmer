extends Node2D

@onready var main = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/"+main)
@onready var inventory:Control = get_node("/root/"+main+"/UI/Interactive/Inventory")
@onready var buildings:Node = get_node("/root/"+main+"/ConstructionManager")
@onready var shadows:Node = get_node("/root/"+main+"/ShadowManager")
@onready var tilemap:TileMap = get_node("/root/"+main+"/Tilemap")
@onready var grid:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid")
@onready var collision:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid/GridCollision")
const max_distance:int = 250

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
				data.debug("The '" + str(building.name) + "' node does not have the 'load_data' method, skipped.", "error")

func construct(node_id:int, node_scene:PackedScene, node_shadow:CompressedTexture2D, node_position:Vector2i) -> void:
	var building:Node2D = node_scene.instantiate()
	var blueprints = Blueprints.new()
	var building_name = "build"

	add_child(building)
	tilemap.set_cell(collision.building_layer-1, node_position, 0, Vector2i(0,3))
	building.set_position(tilemap.map_to_local(node_position))
	building.z_index = collision.building_layer
	if blueprints.content[node_id]["type"]["node"].has("name"):
		building_name = blueprints.content[node_id]["type"]["node"]["name"] + "_1"
		building.name = building_name
	shadows.create_shadow(building_name, node_shadow, node_position)
