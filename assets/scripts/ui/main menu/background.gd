extends ColorRect

const dark:Color = Color("222831")
const light:Color = Color("EEEEEE")
const evening:int = 17
const morning:int = 8

func _ready():
	background(get_time())

func background(time:String) -> void:
	if !range(morning, evening).has(int(time.left(2))):
		color = light
	else:
		color = dark

func get_time() -> String:
	return Time.get_time_string_from_system(false)
