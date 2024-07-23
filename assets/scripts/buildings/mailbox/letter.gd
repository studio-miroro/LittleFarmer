extends Control

@onready var mailbox:Control = get_node("/root/World/UI/Pop-up Menu/Mailbox")

@onready var icon:TextureRect = $Button/HBoxContainer/MarginContainer/TextureRect
@onready var label:Label = $Button/HBoxContainer/Label

var symbols:int = 16
var sprites:Dictionary = {
	"not": null,#load("")
	"readed": null,#load("")
}

var index:int
var status:int = statuses.NOT
enum statuses {NOT, READED}

func set_data(id:int, header:String) -> void:
	self.index = id
	label.text = header
	text()
	
func text() -> void:
	var len = len(label.get_text())
	if len > symbols:
		var current = label.get_text().substr(0, symbols) + "..."
		label.set_text(current)

func check_status():
	if status == statuses.NOT:
		status = statuses.READED

func _on_button_pressed():
	mailbox.get_data(index)
	check_status()
