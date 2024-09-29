extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var mailbox:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Mailbox")
@onready var icon:TextureRect = $Button/HBoxContainer/MarginContainer/TextureRect
@onready var header:Label = $Button/HBoxContainer/Label

var symbols:int = 16
var sprites:Dictionary = {
	"not": null,#load("")
	"readed": null,#load("")
}

var index:int
var status:int = statuses.NOT
enum statuses {NOT, READED}

func set_data(id:int, content:String) -> void:
	self.index = id
	header.text = content
	text()
	
func text() -> void:
	if len(header.get_text()) > symbols:
		var current = header.get_text().substr(0, symbols) + "..."
		header.set_text(current)

func check_status() -> void:
	if status == statuses.NOT:
		status = statuses.READED
		update_status()

func update_status() -> void:
	match status:
		statuses.NOT:
			print("Not")
		_:
			pass

func _on_button_pressed():
	mailbox.get_data(index)
	check_status()
