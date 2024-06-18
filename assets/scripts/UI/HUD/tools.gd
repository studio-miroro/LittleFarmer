extends Control

@onready var destroy_button = $"Tools Menu/Tools Hud/Container/Destroy"
@onready var farming_button = $"Tools Menu/Tools Hud/Container/Farm"
@onready var watering_button = $"Tools Menu/Tools Hud/Container/Watering"
@onready var building_button = $"Tools Menu/Tools Hud/Container/Building"

@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid")

var destroy:bool
var farming:bool
var plant:bool
var watering:bool
var building:bool

func _ready():
	get_node("/root/World/Buildings/Grid").visible = false

func _input(event):
	if grid.mode != grid.gridmode.NOTHING\
	and !pause.paused:
		if Input.is_action_just_pressed("click right"):
			grid.mode = grid.gridmode.NOTHING
			get_node("/root/World/Buildings/Grid").visible = false
			destroy_button.release_focus()
			watering_button.release_focus()
			farming_button.release_focus()
			building_button.release_focus()
			destroy = false
			farming = false
			plant = false
			watering = false
			building = false

# --- Destroy ---
func _on_destroy_pressed():
	if !destroy:
		if !pause.paused:
			grid.mode = grid.gridmode.DESTROY
			destroy_button.grab_focus()
			get_node("/root/World/Buildings/Grid").visible = true
			destroy = true
			farming = false
			plant = false
			watering = false
			building = false

func _on_destroy_mouse_entered():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = false

func _on_destroy_mouse_exited():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = true

# --- Watering ---
func _on_watering_pressed():
	if !watering:
		if !pause.paused:
			grid.mode = grid.gridmode.WATERING
			watering_button.grab_focus()
			get_node("/root/World/Buildings/Grid").visible = true
			destroy = false
			farming = false
			plant = false
			watering = true
			building = false
			
func _on_watering_mouse_entered():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = false

func _on_watering_mouse_exited():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = true
	
# --- Farming ---
func _on_farm_pressed():
	if !farming:
		if !pause.paused:
			grid.mode = grid.gridmode.FARMING
			farming_button.grab_focus()
			get_node("/root/World/Buildings/Grid").visible = true
			destroy = false
			farming = true
			plant = false
			watering = false
			building = false
			
func _on_farm_mouse_entered():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = false

func _on_farm_mouse_exited():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = true
	
# --- Building ---
func _on_building_pressed():
	if !building:
		if !pause.paused:
			grid.mode = grid.gridmode.BUILDING
			building_button.grab_focus()
			destroy = false
			farming = false
			plant = false
			watering = false
			building = true

func _on_building_mouse_entered():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = false

func _on_building_mouse_exited():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = true

# --- Planting ---
func _on_button_pressed():
	if !plant:
		if !pause.paused:
			grid.mode = grid.gridmode.SEEDS
			building_button.grab_focus()
			get_node("/root/World/Buildings/Grid").visible = true
			destroy = false
			farming = false
			plant = true
			watering = false
			building = false

func _on_button_mouse_entered():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = false

func _on_button_mouse_exited():
	if grid.mode != grid.gridmode.NOTHING:
		get_node("/root/World/Buildings/Grid").visible = true
