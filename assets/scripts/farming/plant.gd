extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var tip:Control = get_node("/root/" + main_scene + "/User Interface/System/Tooltip")
@onready var tilemap:TileMap = get_node("/root/" + main_scene + "/Tilemap")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")
@onready var collision:Area2D = get_node("/root/" + main_scene + "/Buildings/Grid/GridCollision")
@onready var sprite:Sprite2D = $Sprite2D
@onready var timer:Timer = $Timer

var plantID:int
var condition:int = phases.PLANTED
var fertilizer:int = fertilizers.NOTHING
var degree:int

enum phases {PLANTED,GROWING,INCREASED,DEAD}
enum fertilizers {NOTHING, COMPOST, HUMUS, MANURE}
var crops:Object = Crops.new()

func _process(_delta):
	if pause.paused:
		timer.set_paused(true)
	else:
		timer.set_paused(false)

func plant(id:int) -> void:
	self.plantID = id
	sprite.rect(id)
	
func set_fertilizer(type:int) -> void:
	match type:
		0:
			self.fertilizer = fertilizers.NOTHING
		1:
			self.fertilizer = fertilizers.COMPOST
		2:
			self.fertilizer = fertilizers.HUMUS
		3:
			self.fertilizer = fertilizers.MANURE
			
func check(id:int,pos:Vector2i) -> void:
	if !pause.paused:
		if collision.check_cell(pos, collision.farming_layer)\
		and !collision.check_cell(pos, collision.watering_layer)\
		and condition != phases.DEAD:
			self.condition = phases.PLANTED
			await get_tree().create_timer(
					crops.crops["check_watering"]
				).timeout
			if degree < crops.crops[plantID]["mortality"]:
				degree += 1
			else:
				self.condition = phases.DEAD
			check(id,pos)

		elif collision.check_cell(pos, collision.farming_layer)\
		and collision.check_cell(pos, collision.watering_layer)\
		and condition != phases.DEAD:
			self.condition = phases.GROWING
			set_fertilizer(randi_range(0,3))
			growth()

func growth() -> void:
	if condition == phases.GROWING:
		match fertilizer:
			fertilizers.NOTHING:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growth_rate"] * 0.849,
					crops.crops[plantID]["growth_rate"]
				)
			fertilizers.COMPOST:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growth_rate"] * 0.621,
					crops.crops[plantID]["growth_rate"] * 0.995
				)
			fertilizers.HUMUS:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growth_rate"] * 0.431,
					crops.crops[plantID]["growth_rate"] * 0.894
				)
			fertilizers.MANURE:
				timer.wait_time = randi_range(
					crops.crops[plantID]["growth_rate"] * 0.332,
					crops.crops[plantID]["growth_rate"] * 0.792
				)
		timer.start()
	if condition == phases.INCREASED:
		timer.stop()

func get_data() -> Dictionary:
	return {
		"plantID": self.plantID,
		"degree": self.degree,
		"condition": self.condition,
		"fertilizer": self.fertilizer,
		"region_rect.x": self.sprite.region_rect.position.x,
		"region_rect.y": self.sprite.region_rect.position.y,
		"growth_level": sprite.level,
		"position": tilemap.local_to_map(global_position),
	}

func set_data(id:int, conditionID:int, degreeID:int, fertilizerID:int, region_rect_x:int, region_rect_y:int, level:int, pos:Vector2i) -> void:
	self.plantID = id
	self.condition = conditionID
	self.degree = degreeID
	self.fertilizer = fertilizerID
	sprite.region_rect.position.x = region_rect_x
	sprite.region_rect.position.y = region_rect_y
	sprite.level = level
	growth()
	check(plantID, pos)

func get_condition(condition_type:int) -> String:
	match condition_type:
		0:
			return "Посажено"
		1:
			return "Процветает"
		2:
			return "Выросло"
		3:
			return "Погибло"
		_:
			return ""

func get_fertilizer(fertilizer_type:int) -> String:
	match fertilizer_type:
		1:
			return "Компост"
		2:
			return "Перегной"
		3:
			return "Навоз"
		_:
			return ""

func _on_collision_mouse_entered() -> void:
	if !blur.state\
	and grid.mode == grid.modes.NOTHING:
		if crops.crops.has(plantID):
			if crops.crops[plantID].has("caption"):
				if typeof(crops.crops[plantID]["caption"]) == TYPE_STRING:
					if fertilizer != fertilizers.NOTHING:
						tip.tooltip(
							crops.crops[plantID]["caption"] +"\n"+
							"Состояние: " + get_condition(condition) +"\n"+
							"Удобрено: " + get_fertilizer(fertilizer)
						)
					else:
						tip.tooltip(
							crops.crops[plantID]["caption"] +"\n"+
							"Состояние: " + get_condition(condition)
						)
				else:
					print_debug(str(manager.get_system_datetime()) + " ERROR: The 'caption' element is not a string type. Variant.type: " + str(typeof(crops.crops[plantID]["caption"])))
			else:
				print_debug(str(manager.get_system_datetime()) + " ERROR: The 'caption' element is missing.")
		else:
			print_debug(str(manager.get_system_datetime()) + " ERROR: Invalid ID: " + str(plantID))
		
func _on_collision_mouse_exited() -> void:
	if !pause.paused:
		tip.tooltip()

func check_node() -> bool:
	return true
