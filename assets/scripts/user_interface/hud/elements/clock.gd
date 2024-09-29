extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/" + main_scene + "/UI/Windows/Pause")
@onready var hud:Control = get_node("/root/" + main_scene + "/UI/GUI/Hud")
@onready var tip:Control = get_node("/root/" + main_scene + "/UI/System/Tooltip")
@onready var cycle:CanvasModulate = get_node("/root/" + main_scene + "/Cycle")
@onready var label:Label = $Main/Margin/HBoxContainer/Label/Label
@onready var timer:Timer = $Timer

const speed:int = 1

var hour:int = 7
var minute:int = 0
var weekday:int = 0
var weeks:Array[String] = [
	tr("mon.clock"), tr("tue.clock"), tr("wed.clock"),
	tr("thu.clock"), tr("fri.clock"), tr("sat.clock"),
	tr("sun.clock")
	]

func _ready():
	timer.wait_time = speed
	timer.set_paused(false)
	timer.start()
	
func _clock_update() -> void:
	var time = str(hour) + ":" + str(minute) + "0"
	label.text = str(_week_update()) + " " + str(time)

func _week_update():
	if weekday < weeks.size() - 1:
		weekday += 1
	else:
		weekday = 0
	return weeks[weekday]
	
func _on_timer_timeout():
	if !pause.paused:
		if minute >= 0:
			minute += 1
		if minute > 5:
			minute = 0
			hour = hour + 1
		if hour > 23:
			hour = 0
		_clock_update()

func time_paused(status:bool) -> void:
	timer.set_paused(status)

func time_state(status:bool) -> void:
	match status:
		true:
			timer.stop()
		false:
			timer.start()
