extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager:Node2D = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var notice:Control = get_node("/root/" + main_scene + "/User Interface/System/Notifications")
@onready var hud:Control = get_node("/root/" + main_scene + "/User Interface/Hud")
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var craft:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")

var items:Object = Items.new()
var blueprints:Object = Blueprints.new()
var materials:Object = BuildingMaterials.new()

var disable:bool
var id:int

func _on_pressed():
	if visible:
		build(id)

func build(index:int) -> void:
	start_building(index)

func start_building(index) -> void:
	var target_array = blueprints.content[index]["type"].keys() 
	match target_array[0]:
		"terrain":
			if blueprints.content[index]["type"]["terrain"].has("terrain_set"):
				if blueprints.content[index]["type"]["terrain"].has("terrain_layer"):
					grid.terrain_set = blueprints.content[index]["type"]["terrain"]["terrain_set"]
					grid.terrain_layer = blueprints.content[index]["type"]["terrain"]["terrain_layer"]
					grid.mode = grid.modes.TERRAIN_SET
					grid.visible = true
					craft.close()
					hud.state(true)
				else:
					print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The key element is missing - 'terrain_layer'")
					reset_grid_data(target_array[0])
			else:
				print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The key element is missing - 'terrain_set'")
				reset_grid_data(target_array[0])

		"node":
			if blueprints.content[index]["type"]["node"].has("source"):
				if blueprints.content[index]["type"]["node"].has("layer"):
					if blueprints.content[index]["type"]["node"].has("shadow"):
						grid.building_id = index
						grid.building_node = blueprints.content[index]["type"]["node"]["source"]
						grid.building_node_layer = blueprints.content[index]["type"]["node"]["layer"]
						grid.building_shadow = blueprints.content[index]["type"]["node"]["shadow"]
						grid.mode = grid.modes.BUILD
						grid.visible = true
						craft.close()
						hud.state(true)
					else:
						print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The key element is missing - 'shadow'")
						reset_grid_data(target_array[0])
				else:
					print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The key element is missing - 'layer'")
					reset_grid_data(target_array[0])
			else:
				print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: The key element is missing - 'source'")
				reset_grid_data(target_array[0])		

		_:
			print_debug("\n"+str(manager.get_system_datetime()) + " ERROR: Invalid type - "+str(target_array[0]))
			reset_grid_data(target_array[0])


func reset_grid_data(index) -> void:
	match index:
		"terrain":
			grid.terrain_set = 0
			grid.terrain_layer = 0
			grid.mode = grid.modes.NOTHING
			grid.visible = false
		"node":
			grid.building_node = null
			grid.mode = grid.modes.NOTHING
			grid.visible = false
		_:
			pass