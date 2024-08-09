extends Control

@onready var container:MarginContainer = $Container
@onready var label:Label = $Container/MarginContainer/Label
@onready var panel:Panel = $Container/Panel

var tip:bool

func _process(delta):
	if tip:
		position = get_global_mouse_position()

func tooltip(text:String) -> void:
	if text != "":
		tip = true
		label.text = text
		visible = true
	else:
		tip = false
		visible = false
