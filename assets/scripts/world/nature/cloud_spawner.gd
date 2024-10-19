extends Timer

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var clock:Control = get_node("/root/"+main+"/UI/HUD/GameHud/Main/Bars/Clock")
@onready var canvas:Node = get_node("/root/"+main+"/ShadowManager")
var clouds:Array[CompressedTexture2D] = [
	load("res://assets/resources/world/clouds/cloud_0.png"),
	load("res://assets/resources/world/clouds/cloud_1.png"),
	load("res://assets/resources/world/clouds/cloud_2.png"),
	load("res://assets/resources/world/clouds/cloud_3.png"),
	load("res://assets/resources/world/clouds/cloud_4.png"),
	load("res://assets/resources/world/clouds/cloud_5.png"),
	load("res://assets/resources/world/clouds/cloud_6.png"),
	load("res://assets/resources/world/clouds/cloud_7.png"),
	load("res://assets/resources/world/clouds/cloud_8.png"),
	load("res://assets/resources/world/clouds/cloud_9.png"),
	load("res://assets/resources/world/clouds/cloud_10.png"),
] 

func _on_timeout():
	if has_node("/root/"+main+"/ShadowManager/CanvasGroup"):
		var random_sprite = randi() % clouds.size()
		canvas.create_cloud(clouds[random_sprite])
		wait_time = randi_range(0.25*clock.speed, 2*clock.speed)
		print(wait_time)
	else:
		data.debug("The 'CanvasGroup' node is missing.", "error")
