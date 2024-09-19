extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var hud:Control = get_node("/root/" + main_scene + "/User Interface/Hud")
@onready var tip:Control = get_node("/root/" + main_scene + "/User Interface/System/Tooltip")
@onready var cycle:CanvasModulate = get_node("/root/" + main_scene + "/Cycle")
@onready var label:Label = $Main/Margin/HBoxContainer/Label/Label
@onready var timer:Timer = $Timer

var speed:int = 1
var weeks:Array[String] = [
	"Пн", "Вт", "Ср",
	"Чт", "Пт", "Сб",
	"Вс"
	]
var weekday = 0

func _ready():
	timer.wait_time = speed
	timer.set_paused(false)
	timer.start()
	
func clock_update() -> void:
	var time = str(cycle.hour) + ":" + str(cycle.minute) + "0"
	label.text = str(week_update()) + ", " + str(time)

func week_update():
	if weekday < weeks.size() - 1:
		weekday += 1
	else:
		weekday = 0
	return weeks[weekday]
		
func time_paused(status:bool) -> void:
	timer.set_paused(status)

func time_state(status:bool) -> void:
	match status:
		true:
			timer.stop()
		false:
			timer.start()
	
func _on_timer_timeout():
	if hud.visible:
		if cycle.minute >= 0:
			cycle.minute += 1
		if cycle.minute > 5:
			cycle.minute = 0
			cycle.hour = cycle.hour + 1
		if cycle.hour > 23:
			cycle.hour = 0

		clock_update()
