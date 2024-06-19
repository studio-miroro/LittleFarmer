extends Control

class_name Inventory

var open:bool = false

func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		OpenInventory()

func OpenInventory():
	if !open:
		$".".visible = true
		open = true
	else:
		$".".visible = false
		open = false
