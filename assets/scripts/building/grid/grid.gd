extends Node2D

@onready var pause = get_node("/root/World/UI/Pause")
@onready var hud = get_node("/root/World/UI/Interface")
@onready var tilemap = get_node("/root/World/Tilemap")
@onready var grid_object = get_node("/root/World/Buildings/Grid")
@onready var farming = get_node("/root/World/Farming")
@onready var farm = get_node("/root/World/")
@onready var node = preload("res://assets/nodes/farming/plant.tscn")
@onready var grid = $Sprite2D
@onready var collision = $GridCollision

@export var default = preload("res://assets/resources/buildings/grid/default.png")
@export var error = preload("res://assets/resources/buildings/grid/error.png")

var need_check = false
enum gridmode {
	nothing, 
	destroy, 
	farming, 
	seeds, 
	watering, 
	building
	}
var mode = gridmode.nothing
var seed = 1

func _ready():
	grid.z_index = 10
	grid.texture = default
	
func _input(event):
	if !pause.paused and mode != gridmode.nothing:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			need_check = true
		if Input.is_action_just_pressed("nothing"):
			get_used_cells(collision.farming_layer)

func _process(delta):
	if !pause.paused and grid_object.visible:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
		var farming_tile_position = []
		var watering_tile_position = []
		match mode:
			gridmode.destroy:
				collision.DestroyCollisionCheck()
				if need_check:
					match collision.DestroyCollisionCheck():
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
							farming.destroy(
								tilemap.map_to_local(
									tile_mouse_pos
									)
								)
						4:
							tilemap.erase_cell(
								collision.seeds_layer,
								tile_mouse_pos
							)
							farming.destroy(
								tilemap.map_to_local(
									tile_mouse_pos
									)
								)
				need_check = false
				
			gridmode.farming:
				collision.FarmingCollisionCheck()
				if need_check:
					if collision.FarmingCollisionCheck():
						farming_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.farming_layer,
							farming_tile_position,
							collision.farming_terrain_set,
							collision.farming_terrain
							)
					else:pass
				need_check = false
				
			gridmode.watering:
				collision.WateringCollisionCheck()
				if need_check:
					if collision.WateringCollisionCheck():
						watering_tile_position.append(tile_mouse_pos)
						tilemap.set_cells_terrain_connect(
							collision.watering_layer,
							watering_tile_position,
							collision.watering_terrain_set,
							collision.watering_terrain
							)
					else:pass
				need_check = false
				
			gridmode.seeds:
				collision.PlantingCollisionCheck()
				if need_check:
					var ID = randi_range(1,2)
					if collision.PlantingCollisionCheck():
						farming.crop(ID, tile_mouse_pos)
					else:pass
				need_check = false

			#gridmode.building:
				#collision.BuildingCollisionCheck()
				#if need_check:
					#if collision.BuildingCollisionCheck():
						#var source_id = 0
						#var atlas_coords = Vector2i(0,3)
						#tilemap.set_cell(
							#collision.seeds_layer,
							#tile_mouse_pos,
							#source_id,
							#atlas_coords
						#)
						#farming.plant(seed)
					#else:pass
				#need_check = false

func get_used_cells(layer):
	return tilemap.get_used_cells(layer)

func change_texture(collision):
	if collision:
		grid.texture = error
	else:
		grid.texture = default
