extends Control

@onready var container:VBoxContainer = $MarginContainer/VBoxContainer
@onready var node:PackedScene = load("res://assets/nodes/ui/feedback/notifications/notice.tscn")

const maximum:int = 99

func create_notice(text:String, type = "") -> void:
	var notice = node.instantiate()
	if all_notices(container) < maximum:
		if text != "":
			container.add_child(notice)
			notice.notice(text, type)

func all_notices(parent) -> int:
	var items:int = 0
	for i in parent.get_children():
		items+=1
	return items
