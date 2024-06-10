extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var tilemap = get_node("/root/World/Tilemap")
@onready var grid = get_node("/root/World/Buildings/Grid")
@onready var collision = get_node("/root/World/Buildings/Grid/GridCollision")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

enum phases {planted,growing,increased,dead}
enum fertilizers {nothing}
var plantID:int = 0
var condition:int = phases.planted
var fertilizer:int = fertilizers.nothing
var degree:int = 0

func _process(delta):
	if Input.is_action_just_pressed("toggle_dirt"):
		print(str(plantID) + " " + str(condition) + " " + str(degree))
	if pause.paused:
		if !timer.paused:
			timer.set_paused(true)
	else:
		if timer.paused:
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
	and condition != phases.dead:
		self.condition = phases.planted
		await get_tree().create_timer(
				crops.crops["checkWatering"]
			).timeout
		if degree < crops.crops[plantID]["mortality"]:
			degree += 1
		else:
			self.condition = phases.dead
		check(id,pos)

	elif collision.cell_check(pos, collision.farming_layer)\
	and collision.cell_check(pos, collision.watering_layer)\
	and condition != phases.dead:
		self.condition = phases.growing
		time()
	else:pass
		
func time():
	match condition:
		phases.growing:
			timer.wait_time = randf_range(
				crops.crops[plantID]["growthRate"] * 0.43,
				crops.crops[plantID]["growthRate"]
			)
			timer.start()
		phases.increased:
			timer.stop()
#
func _on_collision_mouse_entered():
	if !pause.paused:
		if grid.mode == grid.gridmode.nothing:
			ui.tooltip_plant(
				get_global_mouse_position(),
				plantID,
				position,
				condition,
				true
			)
	else:
		ui.tooltip_plant(
			Vector2(0,0),
			0,
			Vector2(0,0),
			0,
			false
		)
func _on_collision_mouse_exited():
	if !pause.paused:
		if grid.mode == grid.gridmode.nothing:
			ui.tooltip_plant(
				Vector2(0,0),
				0,
				Vector2(0,0),
				0,
				false
			)

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

func set_data(ID, condition, degree, region_rect_x, region_rect_y, level, obj_position):
	self.plantID = ID
	self.condition = condition
	self.degree = degree
	sprite.region_rect.position.x = region_rect_x
	sprite.region_rect.position.y = region_rect_y
	sprite.level = level
	print(
		"plantID: " 
		+ str(plantID) + 
		", condition: " 
		+ str(condition) + 
		", degree: " 
		+ str(degree) + 
		", rect_x: " 
		+ str(region_rect_x) + 
		", rect_y: " 
		+ str(region_rect_y) +
		", level: " 
		+ str(level)
		)
	check(plantID, obj_position)

func check_node():
	return true
