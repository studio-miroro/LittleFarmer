extends Control

var paused: bool

func _ready():
	get_node("/root/World/UI").visible = true
	$".".z_index = 1
	$menu/version.text = "Версия: " + ProjectSettings.get_setting("application/config/version")
	paused = false
	get_node("/root/World/Player").swing = true
	await get_tree().create_timer(0.75).timeout
	get_node("/root/World/Player").swing = false
	get_node("/root/World/UI/Blackout").blackout_reset(4)
	get_node("/root/World/UI/Blackout").key_parameter("gameload")
	get_node("/root/World/UI/Interface/Time").timerstop(false)
	get_node("/root/World/UI/Interface/Time").timerupdate()
	await get_tree().create_timer(0.25).timeout
	get_node("/root/World/Player/Camera2D").switch = true

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		pausemenu()

func pausemenu():
	if !paused:
		paused = true
		$AnimationPlayer.play("blur_start")
		get_node("/root/World/Player").swing = true
		get_node("/root/World/Player").camera_speed = 0
		get_node("/root/World/UI/Interface/Time").timerupdate()
		get_node("/root/World/UI/Interface").destroy = false
		get_node("/root/World/UI/Interface").farming = false
		get_node("/root/World/UI/Interface").plant = false
		get_node("/root/World/UI/Interface").watering = false
		get_node("/root/World/UI/Interface").building = false
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Destroy").disabled = true
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Watering").disabled = true
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Farm").disabled = true
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Building").disabled = true	
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Destroy").release_focus()
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Watering").release_focus()
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Farm").release_focus()
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Building").release_focus()
		get_node("/root/World/UI/Debugger").visible = false
		get_node("/root/World/UI/Interface").visible = false
		get_node("/root/World/Buildings/Grid").mode = get_node("/root/World/Buildings/Grid").gridmode.nothing
		get_node("/root/World/Buildings/Grid").visible = false
	else:
		paused = false
		get_node("/root/World/Player").swing = false
		get_node("/root/World/Player").camera_speed = 5
		$AnimationPlayer.play_backwards("blur_start")
		get_node("/root/World/UI/Debugger").visible = true
		get_node("/root/World/UI/Interface").visible = true
		get_node("/root/World/UI/Interface/Time").timerupdate()
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Destroy").disabled = false
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Watering").disabled = false
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Farm").disabled = false
		get_node("/root/World/UI/Interface/Tools Menu/Tools Hud/Container/Building").disabled = false
# Buttons
func _on_countinue_pressed():
	if paused:
		pausemenu()
		get_node("/root/World/Player").menu()
	else: 
		pass

func _on_settings_pressed():
	if paused:
		if !$"settings menu".visible:
			$"settings menu".visible = true
		else:
			$"settings menu".visible = false
	else:
		pass
		
func _on_quit_the_game_pressed():
	if paused and get_node("/root/World/Player").swing:
		get_node("/root/World/UI/Interface/Time").timerstop(true)
		get_node("/root/World/UI/Blackout").blackout(4)
		await get_tree().create_timer(1.25).timeout
		get_node("/root/World/UI/Blackout").key_parameter("quit")
	else:
		pass
