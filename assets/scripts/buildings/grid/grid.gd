extends Node2D

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var hud:Control = get_node("/root/World/User Interface/Interface")
@onready var tilemap:TileMap = get_node("/root/World/Tilemap")
@onready var grid_object:Node2D = get_node("/root/World/Buildings/Grid")
@onready var farming:Node2D = get_node("/root/World/Farming")
@onready var farm:Node2D = get_node("/root/World/")
@onready var node:PackedScene = load("res://assets/nodes/farming/plant.tscn")
@export var default:CompressedTexture2D = load("res://assets/resources/buildings/grid/default.png")
@export var error:CompressedTexture2D = load("res://assets/resources/buildings/grid/error.png")
@onready var grid:Sprite2D = $Sprite2D
@onready var collision:Area2D = $GridCollision

enum gridmode {NOTHING,DESTROY,FARMING,SEEDS,WATERING,BUILDING}
var mode = gridmode.NOTHING
var need_check = false

func _ready():
	grid.z_index = 10
	grid.texture = default
	
func _input(event):
	if !pause.paused and mode != gridmode.NOTHING:
		if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_LEFT\
		and event.is_pressed()\
		and grid_object.visible:
			need_check = true

func _process(delta):
	if !pause.paused and grid_object.visible:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
		var ground_tile_position = []
		var farming_tile_position = []
		var watering_tile_position = []
		match mode:
			gridmode.DESTROY:
				collision.destroy_collision_check()
				if need_check:
					match collision.destroy_collision_check():
						0:
							tilemap.set_cells_terrain_connect(
							collision.ground_layer,
							[tile_mouse_pos],
							collision.ground_terrain_set,
							-1)
						1:
							tilemap.set_cells_terrain_connect(
							collision.farming_layer,
							[tile_mouse_pos],
							collision.farming_terrain_set,
							-1)
						2:
							tilemap.set_cells_terrain_connect(
							collision.watering_layer,
							[tile_mouse_pos],
							collision.watering_terrain_set,
							-1)
						3:
							tilemap.erase_cell(
								collision.seeds_layer,
								tile_mouse_pos
							)
							farming.plant_destroy(
								tilemap.map_to_local(
									tile_mouse_pos
									)
								)
						4:
							tilemap.erase_cell(
								collision.seeds_layer,
								tile_mouse_pos
							)
							farming.plant_destroy(
								tilemap.map_to_local(
									tile_mouse_pos
									)
								)
				need_check = false

			gridmode.FARMING:
				collision.farming_collision_check()
				if need_check:
					if collision.farming_collision_check():
						farming_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.farming_layer,
							farming_tile_position,
							collision.farming_terrain_set,
							collision.farming_terrain
							)
				need_check = false

			gridmode.WATERING:
				collision.watering_collision_check()
				if need_check:
					if collision.watering_collision_check():
						watering_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.watering_layer,
							watering_tile_position,
							collision.watering_terrain_set,
							collision.watering_terrain
							)
				need_check = false

			gridmode.SEEDS:
				collision.planting_collision_check()
				if need_check:
					var ID = randi_range(1,4)
					if collision.planting_collision_check():
						farming.crop(ID, tile_mouse_pos)
				need_check = false

			gridmode.BUILDING:
				collision.building_collision_check()
				if need_check:
					if collision.building_collision_check():
						ground_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.ground_layer,
							ground_tile_position,
							collision.ground_terrain_set,
							collision.ground_terrain
							)
				need_check = false

func get_used_cells(layer):
	return tilemap.get_used_cells(layer)

func change_texture(collision):
	if collision:
		grid.texture = error
	else:
		grid.texture = default
