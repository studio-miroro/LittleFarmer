extends Node
class_name farm_config
var money:int = 0
# Time 
var hour:int = 10
var minutes:int = 0
var game_speed:int = 8
# Date
var day:int = 1
var week:int = 1
var month:int = 1
var year:int = 1

enum gamemode {NOTHING, SEEDS, FARMING, WATERING, BUILDING, DESTROY}
var mode = gamemode.NOTHING
var seed:Vector2i = Vector2i(0,0)
var seedID:int = 0

var random_x = randi_range(-100, 100)
var random_y = randi_range(-100, 100)

var max_clouds = 100
var clouds = 0

func _ready():
	#print("Settings load")
	# Settings Engine
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#Engine.max_fps = 60
	seedID = 1#randi_range(0,9)
	get_node("/root/World").seeds()
