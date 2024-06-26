extends Control

@onready var margin = $MarginContainer
@onready var container = $MarginContainer/VBoxContainer
@onready var object_1 = $MarginContainer/Panel
@onready var object_2 = $MarginContainer/VBoxContainer
@onready var header = $MarginContainer/VBoxContainer/Name
@onready var description = $MarginContainer/VBoxContainer/Description
@onready var level = $MarginContainer/VBoxContainer/Level
@onready var slots = $MarginContainer/VBoxContainer/Slots
var offset:int = -125

var crops = Crops.new()

func _ready():
	object_invisible()

func _process(delta):
	if object_1.visible && object_2.visible:
		position = get_global_mouse_position()

func tooltip(
	mouse_position:Vector2, 
	object_name:String, 
	object_description:String, 
	object_level:int,
	object_slots:int, 
	object_visible:bool):
	if object_visible:
		object_visible()
		position = mouse_position
		object(object_name, object_description, object_level, object_slots)
	else:
		object_invisible()
func tooltip_plant(
	mouse_position:Vector2,
	plant_id:int,
	plant_position:Vector2,
	condition:int,
	fertilizer:int,
	object_visible:bool
	):
	if object_visible:
		object_visible()
		position = mouse_position
		set_plant_info(plant_id,plant_position,condition,fertilizer)
	else:
		object_invisible()
		
func set_plant_info(id, pos, condition, fertilizer):
	header.text = crops.crops[id]["caption"]
	description.text = "Состояние: " + str(plant_condition(condition))
	level.visible = true
	level.text = "Удобрено: " + str(plant_fertilizer(fertilizer))
	slots.visible = false
	margin.offset_top = offset
	margin.offset_bottom = offset
	
func object(object_name:String, object_description:String, object_level:int, object_slots:int):
	if object_slots > 0:
		slots.visible = true
		margin.offset_top = offset - 25
		margin.offset_bottom = offset - 25
	if object_slots == 0:
		slots.visible = false
		margin.offset_top = offset
		margin.offset_bottom = offset
	if object_level > 0:
		level.visible = true
	if object_level == 0:
		level.visible = false
		margin.offset_top = offset + 25
		margin.offset_bottom = offset + 25
		
	header.text = object_name
	description.text = object_description
	level.text = "Уровень: "+str(object_level)
	slots.text = "Вместимость: "+str(object_slots)
	
func plant_condition(condition):
	match condition:
		0:
			return "Посажено"
		1:
			return "Растет"
		2:
			return "Выросло"
		3:
			return "Погибло"
			
func plant_fertilizer(fertilizer):
	match fertilizer:
		0:
			return "Нет"
		1:
			return "Компост"
		2:
			return "Перегной"
		3:
			return "Навоз"
	
func object_visible():
	object_1.visible = true
	object_2.visible = true
	
func object_invisible():
	object_1.visible = false
	object_2.visible = false
