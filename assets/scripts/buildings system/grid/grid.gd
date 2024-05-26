extends Node2D

@onready var pause = get_node("/root/World/UI/Pause")
@onready var hud = get_node("/root/World/UI/Interface")
@onready var tilemap = get_node("/root/World/Tilemap")
@onready var grid_object = get_node("/root/World/Buildings/Grid")
@onready var farm = get_node("/root/World/")
@onready var node = preload("res://assets/nodes/farming/plant.tscn")
@onready var grid = $Sprite2D
@onready var collision = $GridCollision

@export var default = preload("res://assets/resources/buildings/grid/default.png")
@export var error = preload("res://assets/resources/buildings/grid/error.png")

enum gridmode {nothing, destroy, farming, seeds, watering, building}
var mode = gridmode.nothing

var need_check = false

func _ready():
	grid.z_index = 10
	grid.texture = default
	
func _input(event):
	if !pause.paused and mode != gridmode.nothing:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			need_check = true

func _process(delta):
	if !pause.paused and mode != gridmode.nothing and grid_object.visible:
		if mode == gridmode.destroy:
			collision.BuildingCollisionCheck()
			if collision.BuildingCollisionCheck():
				change_texture(true)
			else:change_texture(false)
			need_check = false
			
		if mode == gridmode.farming:
			collision.FarmingCollisionCheck()
			if need_check:
				var seed = farm.seed_id
				if !collision.FarmingCollisionCheck():
					pass
				else:pass
			need_check = false
			
		if mode == gridmode.watering:
			collision.WateringCollisionCheck()
			if need_check:
				if !collision.WateringCollisionCheck():
					pass
				else:pass
			need_check = false
			
		if mode == gridmode.seeds:
			collision.PlantingCollisionCheck()
			if need_check:
				if !collision.PlantingCollisionCheck():
					pass
				else:pass
			need_check = false

func change_texture(collision):
	if collision:
		grid.texture = error
	else:
		grid.texture = default
