extends Node2D

var seed:Vector2i

func get_plant(seed_id):
	seed_detect(seed_id)

func seed_detect(id):
	if id == 1:
		seed = Vector2i(0,0)
		#print("Морковь "  + str(seed))
	elif id == 2:
		seed = Vector2i(0,2)
		#print("Картофель " + str(seed))
