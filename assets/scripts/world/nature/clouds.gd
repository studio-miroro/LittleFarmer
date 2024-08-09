extends CanvasGroup

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var timer:Timer = $CloudTimer
@export var sprites:Array = [
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

var node:PackedScene = preload("res://assets/nodes/nature/clouds.tscn")
var max_distance:float = 600

func cloud_spawn() -> void:
	var distance = round(global_position.distance_to(get_node("/root/World/Camera").global_position))
	if !pause.paused\
	and distance < max_distance:
		var cloud:Node2D = node.instantiate()
		var texture_id:int = randi() % sprites.size()
		var choose_texture:Texture = sprites[texture_id]
		
		cloud.texture = choose_texture
		cloud.animation(true)
		cloud_pos(cloud, true)
		add_child(cloud)
	
func cloud_pos(object, status:bool):
	var random_x:int = randi_range(-480, 480)
	var random_y:int = randi_range(-270, 270)
	object.set_position(Vector2(random_x, random_y))

func _on_cloud_timer_timeout():
	if !pause.paused:
		timer.wait_time = randi_range(30,240)
		var cloud:Node2D = node.instantiate()
		cloud_spawn()
