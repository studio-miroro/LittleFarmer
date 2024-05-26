extends Node2D

@onready var tile_map: TileMap = $Tilemap
@onready var ui = get_node("/root/World/UI")
@onready var grid = get_node("/root/World/Buildings/Grid") 
@onready var pause = get_node("/root/World/UI/Pause")
@onready var panel = get_node("/root/World/UI/Interface")

var can_place_seed_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"
var can_place_watering_custom_data = "can_watering_dirt"

var farming_terrain_set = 0
var watering_terrain_set = 1
var farming_terrain = 0
var watering_terrain = 0

var ground_layer = 3
var farming_layer = 4
var watering_layer = 5
var seeds_layer = 6

var seed_id = 1
var seed:Vector2i = Vector2i(0,0)

func _process(delta):
	if !pause.paused:
		var mode = grid.mode
		if Input.is_action_just_pressed("click left") and mode != grid.gridmode.nothing:
			farm()

func _ready():
	ui.visible = true 
	
func farm():
		var mode = grid.mode
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_mouse_pos = tile_map.local_to_map(mouse_pos)
		var farming_tile_positions = []
		var watering_tile_positions = []
		await get_tree().create_timer(0.1).timeout
		if mode == grid.gridmode.farming\
		and !pause.paused\
		and grid.visible\
		and panel.farming:
			if check_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer)\
			and !cell_check(tile_mouse_pos, farming_layer):
				farming_tile_positions.append(tile_mouse_pos)
				tile_map.set_cells_terrain_connect(farming_layer,farming_tile_positions,farming_terrain_set, farming_terrain)
				
		if mode == grid.gridmode.seeds\
		and !pause.paused\
		and grid.visible\
		and panel.plant:
			var _source_id = 3
			if cell_check(tile_mouse_pos, watering_layer)\
			and !cell_check(tile_mouse_pos, seeds_layer):
				pass
			if !cell_check(tile_mouse_pos, seeds_layer)\
			and !check_custom_data(tile_mouse_pos, can_place_seed_custom_data, watering_layer)\
			and check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farming_layer)\
			and !cell_check(tile_mouse_pos, watering_layer)\
			and cell_check(tile_mouse_pos, farming_layer):
				pass
				
		if mode == grid.gridmode.watering\
		and !pause.paused\
		and grid.visible\
		and panel.watering:
			if check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farming_layer)\
			and !cell_check(tile_mouse_pos, watering_layer)\
			and !check_custom_data(tile_mouse_pos, can_place_watering_custom_data, seeds_layer):
				watering_tile_positions.append(tile_mouse_pos)
				start_process(seed_id, 0, 4, tile_mouse_pos, tile_map.get_cell_atlas_coords(seeds_layer, tile_mouse_pos), false)
				tile_map.set_cells_terrain_connect(watering_layer,watering_tile_positions,watering_terrain_set, watering_terrain)
				start_process(seed_id, 0, 4, tile_mouse_pos, tile_map.get_cell_atlas_coords(seeds_layer, tile_mouse_pos), true)
			elif check_custom_data(tile_mouse_pos, can_place_watering_custom_data, seeds_layer) && !cell_check(tile_mouse_pos, watering_layer):
				watering_tile_positions.append(tile_mouse_pos)
				start_process(seed_id, 0, 4, tile_mouse_pos, tile_map.get_cell_atlas_coords(seeds_layer, tile_mouse_pos), false)
				tile_map.set_cells_terrain_connect(watering_layer,watering_tile_positions,watering_terrain_set, watering_terrain)
				start_process(seed_id, 0, 4, tile_mouse_pos, tile_map.get_cell_atlas_coords(seeds_layer, tile_mouse_pos), true)
				
		#if mode == grid.gridmode.destroy\
		#and !pause.paused\
		#and grid.visible\
		#and panel.destroy:
			#var mouse_poss: Vector2 = get_global_mouse_position()
			#var _tile_mouse_poss = tile_map.local_to_map(mouse_poss)
			#if cell_check(_tile_mouse_poss, farming_layer)\
			#and !cell_check(_tile_mouse_poss, seeds_layer):
				#tile_map.set_cells_terrain_connect(watering_layer,[_tile_mouse_poss],watering_terrain_set,-1)
				#tile_map.set_cells_terrain_connect(farming_layer,[_tile_mouse_poss],farming_terrain_set,-1)
			#if cell_check(_tile_mouse_poss, farming_layer)\
			#and cell_check(_tile_mouse_poss, seeds_layer):
				#tile_map.erase_cell(seeds_layer, _tile_mouse_poss)
		else:pass
		
func start_process(id,growth,level,mouse_position,atlas,state: bool):
	var source_id = 3
	if state:
		if cell_check(mouse_position, farming_layer)\
		and cell_check(mouse_position, watering_layer)\
		and cell_check(mouse_position, seeds_layer):
			tile_map.set_cell(seeds_layer,mouse_position,source_id,atlas)
			await get_tree().create_timer(0).timeout
			if growth < level:
				var atlas_new = Vector2i(atlas.x+1, atlas.y)
				start_process(id, growth+1,level,mouse_position,atlas_new,true)
			if growth == level:
				state = false
		else:pass
	if !state:
		if cell_check(mouse_position, farming_layer)\
		and !cell_check(mouse_position, watering_layer):
			tile_map.set_cell(seeds_layer,mouse_position,source_id,atlas)
	else:pass

func check_custom_data(tile_mouse,custom_data_layer,layer):
	var tile_data: TileData = tile_map.get_cell_tile_data(layer,tile_mouse)
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false

func cell_check(vector_mos, current_tile):
	if tile_map.get_cell_source_id(current_tile,vector_mos) == -1:
		return false
		grid.change_texture(true)
	else:
		return true
		grid.change_texture(false)
