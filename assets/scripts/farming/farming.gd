extends Node2D

@onready var tilemap = get_node("/root/World/Tilemap")
@onready var collision = get_node("/root/World/Buildings/Grid/GridCollision")
@onready var node = preload("res://assets/nodes/farming/plant.tscn")

func crop(id:int, pos:Vector2):
	var plant = node.instantiate()
	var mouse_position = tilemap.local_to_map(get_global_mouse_position())
	var atlas_coords = Vector2i(0,3)
	var source_id = 0
	
	if collision.cell_check(pos, collision.farming_layer)\
	and !collision.cell_check(pos, collision.watering_layer):
		tilemap.set_cell(
			collision.seeds_layer,
			pos,
			source_id,
			atlas_coords
		)
		plant.set_position(tilemap.map_to_local(mouse_position))
		add_child(plant)
		plant.z_index = 6
		plant.name = "Plant_1"
		plant.plant(id)
		plant.check(id,pos)
	else:
		tilemap.set_cell(
			collision.seeds_layer,
			pos,
			source_id,
			atlas_coords
		)
		plant.set_position(tilemap.map_to_local(mouse_position))
		add_child(plant)
		plant.z_index = 6
		plant.name = "Plant_1"
		plant.plant(id)
		plant.check(id,pos)

func destroy(target_position: Vector2):
	for child in get_children():
		if child.position == target_position:
			remove_child(child)
			child.queue_free()
