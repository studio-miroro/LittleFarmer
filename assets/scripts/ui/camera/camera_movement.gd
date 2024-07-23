extends CharacterBody2D

class_name Camera

@onready var camera = $Camera2D
@onready var switch:bool = false

var direction:Vector2 = Vector2.ZERO
var camera_speed:int = 5
var speed:int = 150

func _ready():
	print(
		Crops.new().crops[1]["productivity"][randi() % Crops.new().crops[1]["productivity"].size()]
	)

func _process(_delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO and !switch:
		camera.position_smoothing_speed = camera_speed
	
func menu():
	if switch:
		camera.position_smoothing_speed = 0
	else: 
		camera.position_smoothing_speed = camera_speed
		
func _physics_process(_delta):
	if !switch:
		velocity = direction * speed
		move_and_slide()
	else:
		velocity = Vector2.ZERO
