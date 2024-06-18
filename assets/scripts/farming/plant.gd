extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var tilemap = get_node("/root/World/Tilemap")
@onready var grid = get_node("/root/World/Buildings/Grid")
@onready var collision = get_node("/root/World/Buildings/Grid/GridCollision")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

enum phases {PLANTED,GROWING,INCREASED,DEAD}
enum fertilizers {NOTHING}
var plantID:int = 0
var condition:int = phases.PLANTED
var fertilizer:int = fertilizers.NOTHING
var degree:int = 0

func _process(delta):
	if pause.paused:
		timer.set_paused(true)
	else:
		timer.set_paused(false)

func plant(id):
	self.plantID = id
	sprite.rect(id)
	
func check(id,pos):
	var mouse_position = tilemap.local_to_map(get_global_mouse_position())
	var atlas_coords = Vector2i(0,3)
	var source_id = 0
	if collision.cell_check(pos, collision.farming_layer)\
	and !collision.cell_check(pos, collision.watering_layer)\
	and condition != phases.DEAD:
		self.condition = phases.PLANTED
		await get_tree().create_timer(
				crops.crops["checkWatering"]
			).timeout
		if degree < crops.crops[plantID]["mortality"]:
			degree += 1
		else:
			self.condition = phases.DEAD
		check(id,pos)

	elif collision.cell_check(pos, collision.farming_layer)\
	and collision.cell_check(pos, collision.watering_layer)\
	and condition != phases.DEAD:
		self.condition = phases.GROWING
		time()
	else:pass
		
func time():
	match condition:
		phases.GROWING:
			timer.wait_time = randf_range(
				crops.crops[plantID]["growthRate"] * 0.43,
				crops.crops[plantID]["growthRate"]
			)
			timer.start()
		phases.INCREASED:
			timer.stop()
			
func _on_collision_mouse_entered():
	if !pause.paused:
		if grid.mode == grid.gridmode.NOTHING:
			ui.tooltip_plant(get_global_mouse_position(), plantID, position, condition, true)
	else:
		ui.tooltip_plant(Vector2(0,0), 0, Vector2(0,0), 0, false)
func _on_collision_mouse_exited():
	if !pause.paused:
		if grid.mode == grid.gridmode.NOTHING:
			ui.tooltip_plant(Vector2(0,0), 0, Vector2(0,0), 0, false)

func get_data():
	return {
		"plantID": self.plantID,
		"degree": self.degree,
		"condition": self.condition,
		"fertilizer": self.fertilizer,
		"region_rect.x": self.sprite.region_rect.position.x,
		"region_rect.y": self.sprite.region_rect.position.y,
		"level_growth": sprite.level,
		"position": tilemap.local_to_map(global_position),
	}

func set_data(id:int, condition:int, degree:int, region_rect_x:int, region_rect_y:int, level:int, obj_position:Vector2i):
	self.plantID = id
	self.condition = condition
	self.degree = degree
	sprite.region_rect.position.x = region_rect_x
	sprite.region_rect.position.y = region_rect_y
	sprite.level = level
	timer.wait_time = randf_range(
		crops.crops[plantID]["growthRate"] * 0.43,
		crops.crops[plantID]["growthRate"]
	)
	timer.start()
	check(plantID, obj_position)

func check_node():
	return true
