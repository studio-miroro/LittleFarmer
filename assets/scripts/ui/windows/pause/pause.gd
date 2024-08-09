extends Control

@onready var ui:CanvasLayer = get_node("/root/World/User Interface")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid")

@onready var options:Control = get_node("/root/World/User Interface/Windows/Options")
@onready var hud:Control = get_node("/root/World/User Interface/Hud")
@onready var time:Control = get_node("/root/World/User Interface/Hud/Time")
@onready var debbuger:Control = get_node("/root/World/User Interface/Debugger")
@onready var blackout:Control = get_node("/root/World/User Interface/Blackout")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")

@onready var player:CharacterBody2D = get_node("/root/World/Camera")
@onready var camera:Camera2D = get_node("/root/World/Camera/Camera2D")

@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var version:Label = $MarginContainer/MarginContainer/container/version/version

var paused:bool
var other_menu:bool

func _ready():
	z_index = 1
	paused = false
	player.switch = true
	ui.visible = true
	await get_tree().create_timer(0.75).timeout
	player.switch = true
	blackout.blackout_reset(4)
	blackout.key_parameter("gameload")
	time.timerstop(false)
	time.timerupdate()
	await get_tree().create_timer(0.25).timeout
	camera.switch = false

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
	hud.reset_buttons()
	time.timerupdate()
	player.check_switch()
	hud.visible = false
	grid.visible = false
	debbuger.visible = false
	update_string_version()

func close() -> void:
	paused = false
	anim.play("close")
	blur.blur(false)
	hud.reset_buttons()
	time.timerupdate()
	player.check_switch()
	hud.visible = true
	debbuger.visible = true
