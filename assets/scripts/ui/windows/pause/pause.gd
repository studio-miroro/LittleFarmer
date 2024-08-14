extends Control

@onready var ui:CanvasLayer = get_node("/root/World/User Interface")
@onready var hud:Control = get_node("/root/World/User Interface/Hud")
@onready var options:Control = get_node("/root/World/User Interface/Windows/Options")
@onready var blackout:Control = get_node("/root/World/User Interface/Blackout")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")

@onready var grid:Node2D = get_node("/root/World/Buildings/Grid")
@onready var player:CharacterBody2D = get_node("/root/World/Camera")
@onready var zoom:Camera2D = get_node("/root/World/Camera/Camera2D")

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var version:Label = $MarginContainer/MarginContainer/container/version/version

var paused:bool
var other_menu:bool

func _ready():
	player.switch = true
	player.check_switch()
	await get_tree().create_timer(0.75).timeout
	player.switch = true
	zoom.zooming = false
	blackout.blackout(false)
	await get_tree().create_timer(0.25).timeout
	hud._show()
	player.switch = false
	player.check_switch()

func _process(_delta):
	if Input.is_action_just_pressed("pause")\
	and !other_menu\
	and !options.visible:
		pause()

func pause():
	if !paused:
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
	grid.visible = false
	update_string_version()

func close() -> void:
	paused = false
	anim.play("close")
	blur.blur(false)
	hud._show()
	player.check_switch()
