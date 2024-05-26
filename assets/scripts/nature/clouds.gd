extends CanvasGroup

@export var sprite:Array = [
	preload("res://assets/resources/nature/clouds/cloud_0.png"),
	preload("res://assets/resources/nature/clouds/cloud_1.png"),
	preload("res://assets/resources/nature/clouds/cloud_2.png"),
	preload("res://assets/resources/nature/clouds/cloud_3.png"),
	preload("res://assets/resources/nature/clouds/cloud_4.png"),
	preload("res://assets/resources/nature/clouds/cloud_5.png"),
	preload("res://assets/resources/nature/clouds/cloud_6.png"),
	preload("res://assets/resources/nature/clouds/cloud_7.png"),
	preload("res://assets/resources/nature/clouds/cloud_8.png"),
	preload("res://assets/resources/nature/clouds/cloud_9.png"),
	preload("res://assets/resources/nature/clouds/cloud_10.png")
]
@onready var player = get_node("/root/World/Player")
@onready var pause = get_node("/root/World/UI/Pause")
var object = preload("res://assets/nodes/nature/clouds.tscn")
var max_distance:float = 600

func cloud_spawn():
	var distance = round(global_position.distance_to(player.global_position))
	if !pause.paused\
	and distance < max_distance:
		var cloud = object.instantiate()
		var texture_id:int = randi() % sprite.size()
		var choose_texture:Texture = sprite[texture_id]
		
		cloud.texture = choose_texture
		cloud.animation()
		cloud_pos(cloud, true)
		add_child(cloud)
	else:pass
	
func cloud_pos(object,status:bool):
	var random_x = randi_range(-480, 480)
	var random_y = randi_range(-270, 270)
	object.set_position(Vector2(random_x, random_y))

func _on_cloud_timer_timeout():
	if !pause.paused:
		$CloudTimer.wait_time = randi_range(30,240)
		var cloud = object.instantiate()
		cloud_spawn()
