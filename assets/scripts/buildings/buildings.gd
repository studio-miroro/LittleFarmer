extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var buildings:Node2D = get_node("/root/" + main_scene + "/Buildings")

func get_buildings() -> Dictionary:
	var data_dict = {}
	for build in buildings.get_children():
		if build.has_method("get_data"):
			data_dict[build.name] = build.get_data()
	return data_dict

func build_content(build_name:String, level:int) -> void:
	for build in buildings.get_children():
		if build.name == build_name:
			if build.has_method("load_data"):
				build.load_data(level)
			else:
				push_error("The '" + str(build.name) + "' node does not have the 'load_data' method.")