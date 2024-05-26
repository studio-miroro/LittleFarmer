extends Sprite2D

var object = preload("res://assets/nodes/nature/clouds.tscn")
@onready var player = get_node("/root/World/Player")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var max_distance:int = get_node("/root/World/Shadow").max_distance
var speed:float = .5

func _process(delta):
	var distance = global_position.distance_to(player.global_position)
	var cloud = object.instantiate() 
	if !pause.paused\
	and distance < max_distance:
		position = Vector2(position.x+speed,position.y+speed)	
	if distance > max_distance:
		queue_free()

func animation():
	$AnimationPlayer.play("emergence")
