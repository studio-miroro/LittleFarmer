extends Control

var game_speed = game_variables.game_speed
var hours:int = game_variables.hour
var minutes:int = game_variables.minutes

func _ready():
	$Timer.wait_time = game_speed
	$Timer.set_paused(false)
	$Timer.start()
	
func _process(_delta):
	$Label.text = str(hours) + ":" + str(minutes) + "0"

func timerupdate():
	if !$"/root/World/UI/Pause".paused:
		$Timer.set_paused(false)
	else: 
		$Timer.set_paused(true)
	
func _on_timer_timeout():
	if minutes >= 0 && !$"/root/World/UI/Pause".paused:
		minutes = minutes + 1
	if minutes > 5 && !$"/root/World/UI/Pause".paused:
		minutes = 0
		hours = hours + 1
	if hours > 23 && !$"/root/World/UI/Pause".paused:
		hours = 0

func timerstop(timer):
	if timer:
		$Timer.stop()
	else:
		pass

