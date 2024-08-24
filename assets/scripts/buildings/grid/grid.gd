extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var tilemap:TileMap = get_node("/root/" + main_scene + "/Tilemap")

@onready var farming:Node2D = get_node("/root/" + main_scene + "/Farming")
@onready var farm:Node2D = get_node("/root/" + main_scene + "/")

@onready var grid:Sprite2D = $Sprite2D
@onready var collision:Area2D = $GridCollision

@export var default:CompressedTexture2D = load("res://assets/resources/buildings/grid/default.png")
@export var error:CompressedTexture2D = load("res://assets/resources/buildings/grid/error.png")

enum gridmode {NOTHING, DESTROY, FARMING, SEEDS, WATERING, BUILDING}
var mode:int = gridmode.NOTHING
var check:bool = false

func _ready():
	z_index = 10
	grid.texture = default
	
func _input(event):
	if !blur.state and mode != gridmode.NOTHING:
		if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_LEFT\
		and event.is_pressed()\
		and visible:
			check = true

		if event is InputEventMouseButton\
		and event.button_index == MOUSE_BUTTON_RIGHT\
		and event.is_pressed()\
		and visible:
			mode = gridmode.NOTHING
			visible = false
			check = false

func _process(_delta):
	if !blur.state and visible:

		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
		var ground_tile_position = []
		var farming_tile_position = []
		var watering_tile_position = []

		match mode:
			gridmode.DESTROY:
				collision.destroy_collision_check()
				if check:
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
				check = false

			gridmode.FARMING:
				collision.farming_collision_check()
				if check:
					if collision.farming_collision_check():
						farming_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.farming_layer,
							farming_tile_position,
							collision.farming_terrain_set,
							collision.farming_terrain
							)
				check = false

			gridmode.WATERING:
				collision.watering_collision_check()
				if check:
					if collision.watering_collision_check():
						watering_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.watering_layer,
							watering_tile_position,
							collision.watering_terrain_set,
							collision.watering_terrain
							)
				check = false

			gridmode.SEEDS:
				collision.planting_collision_check()
				if check:
					var ID = randi_range(1,4)
					if collision.planting_collision_check():
						farming.crop(ID, tile_mouse_pos)
				check = false

			gridmode.BUILDING:
				collision.building_collision_check()
				if check:
					if collision.building_collision_check():
						ground_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.ground_layer,
							ground_tile_position,
							collision.ground_terrain_set,
							collision.ground_terrain
							)
				check = false
	else:
		mode = gridmode.NOTHING
		visible = false
		check = false

func change_sprite(texture:bool):
	if texture:
		grid.texture = error
	else:
		grid.texture = default
