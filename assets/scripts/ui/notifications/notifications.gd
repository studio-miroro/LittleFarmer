extends Control

@onready var container:VBoxContainer = $MarginContainer/VBoxContainer
@onready var node:PackedScene = load("res://assets/nodes/ui/system/notifications/notice.tscn")

const maximum:int = 8

func create_notice(text:String, image = "") -> void:
	var notice = node.instantiate()
	if all_notices(container) < maximum:
		if text != "":
			container.add_child(notice)
			notice.notice(image, text)

func all_notices(parent) -> int:
	var items:int = 0
	for i in parent.get_children():
		items+=1
	return items
