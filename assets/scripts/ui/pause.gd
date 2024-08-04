extends Control

class_name PauseMenu
@onready var ui:CanvasLayer = get_node("/root/World/User Interface")
@onready var interface:Control = get_node("/root/World/User Interface/HUD")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")
@onready var camera:Camera2D = get_node("/root/World/Camera/Camera2D")
@onready var time:Control = get_node("/root/World/User Interface/HUD/Time")
@onready var blackout:Control = get_node("/root/World/User Interface/Blackout")
@onready var player:Object = Camera.new()
@onready var build:Object = BuildingMenu.new()
@onready var version:Label = $menu/version

var lock:bool
var paused:bool

func _ready():
	get_node("/root/World/User Interface").visible = true
	z_index = 1
	version.text = "Версия: " + ProjectSettings.get_setting("application/config/version")
	paused = false
	player.switch = true
	await get_tree().create_timer(0.75).timeout
	player.switch = true
	blackout.blackout_reset(4)
	blackout.key_parameter("gameload")
	time.timerstop(false)
	time.timerupdate()
	await get_tree().create_timer(0.25).timeout
	camera.switch = false

func _process(_delta):
	if Input.is_action_just_pressed("menu")\
	and !lock:
		pausemenu()

func pausemenu():
	if !paused\
	and !lock:
		paused = true
		$AnimationPlayer.play("blur_start")
		get_node("/root/World/User Interface/HUD/Time").timerupdate()
		get_node("/root/World/User Interface/HUD").destroy = false
		get_node("/root/World/User Interface/HUD").farming = false
		get_node("/root/World/User Interface/HUD").planting = false
		get_node("/root/World/User Interface/HUD").watering = false
		get_node("/root/World/User Interface/HUD").building = false
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Destroy").disabled = true
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Watering").disabled = true
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Farm").disabled = true
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Building").disabled = true	
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Destroy").release_focus()
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Watering").release_focus()
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Farm").release_focus()
		get_node("/root/World/User Interface/HUD/Tools Menu/Tools Hud/Container/Building").release_focus()
		get_node("/root/World/User Interface/Debugger").visible = false
		get_node("/root/World/User Interface/HUD").visible = false
		get_node("/root/World/Buildings/Grid").mode = get_node("/root/World/Buildings/Grid").gridmode.NOTHING
		get_node("/root/World/Buildings/Grid").visible = false
		blur.blur(true)

	else:
		paused = false
		$AnimationPlayer.play_backwards("blur_start")
		get_node("/root/World/User Interface/Debugger").visible = true
		get_node("/root/World/User Interface//HUD").visible = true
		get_node("/root/World/User Interface//HUD/Time").timerupdate()
		get_node("/root/World/User Interface//HUD/Tools Menu/Tools Hud/Container/Destroy").disabled = false
		get_node("/root/World/User Interface//HUD/Tools Menu/Tools Hud/Container/Watering").disabled = false
		get_node("/root/World/User Interface//HUD/Tools Menu/Tools Hud/Container/Farm").disabled = false
		get_node("/root/World/User Interface//HUD/Tools Menu/Tools Hud/Container/Building").disabled = false
		blur.blur(false)

# Buttons
func _on_countinue_pressed():
	if paused:
		pausemenu()
		get_node("/root/World/MainCamera").menu()

func _on_settings_pressed():
	if paused:pass
		
func _on_quit_the_game_pressed():
	if paused:
		get_node("/root/World/User Interface/HUD/Time").timerstop(true)
		get_node("/root/World/User Interface/Blackout").blackout(4)
		await get_tree().create_timer(1.25).timeout
		get_node("/root/World/User Interface/Blackout").key_parameter("quit")

func _on_save_data_pressed():
	if paused:
		json.gamesave()
		pausemenu()
		get_node("/root/World/Camera").menu()

func _on_load_data_pressed():
	if paused:
		json.gameload()
		pausemenu()
		get_node("/root/World/Camera").menu()

