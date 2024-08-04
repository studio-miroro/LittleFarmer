extends Control

@onready var parent:VBoxContainer = $MarginContainer/VBoxContainer
@onready var node:PackedScene = load("res://assets/nodes/ui/notice.tscn")
var max:int = 24
		
func create_notice(image, text:String):
	var notice = node.instantiate()
	if childrens() < max:
		if text != "":
			parent.add_child(notice)
			notice.notice(image, text)

func childrens():
	var items:int
	for i in parent.get_children():
		items+=1
	return items
