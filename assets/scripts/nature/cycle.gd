extends CanvasModulate

var time:float= 0.0
var past_minute:int= -1
var minutes_in_day = (data.game_speed * 1440) 
var minutes_in_hour = (data.game_speed * 60)
var sin_speed = (2 * PI) / minutes_in_day
signal time_tick(day:int, hour:int, minute:int) 
@export var gradient_texture:GradientTexture1D
@onready var time_speed = data.game_speed
@onready var initial_hour = data.hour:
	set(h):
		initial_hour = h
		time = sin_speed * minutes_in_hour * initial_hour

func _ready() -> void:
	time = sin_speed * minutes_in_hour * initial_hour

func _process(delta: float) -> void:
	if !get_node("/root/World/UI/Pause").paused:
		time += delta * sin_speed * time_speed
		var value = (sin(time - 3.13142 / 2.0) + 1.10) / 2.00
		self.color = gradient_texture.gradient.sample(value)
		_recalculate_time()
		#print(time)

func _recalculate_time() -> void:
	var total_minutes = int(time / sin_speed)
	var day = int(total_minutes / minutes_in_day)
	var current_day_minutes = total_minutes % minutes_in_day
	var hour = int(current_day_minutes / minutes_in_hour)
	var minute = int(current_day_minutes % minutes_in_hour)

	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)

