extends Control

@onready var options:Control = get_node("/root/World/User Interface/Windows/Options")
@onready var label:Label = $MarginContainer/Label
var page:PackedScene = load("res://assets/nodes/ui/windows/pause/options/sections/pages/sounds.tscn")

func set_text(text:String) -> void:
	label.text = text
	
func set_page(scene:PackedScene) -> void:
	self.page = scene

func _on_button_pressed():
	if options.menu:
		if (page != null and typeof(page) == TYPE_OBJECT):
			options.page(page)
