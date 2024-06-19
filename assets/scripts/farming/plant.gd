extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var tilemap = get_node("/root/World/Tilemap")
@onready var grid = get_node("/root/World/Buildings/Grid")
@onready var collision = get_node("/root/World/Buildings/Grid/GridCollision")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var crops = Crops.new()
enum phases {PLANTED,GROWING,INCREASED,DEAD}
enum fertilizers {NOTHING, COMPOST, HUMUS, MANURE}
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
	
func set_fertilizer(a):
	match a:
		0:
			self.fertilizer = fertilizers.NOTHING
			print("Fertilizer equal nothing")
		1:
			self.fertilizer = fertilizers.COMPOST
			print("Fertilizer equal compost")
		2:
			self.fertilizer = fertilizers.HUMUS
			print("Fertilizer equal humus")
		3:
			self.fertilizer = fertilizers.MANURE
			print("Fertilizer equal manure")
	
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
		set_fertilizer(randi_range(0,3))
		growth()
	else:pass
		
func growth():
	if condition == phases.GROWING:
		match fertilizer:
			fertilizers.NOTHING:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growthRate"] * 0.849,
					crops.crops[plantID]["growthRate"]
				)
				timer.start()
			fertilizers.COMPOST:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growthRate"] * 0.621,
					crops.crops[plantID]["growthRate"] * 0.995
				)
				timer.start()
			fertilizers.HUMUS:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growthRate"] * 0.431,
					crops.crops[plantID]["growthRate"] * 0.894
				)
				timer.start()
			fertilizers.MANURE:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growthRate"] * 0.332,
					crops.crops[plantID]["growthRate"] * 0.792
				)
				timer.start()
		print(timer.wait_time)
	if condition == phases.INCREASED:
		timer.stop()
			
func _on_collision_mouse_entered():
	if !pause.paused:
		if grid.mode == grid.gridmode.NOTHING:
			ui.tooltip_plant(get_global_mouse_position(), plantID, position, condition, fertilizer, true)
	else:
		ui.tooltip_plant(Vector2(0,0), 0, Vector2(0,0), 0, -1, false)
func _on_collision_mouse_exited():
	if !pause.paused:
		if grid.mode == grid.gridmode.NOTHING:
			ui.tooltip_plant(Vector2(0,0), 0, Vector2(0,0), 0, -1, false)

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
	growth()
	check(plantID, obj_position)

func check_node():
	return true
