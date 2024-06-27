extends Control

class_name PauseMenu

@onready var ui 			= get_node("/root/World/UI")
@onready var interface 		= get_node("/root/World/UI/HUD/Interface")
@onready var blur			= get_node("/root/World/UI/Blur")
@onready var player 		= Camera.new()
@onready var camera 		= get_node("/root/World/Player/Camera2D")
@onready var time 			= get_node("/root/World/UI/HUD/Interface/Time")
@onready var blackout 		= get_node("/root/World/UI/Blackout")
@onready var version:Label 	= $menu/version

var paused: bool

func _ready():
	get_node("/root/World/UI").visible = true
	z_index = 1
	version.text = "Версия: " + ProjectSettings.get_setting("application/config/version")
	paused = false
	player.switch = true
	await get_tree().create_timer(0.75).timeout
	player.switch = false
	blackout.blackout_reset(4)
	blackout.key_parameter("gameload")
	time.timerstop(false)
	time.timerupdate()
	await get_tree().create_timer(0.25).timeout
	camera.switch = true

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		pausemenu()

func pausemenu():
	if !paused:
		paused = true
		$AnimationPlayer.play("blur_start")
		get_node("/root/World/UI/HUD/Interface/Time").timerupdate()
		get_node("/root/World/UI/HUD/Interface").destroy = false
		get_node("/root/World/UI/HUD/Interface").farming = false
		get_node("/root/World/UI/HUD/Interface").plant = false
		get_node("/root/World/UI/HUD/Interface").watering = false
		get_node("/root/World/UI/HUD/Interface").building = false
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Destroy").disabled = true
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Watering").disabled = true
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Farm").disabled = true
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Building").disabled = true	
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Destroy").release_focus()
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Watering").release_focus()
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Farm").release_focus()
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Building").release_focus()
		get_node("/root/World/UI/Debugger").visible = false
		get_node("/root/World/UI/HUD/Interface").visible = false
		get_node("/root/World/Buildings/Grid").mode = get_node("/root/World/Buildings/Grid").gridmode.NOTHING
		get_node("/root/World/Buildings/Grid").visible = false
		get_node("/root/World/UI/HUD/Tooltip").tooltip(Vector2(0,0), "", "", 0, -1, false)
		get_node("/root/World/Buildings/House").change_sprite(false)
		get_node("/root/World/Buildings/Mailbox").change_sprite(false)
		get_node("/root/World/Buildings/Storage").change_sprite(false)
		get_node("/root/World/Buildings/Animal Stall").change_sprite(false)
		get_node("/root/World/Buildings/Silo").change_sprite(false)
		blur.blur(true, true)
		get_node("/root/World/Player").switch = true
	else:
		paused = false
		$AnimationPlayer.play_backwards("blur_start")
		get_node("/root/World/UI/Debugger").visible = true
		get_node("/root/World/UI/HUD/Interface").visible = true
		get_node("/root/World/UI/HUD/Interface/Time").timerupdate()
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Destroy").disabled = false
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Watering").disabled = false
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Farm").disabled = false
		get_node("/root/World/UI/HUD/Interface/Tools Menu/Tools Hud/Container/Building").disabled = false
		blur.blur(false, false)
		get_node("/root/World/Player").switch = false
# Buttons
func _on_countinue_pressed():
	if paused:
		pausemenu()
		get_node("/root/World/Player").menu()
	else: 
		pass

func _on_settings_pressed():
	if paused:pass
		#if !$"settings menu".visible:
			#$"settings menu".visible = true
		#else:
			#$"settings menu".visible = false
	else:
		pass
		
func _on_quit_the_game_pressed():
	if paused:
		get_node("/root/World/UI/HUD/Interface/Time").timerstop(true)
		get_node("/root/World/UI/Blackout").blackout(4)
		await get_tree().create_timer(1.25).timeout
		get_node("/root/World/UI/Blackout").key_parameter("quit")
	else:
		pass


func _on_save_data_pressed():
	if paused:
		json.gamesave()
		pausemenu()
		get_node("/root/World/Player").menu()
	else:
		pass

func _on_load_data_pressed():
	if paused:
		json.gameload()
		pausemenu()
		get_node("/root/World/Player").menu()
	else:pass

