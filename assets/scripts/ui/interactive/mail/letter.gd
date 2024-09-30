extends Control

@onready var main = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var mail:Control = get_node("/root/"+main+"/UI/Interactive/Mailbox")
@onready var icon:TextureRect = $Button/HBoxContainer/MarginContainer/TextureRect
@onready var header:Label = $Button/HBoxContainer/Label

var symbols:int = 16
var index:int
var sprites:Dictionary = {
	"unread": load("res://assets/resources/ui/interactive/mail/icons/unread.png"),
	"readed": load("res://assets/resources/ui/interactive/mail/icons/readed.png"),
}

func set_data(id:int, content:String) -> void:
	self.index = id
	header.text = content
	_text()
	
func _text() -> void:
	if len(header.get_text()) > symbols:
		var current = header.get_text().substr(0, symbols) + "..."
		header.set_text(current)

func _update_letter_icon() -> void:
	if mail.letters[index].has("status"):
		match mail.letters[index]["status"]:
			"readed":
				icon.texture = sprites["readed"]
			"unread":
				icon.texture = sprites["unread"]
			_:
				data.debug("", "error")

func _on_button_pressed():
	mail.get_data(index)
	_update_letter_icon()
