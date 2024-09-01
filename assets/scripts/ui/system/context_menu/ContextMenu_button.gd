extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var menu = get_node("/root/" + main_scene + "/User Interface/System/ContextMenu")

var function:Array = []

func set_func(content):
	function.append(content)

func _on_pressed():
	print(function)
	menu.remove_menu()

func _on_mouse_entered():
	menu.mouse = true

func _on_mouse_exited():
	menu.mouse = false
