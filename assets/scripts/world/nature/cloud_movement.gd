extends Sprite2D

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var player:Node2D = get_node("/root/" + main_scene + "/Camera")
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var max_distance:float = get_node("/root/" + main_scene + "/Shadow").max_distance
@onready var shadow_group:Node2D = get_node("/root/" + main_scene + "/Shadow")

var node = preload("res://assets/nodes/nature/cloud.tscn")
var speed:float = .5

func _process(_delta):
	var distance = global_position.distance_to(player.global_position) 
	if !pause.paused and distance < max_distance:
		position = Vector2(position.x+speed,position.y+speed)	
		if distance > max_distance:
			remove_child(shadow_group)
			queue_free()
	

func animation():
	$AnimationPlayer.play("emergence")
