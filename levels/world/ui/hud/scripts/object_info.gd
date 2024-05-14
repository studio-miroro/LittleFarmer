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
var label = Label.new()

func _process(delta):
	if object_1.visible && object_2.visible:
		position = get_global_mouse_position()

func object(
	object_position:Vector2, 
	object_name:String, 
	object_description:String, 
	object_level:int,
	object_slots:int, 
	object_visible:bool):
	if object_visible:
		$AnimationPlayer.play("transform")
		position = object_position
		get_data(object_name, object_description, object_level, object_slots)
	if !object_visible:
		$AnimationPlayer.play("transoform_rest")
		
func get_data(object_name:String, object_description:String, object_level:int, object_slots:int):
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
	
func object_visible():
	object_1.visible = true
	object_2.visible = true
	
func object_invisible():
	object_1.visible = false
	object_2.visible = false
