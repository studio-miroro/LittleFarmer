extends Control

@onready var container:VBoxContainer = $MarginContainer/VBoxContainer
@onready var node:PackedScene = load("res://assets/nodes/ui/system/notifications/notice.tscn")
var max:int = 10

func _process(delta):
	if Input.is_action_just_pressed("click right"):
		create_notice("info", "Склад полон!")

func create_notice(image, text:String) -> void:
	var notice = node.instantiate()
	if all_notices(container) < max:
		if text != "":
			container.add_child(notice)
			notice.notice(image, text)

func all_notices(parent) -> int:
	var items:int
	for i in parent.get_children():
		items+=1
	return items
