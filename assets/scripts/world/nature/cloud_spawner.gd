extends Timer

@onready var main = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/"+main)
@onready var canvas = get_node("/root/"+main+"/ShadowManager")
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
	else:
		data.debug("The 'CanvasGroup' node is missing.", "error")
