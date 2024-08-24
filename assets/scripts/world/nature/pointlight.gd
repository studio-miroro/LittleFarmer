extends PointLight2D

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var light = get_node("/root/" + main_scene + "/Light").light

func _process(_delta):
	var light_energy = get_node("/root/" + main_scene + "/Light").energy
	if light:
		energy = light_energy
	else:pass
