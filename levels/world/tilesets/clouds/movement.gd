extends Sprite2D

var object = preload("res://levels/world/tilesets/clouds/clouds.tscn")
@onready var player = get_node("/root/World/Player")
@onready var max_distance:int = get_node("/root/World/Shadow").max_distance
var speed:float = .5

func _process(delta):
	var distance = global_position.distance_to(player.global_position)
	var cloud = object.instantiate() 
	if !get_node("/root/World/UI/Pause").paused\
	and distance < max_distance:
		position = Vector2(position.x+speed,position.y+speed)	
	if distance > max_distance:
		queue_free()
		game_variables.clouds = game_variables.clouds - 1

func animation():
	$AnimationPlayer.play("emergence")
