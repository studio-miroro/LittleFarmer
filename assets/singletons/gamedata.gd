extends Node

@onready var cycle = get_node("/root/World/Cycle")

var money:int = 100
var hour:int = 8
var minute:int = 0
var day:int = 1
var week:int = 1
var month:int = 1
var year:int = 1

var game_speed:int = 8

func _ready():
	cycle.timeset()
	#if json.get_key("world", "time.hour") and json.get_key("world", "time.minute") != -1:
		#self.hour = json.get_key("world", "time.hour")
		#self.minute = json.get_key("world", "time.minute")
	#else:print("Error")
