extends Node2D

@onready var pause = get_node("/root/World/UI/Pause")
@onready var lightgroup = get_node("/root/World/Light")

var energy:float = 1
var energy_min:float = 0
var energy_max:float = 1
var on:int = 20
var off:int = 6
var speed:float = 0.005
var light:bool = true

func _process(delta):
	if !pause.paused:
		if gamedata.hour >= off and gamedata.hour < on:
			check_light(false)
		if gamedata.hour >= on:
			check_light(true)
		if light:
			if energy < energy_max:
				energy = energy + speed
		else:
			if energy > energy_min:
				energy = energy - speed
			if energy == energy_min:
				lightgroup.visible = false
				
func check_light(switch:bool):
	if switch:
		light = true
		lightgroup.visible = true
	else:
		light = false
		lightgroup.visible = false
