extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var notice:Control = get_node("/root/" + main_scene + "/User Interface/System/Notifications")
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var craft:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")

var items:Object = Items.new()
var blueprints:Object = Blueprints.new()
var materials:Object = BuildingMaterials.new()

var disable:bool
var id:int

func _on_pressed():
	if visible:
		build(id)

func build(index:int) -> void:
	check_building_type(index)
			
func check_building_type(index:int):
	var target_array = blueprints.content[index]["type"].keys() 
	match target_array[0]:
		"terrain":
			# Code ...
			craft.close()
		"node":
			# Code ...
			craft.close()
		"upgrade":
			# Code ...
			craft.close()
		_:
			pass
