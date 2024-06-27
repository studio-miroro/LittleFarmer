extends CharacterBody2D

class_name Camera

var direction:Vector2 	= Vector2.ZERO
@onready var camera 	= $Camera2D
var money:int 			= 0
var camera_speed:int 	= 5
var speed:int 			= 150
var switch:bool			= false

func _process(_delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		camera.position_smoothing_speed = camera_speed
	elif Input.is_action_just_pressed("menu"): 
		menu()
	
func menu():
	if switch:
		camera.position_smoothing_speed = 0
	else: 
		camera.position_smoothing_speed = camera_speed
		
func _physics_process(_delta):
	if !switch:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
