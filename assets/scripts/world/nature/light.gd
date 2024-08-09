extends Node2D

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var time:Object = get_node("/root/World/Cycle")
@onready var parent:Node2D = get_node("/root/World/Light")

var energy:float = 1
var energy_min:float = 0
var energy_max:float = 1
var on:int = 20
var off:int = 0
var speed:float = 0.005
var light:bool

func _process(delta):
	if !pause.paused:
		if time.hour == off:
			check_light(false)
		if time.hour == on:
			check_light(true)
		if light:
			if energy < energy_max:
				energy = energy + speed
		else:
			if energy > energy_min:
				energy = energy - speed
			if energy == energy_min:
				parent.visible = false

func check_light(switch:bool):
	if switch:
		light = true
		parent.visible = true
	else:
		light = false
		parent.visible = false
