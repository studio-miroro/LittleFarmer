extends CanvasModulate

class_name TimeWorld

@onready var pause = PauseMenu.new()
@export var gradient_texture:GradientTexture1D

var year:int 	= 1
var month:int 	= 1
var week:int 	= 1
var day:int 	= 1
var hour:int 	= 8
var minute:int	= 0

var time:float = 0.0
var game_speed:int = 8
var past_minute:int = -1
var minutes_in_day = (game_speed * 1440) 
var minutes_in_hour = (game_speed * 60)
var sin_speed = (2 * PI) / minutes_in_day
signal time_tick(day:int, hour:int, minute:int) 

func _ready():
	timeset()

func timeset():
	if !pause.paused:
		var initial_hour = get_hour()
		time = sin_speed * minutes_in_hour * initial_hour

func _process(delta: float) -> void:
	if !pause.paused:
		time += delta * sin_speed * game_speed
		var value = (sin(time - PI / 2.0) + 1.10) / 2.00
		self.color = gradient_texture.gradient.sample(value)
		_recalculate_time()

func _recalculate_time() -> void:
	var total_minutes = int(time / sin_speed)
	var day = int(total_minutes / minutes_in_day)
	var current_day_minutes = total_minutes % minutes_in_day
	var hour = int(current_day_minutes / minutes_in_hour)
	var minute = int(current_day_minutes % minutes_in_hour)
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)

func get_hour():
	return hour
