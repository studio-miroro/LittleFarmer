extends Control

class_name ContextMenu
@onready var container:VBoxContainer = $MainContainer/ButtonContainer/VBoxContainer
@onready var button:PackedScene = load("res://assets/nodes/ui/system/context_menu/ContextMenu_button.tscn")

var mouse:bool

func _input(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_RIGHT\
	and event.is_pressed():
		if !check_menu():
			create_menu(2, ["Посадить семена", "Убрать посев"], [1,2],)
			position = get_global_mouse_position()
		else:
			remove_menu()
			
	if !mouse:
		if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_LEFT\
		and event.is_pressed():
			remove_menu()

func create_menu(amount:int, string:Array, function:Array):
	visible = true
	for i in range(amount):
		var new_button = button.instantiate()
		if i < string.size():
			new_button.text = string[i]
			container.add_child(new_button)
			if i < function.size():
				new_button.set_func(function[i])

func remove_menu():
	if check_menu():
		visible = false
		for child in container.get_children():
			container.remove_child(child)

func check_menu():
	var childrens:Array = container.get_children()
	if childrens != []:
		return true
	else:
		return false
