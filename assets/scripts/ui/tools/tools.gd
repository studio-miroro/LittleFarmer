extends Control

@onready var destroy_button = $"Tools Menu/Tools Hud/Container/Destroy"
@onready var farming_button = $"Tools Menu/Tools Hud/Container/Farm"
#@onready var plant_button = $"Tools Menu/Tools Hud/Container/Destroy"
@onready var watering_button = $"Tools Menu/Tools Hud/Container/Watering"
@onready var building_button = $"Tools Menu/Tools Hud/Container/Building"

@onready var pause = get_node("/root/World/UI/Pause")

var destroy:bool
var farming:bool
var plant:bool
var watering:bool
var building:bool

func _input(event):
	if game_variables.mode != game_variables.gamemode.NOTHING\
	and !pause.paused:
		if Input.is_action_just_pressed("click right"):
			game_variables.mode = game_variables.gamemode.NOTHING
			destroy_button.release_focus()
			watering_button.release_focus()
			farming_button.release_focus()
			building_button.release_focus()
			destroy = false
			farming = false
			plant = false
			watering = false
			building = false
# Tools
func _on_destroy_pressed():
	if !destroy:
		if !pause.paused:
			game_variables.mode = game_variables.gamemode.DESTROY
			destroy_button.grab_focus()
			destroy = true
			farming = false
			plant = false
			watering = false
			building = false

func _on_watering_pressed():
	if !watering:
		if !get_node("/root/World/UI/Pause").paused:
			game_variables.mode = game_variables.gamemode.WATERING
			watering_button.grab_focus()
			destroy = false
			farming = false
			plant = false
			watering = true
			building = false

func _on_farm_pressed():
	if !farming:
		if !pause.paused:
			game_variables.mode = game_variables.gamemode.FARMING
			farming_button.grab_focus()
			destroy = false
			farming = true
			plant = false
			watering = false
			building = false

func _on_building_pressed():
	if !plant:
		if !get_node("/root/World/UI/Pause").paused:
			game_variables.mode = game_variables.gamemode.SEEDS
			building_button.grab_focus()
			destroy = false
			farming = false
			plant = true
			watering = false
			building = false
		
