extends Control

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var hud:Control = get_node("/root/"+main+"/UI/Decorative/Hud")
@onready var tip:Control = get_node("/root/"+main+"/UI/Feedback/Tooltip")
@onready var cycle:CanvasModulate = get_node("/root/"+main+"/Cycle")
@onready var label:Label = $Main/Margin/HBoxContainer/Label/Label
@onready var timer:Timer = $Timer

const speed:float = 8

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
	
func clock_update() -> void:
	var time = str(hour) + ":" + str(minute) + "0"
	label.text = str(weeks[weekday]) + " " + str(time)

func _week_update():
	if weekday < weeks.size() - 1:
		weekday += 1
	else:
		weekday = 0
	
func _on_timer_timeout():
	if !pause.paused:
		if minute >= 0:
			minute += 1
		if minute > 5:
			minute = 0
			hour = hour + 1
		if hour > 23:
			hour = 0
			_week_update()
		clock_update()


func time_paused(status:bool) -> void:
	timer.set_paused(status)

func time_state(status:bool) -> void:
	match status:
		true:
			timer.stop()
		false:
			timer.start()
