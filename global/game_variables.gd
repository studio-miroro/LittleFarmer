extends Node
class_name farm_config
var money:int = 0
# Time 
var hour:int = 1
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
	seedID = 0#randi_range(0,9)
	seeds()

func seeds():
	if seedID == 0:
		seed = Vector2i(0,0)
		print("Морковь")
	elif seedID == 1:
		seed = Vector2i(0,2)
		print("Картофель")
	elif seedID == 2:
		seed = Vector2i(0,4)
		#print("Лук")
	elif seedID == 3:
		seed = Vector2i(0,6)
		#print("Картофель")
	elif seedID == 4:
		seed = Vector2i(0,8)
		#print("Бой-чок")
	elif seedID == 5:
		seed = Vector2i(0,10)
		#print("Рис")
	elif seedID == 6:
		seed = Vector2i(0,12)
		#print("Амарант")
	elif seedID == 7:
		seed = Vector2i(0,14)
		#print("Тыква")
	elif seedID == 8:
		seed = Vector2i(0,16)
		#print("Подсолнух")
	elif seedID == 9:
		seed = Vector2i(0,18)
		#print("Редис")
