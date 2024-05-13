extends Control

var destroy:bool = false
var farming:bool = false
var plant:bool = false
var watering:bool = false
var building:bool = false

func _input(event):
	if game_variables.mode != game_variables.gamemode.NOTHING\
	and !$"../Pause".paused:
		if Input.is_action_just_pressed("click right"):
			game_variables.mode = game_variables.gamemode.NOTHING
			$"Tools Menu/Tools Hud/Container/Destroy".release_focus()
			$"Tools Menu/Tools Hud/Container/Watering".release_focus()
			$"Tools Menu/Tools Hud/Container/Farm".release_focus()
			$"Tools Menu/Tools Hud/Container/Building".release_focus()
			destroy = false
			farming = false
			plant = false
			watering = false
			building = false
# Tools
func _on_destroy_pressed():
	if !destroy:
		if !$"../Pause".paused:
			game_variables.mode = game_variables.gamemode.DESTROY
			$"Tools Menu/Tools Hud/Container/Destroy".grab_focus()
			destroy = true
			farming = false
			plant = false
			watering = false
			building = false

func _on_watering_pressed():
	if !watering:
		if !get_node("/root/World/UI/Pause").paused:
			game_variables.mode = game_variables.gamemode.WATERING
			$"Tools Menu/Tools Hud/Container/Watering".grab_focus()
			destroy = false
			farming = false
			plant = false
			watering = true
			building = false

func _on_farm_pressed():
	if !farming:
		if !$"../Pause".paused:
			game_variables.mode = game_variables.gamemode.FARMING
			$"Tools Menu/Tools Hud/Container/Farm".grab_focus()
			destroy = false
			farming = true
			plant = false
			watering = false
			building = false

func _on_building_pressed():
	if !plant:
		if !get_node("/root/World/UI/Pause").paused:
			game_variables.mode = game_variables.gamemode.SEEDS
			$"Tools Menu/Tools Hud/Container/Building".grab_focus()
			destroy = false
			farming = false
			plant = true
			watering = false
			building = false
		
