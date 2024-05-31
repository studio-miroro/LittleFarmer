extends Node2D

@onready var tilemap = get_node("/root/World/Tilemap")
@onready var collision = get_node("/root/World/Buildings/Grid/GridCollision")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var timer = Timer.new()

#enum growth_status {planted, growing, increased, dead}
@onready var status:bool = false
var level:int = 0
var plantID:int = 0

func _process(delta):
	if pause.paused:
		$Timer.set_paused(true)
	else:
		$Timer.set_paused(false)

func plant(id):
	self.plantID = id
	$Sprite2D.plantID = id
	$Sprite2D.rect(id)
	
func check(id,pos):
	var mouse_position = tilemap.local_to_map(get_global_mouse_position())
	var atlas_coords = Vector2i(0,3)
	var source_id = 0
	if collision.cell_check(pos, collision.farming_layer)\
	and !collision.cell_check(pos, collision.watering_layer):
		self.status = false
		await get_tree().create_timer(2).timeout
		check(id,pos)
	else:
		self.status = true
		time()
		
func time():
	if status:
		$Timer.wait_time = crops.crops[plantID]["growth_rate"]#randi_range((crops.crops[plantID]["growth_rate"] * 0.43), crops.crops[plantID]["growth_rate"])
		$Timer.start()
	else:
		$Timer.stop()
