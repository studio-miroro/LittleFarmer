extends CanvasGroup

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var tilemap:Node2D = get_node("/root/" + main_scene + "/Tilemap")
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var timer:Timer = $CloudTimer
@export var sprites:Array = [
	preload("res://assets/resources/nature/clouds/cloud_0.png"),
	preload("res://assets/resources/nature/clouds/cloud_1.png"),
	preload("res://assets/resources/nature/clouds/cloud_2.png"),
	preload("res://assets/resources/nature/clouds/cloud_3.png"),
	preload("res://assets/resources/nature/clouds/cloud_4.png"),
	preload("res://assets/resources/nature/clouds/cloud_5.png"),
	preload("res://assets/resources/nature/clouds/cloud_6.png"),
	preload("res://assets/resources/nature/clouds/cloud_7.png"),
	preload("res://assets/resources/nature/clouds/cloud_8.png"),
	preload("res://assets/resources/nature/clouds/cloud_9.png"),
	preload("res://assets/resources/nature/clouds/cloud_10.png")
]

var node:PackedScene = preload("res://assets/nodes/nature/clouds.tscn")
var max_distance:float = 600

func cloud_spawn() -> void:
	var distance = round(global_position.distance_to(get_node("/root/" + main_scene + "/Camera").global_position))
	if !pause.paused\
	and distance < max_distance:
		var cloud:Node2D = node.instantiate()
		var texture_id:int = randi() % sprites.size()
		var choose_texture:Texture = sprites[texture_id]
		
		cloud.texture = choose_texture
		cloud.animation()
		cloud_pos(cloud)
		add_child(cloud)
	
func cloud_pos(object):
	var random_x:int = randi_range(-480, 480)
	var random_y:int = randi_range(-270, 270)
	object.set_position(Vector2(random_x, random_y))

func _on_cloud_timer_timeout():
	if !pause.paused:
		timer.wait_time = randi_range(30,240)
		cloud_spawn()

func create_shadow(tile_mouse_pos:Vector2i, shadow_texture:CompressedTexture2D):
	var shadow:Sprite2D = Sprite2D.new()
	var vector_x = tilemap.map_to_local(tile_mouse_pos).x
	var vector_y = tilemap.map_to_local(tile_mouse_pos).y
	var target_vector = Vector2i(vector_x, vector_y + 5)

	shadow.texture = shadow_texture
	shadow.set_position(target_vector)
	add_child(shadow)
