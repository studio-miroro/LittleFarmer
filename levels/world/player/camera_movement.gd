extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
@onready var animation_player = $AnimationTree
@onready var camera_2d = $Camera2D
@export var shadow: Sprite2D
var camera_speed: int = 5
var speed: int = 150
var swing: bool = false

@onready var zoom_x = camera_2d.zoom.x
@onready var zoom_y = camera_2d.zoom.y

func _process(_delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO && not swing:
		walking(true)
		update_animation()
		$Camera2D.position_smoothing_speed = camera_speed
	# Menu Pause
	elif Input.is_action_just_pressed("menu"): 
		menu()
	else:
		walking(false)
	
func walking(value):
	animation_player["parameters/conditions/Run"] = value
	animation_player["parameters/conditions/Idle"] = not value
	
func update_animation():
	animation_player["parameters/Run/blend_position"] = direction
	animation_player["parameters/ldle/blend_position"] = direction
	animation_player.active = true
	
func menu():
	if get_node("/root/World/UI/Pause").paused:
		animation_player.active = false
		$Camera2D.position_smoothing_speed = 0
	else: 
		animation_player.active = true
		$Camera2D.position_smoothing_speed = camera_speed
		
func _physics_process(_delta):
	if not swing:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
