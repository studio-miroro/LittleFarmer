extends CharacterBody2D

var direction:Vector2 = Vector2.ZERO
@onready var camera_2d = $Camera2D
@onready var pause = get_node("/root/World/UI/Pause")
@export var shadow:Sprite2D
var camera_speed:int = 5
var speed:int = 150
var swing:bool = false

@onready var zoom_x = camera_2d.zoom.x
@onready var zoom_y = camera_2d.zoom.y

func _process(_delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO && not swing:
		$Camera2D.position_smoothing_speed = camera_speed
	elif Input.is_action_just_pressed("menu"): 
		menu()
	
func menu():
	if pause.paused:
		$Camera2D.position_smoothing_speed = 0
	else: 
		$Camera2D.position_smoothing_speed = camera_speed
		
func _physics_process(_delta):
	if not swing:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
