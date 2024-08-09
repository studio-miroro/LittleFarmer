extends Control

@onready var node:PackedScene = load("res://assets/nodes/ui/windows/pause/options/button.tscn")
@onready var change_language = get_node("/root/World/User Interface/Windows/Options/Panel/Main/HBoxContainer/VBoxContainer/VBoxContainer/Language")
@onready var button_container:VBoxContainer = $Panel/Main/HBoxContainer/VBoxContainer/Buttons/VBoxContainer
@onready var pages_container:VBoxContainer = $Panel/Main/HBoxContainer/Pages/VBoxContainer
@onready var language_button:Control = $Panel/Main/HBoxContainer/VBoxContainer/VBoxContainer/Language/MarginContainer/Label
@onready var exit_button:Control = $Panel/Main/HBoxContainer/VBoxContainer/VBoxContainer/Exit/MarginContainer/Label
@onready var anim:AnimationPlayer = $AnimationPlayer

var menu:bool

func _ready():
	visible = false

func page(scene:PackedScene) -> void:
	remove_pages()
	if pages_container.get_children() == []:
		var page = scene.instantiate()
		pages_container.add_child(page)

func remove_pages() -> void:
	if pages_container.get_children() != []:
		for child in pages_container.get_children():
			pages_container.remove_child(child)
			child.queue_free()

func open() -> void:
	anim.play("open")
	menu = true

func close() -> void:
	anim.play("close")
	remove_pages()
	menu = false

func window():
	visible = menu
