extends Control

@onready var pause = get_node("/root/World/UI/Pause")
@onready var timer = $Timer
@onready var label = $Label

var speed = gamedata.game_speed
		
func _ready():
	timer.wait_time = speed
	timer.set_paused(false)
	timer.start()
	
func _process(_delta):
	label.text = str(gamedata.hour) + ":" + str(gamedata.minute) + "0"
		
func _on_timer_timeout():
	if gamedata.minute >= 0 && !pause.paused:
		gamedata.minute = gamedata.minute + 1
	if gamedata.minute > 5 && !pause.paused:
		gamedata.minute = 0
		gamedata.hour = gamedata.hour + 1
	if gamedata.hour > 23 && !pause.paused:
		gamedata.hour = 0
		
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

