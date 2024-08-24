extends CanvasModulate

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@export var gradient_texture:GradientTexture1D

var year:int = 1
var month:int = 1
var week:int = 1
var day:int = 1
var hour:int = 8
var minute:int = 0
var months:Array[String] = [
		"Январь", "Февраль", "Март", 
		"Апрель", "Май", "Июнь", 
		"Июль", "Август", "Сентябрь", 
		"Октябрь", "Ноябрь", "Декабрь"
		]
var weeks:Array[String] = [
		"Пн", "Вт", "Ср", 
		"Чт", "Пт", "Сб", 
		"Вс"
		]

var time:float = 0.0
var speed:int = 8
var past_minute:int = -1
var minutes_in_day = (speed * 1440) 
var minutes_in_hour = (speed * 60)
var sin_speed = (2 * PI) / minutes_in_day
signal time_tick(day:int, hour:int, minute:int) 

func _ready():
	timeset()

func _process(delta: float) -> void:
	if !pause.paused:
		time += delta * sin_speed * speed
		var value = (sin(time - PI / 2.0) + 1.10) / 2.00
		self.color = gradient_texture.gradient.sample(value)
		recalculate_time()

func timeset():
	var initial_hour = get_hour()
	time = sin_speed * minutes_in_hour * initial_hour
	recalculate_time()
	
func timeload(timeindex):
	self.time = timeindex
	recalculate_time()

func recalculate_time() -> void:
	var total_minutes = int(time / sin_speed)
	var day = int(total_minutes / minutes_in_day)
	var current_day_minutes = total_minutes % minutes_in_day
	var hour = int(current_day_minutes / minutes_in_hour)
	var minute = int(current_day_minutes % minutes_in_hour)
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)

func get_time() -> float:
	return time

func get_hour() -> int:
	return hour
