extends Sprite2D

@onready var player:Node2D			= get_node("/root/World/MainCamera")
@onready var pause:Control 			= get_node("/root/World/UI/Pause")
@onready var max_distance:int 		= get_node("/root/World/Shadow").max_distance
@onready var shadow_group:Node2D	= get_node("/root/World/Shadow")
@onready var anim:AnimationPlayer	= $AnimationPlayer

var node = preload("res://assets/nodes/nature/clouds.tscn")
var speed:float = .5

func _process(delta):
	var distance = global_position.distance_to(player.global_position)
	var cloud = node.instantiate() 
	if !pause.paused and distance < max_distance:
		position = Vector2(position.x+speed,position.y+speed)	
		if distance > max_distance:
			print("Deleted")
			remove_child(shadow_group)
			queue_free()
	

func animation(a:bool):
	$AnimationPlayer.play("emergence")
