extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var ui:CanvasLayer = get_node("/root/" + main_scene + "/User Interface")
@onready var hud:Control = get_node("/root/" + main_scene + "/User Interface/Hud")
@onready var options:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Options")
@onready var blackout:Control = get_node("/root/" + main_scene + "/User Interface/Blackout")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")

@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")
@onready var zoom:Camera2D = get_node("/root/" + main_scene + "/Camera/Camera2D")
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var version:Label = $MarginContainer/MarginContainer/container/version/version

var paused:bool
var other_menu:bool
var lock:bool = true

func _ready():
	print(get_tree().root)
	player.switch = true
	player.check_switch()
	await get_tree().create_timer(0.75).timeout
	player.switch = true
	zoom.zooming = false
	blackout.blackout(false)
	await get_tree().create_timer(0.25).timeout
	lock = false
	hud._show()
	player.switch = false
	player.check_switch()

func _process(_delta):
	if Input.is_action_just_pressed("pause")\
	and !lock\
	and !other_menu\
	and !options.visible:
		pause()

func pause():
	if !paused\
	and !lock:
		open()
	else:
		close()

func update_string_version() -> void:
	var version_prefix = tr("version.game:")
	var version_number = ProjectSettings.get_setting("application/config/version")
	version.text = version_prefix + version_number
	
func open() -> void:
	paused = true
	anim.play("open")
	blur.blur(true)
	hud._hide()
	player.check_switch()
	update_string_version()

	if has_node("/root/" + main_scene + "/Buildings/Grid"):
		grid.visible = false

func close() -> void:
	paused = false
	anim.play("close")
	blur.blur(false)
	hud._show()
	player.check_switch()
