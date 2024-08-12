extends PointLight2D

@onready var light = get_node("/root/World/Light").light

func _process(_delta):
	var light_energy = get_node("/root/World/Light").energy
	if light:
		energy = light_energy
	else:pass
