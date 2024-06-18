extends Control

@onready var pause = get_node("/root/World/UI/Pause")
@onready var cycle = TimeWorld.new()
@onready var timer = $Timer
@onready var label = $Label

@onready var speed = cycle.game_speed
		
func _ready():
	timer.wait_time = speed
	timer.set_paused(false)
	timer.start()
	
func _process(_delta):
	label.text = str(cycle.hour) + ":" + str(cycle.minute) + "0"
		
func _on_timer_timeout():
	if !pause.paused:
		if cycle.minute >= 0:
			cycle.minute += 1
		if cycle.minute > 5:
			cycle.minute = 0
			cycle.hour = cycle.hour + 1
		if cycle.hour > 23:
			cycle.hour = 0
		
func timerupdate():
	if !pause.paused:
		timer.set_paused(false)
	else: 
		timer.set_paused(true)

func timerstop(method:bool):
	if method:
		timer.stop()
	else:
		pass

