extends Node

@onready var main_scene = str(get_tree().root.get_child(1).name)
var mode:bool

func loading(transfer_data:bool) -> void:
	self.mode = transfer_data