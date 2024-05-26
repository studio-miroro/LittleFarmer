extends Control

@onready var pause = get_node("/root/World/UI/Pause")
@onready var timer = $Timer
@onready var label = $Label

var speed = data.game_speed
		
func _ready():
	timer.wait_time = speed
	timer.set_paused(false)
	timer.start()
	
func _process(_delta):
	label.text = str(data.hour) + ":" + str(data.minutes) + "0"
		
func _on_timer_timeout():
	if data.minutes >= 0 && !pause.paused:
		data.minutes = data.minutes + 1
	if data.minutes > 5 && !pause.paused:
		data.minutes = 0
		data.hour = data.hour + 1
	if data.hour > 23 && !pause.paused:
		data.hour = 0
		
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

