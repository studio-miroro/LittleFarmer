extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/" + main_scene)
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var slot:PackedScene = load("res://assets/nodes/ui/inventory/slot.tscn")

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var header:Label = $Main/VBoxContainer/Header/Label
@onready var container:GridContainer = $Main/VBoxContainer/MarginContainer/ScrollContainer/GridContainer

var sign_name
var menu:bool = false

func _ready():
	_set_header()
	_check_window()

func _open(node_name) -> void:
	_create_all_items()
	anim.play("open")
	blur.blur(true)
	menu = true
	sign_name = node_name

func _close() -> void:
	_remove_all_items()
	anim.play("close")
	blur.blur(false)
	menu = false

func _set_header() -> void:
	var header_:String = tr("signmenu.header")
	header.text = header_ + ":"

func _create_all_items() -> void:
	for item in inventory.inventory_items:
		var slot_ = slot.instantiate()
		container.add_child(slot_)
		slot_.set_data(item, 1)

func _remove_all_items() -> void:
	for item in container.get_children():
		container.remove_child(item)

func _check_window() -> void:
	visible = menu	

func _on_exit_button_pressed():
	_close()
