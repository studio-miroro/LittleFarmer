extends Node

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var player:CharacterBody2D = get_node("/root/"+main+"/Player")
@onready var tilemap:TileMap = get_node("/root/"+main+"/Tilemap")
@onready var collision:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid/GridCollision")
@onready var canvas:CanvasGroup = get_node("/root/"+main+"/ShadowManager/CanvasGroup")

const max_widht_map:int = 39
const min_widht_map:int = -8
const max_height_map:int = 23
const min_height_map:int = -16

const max_distance:int = 525
const max_clouds:int = 32
var all_clouds:int = 0

func create_shadow(shadow_name:String, shadow_texture:CompressedTexture2D, shadow_position:Vector2i) -> void:
	if shadow_name == "":
		shadow_name = "shadow"
	var shadow:Sprite2D = Sprite2D.new()
	shadow.name = shadow_name
	shadow.texture = shadow_texture
	shadow.position = tilemap.map_to_local(shadow_position)
	canvas.add_child(shadow)

func create_cloud(shadow_texture:CompressedTexture2D) -> void:
	if all_clouds < max_clouds:
		var node:PackedScene = load("res://assets/nodes/world/cloud.tscn")
		var cloud = node.instantiate()
		var cloud_position_x = randi_range(min_widht_map, max_widht_map)
		var cloud_position_y = randi_range(min_height_map, max_height_map)
		var target_position = Vector2i(cloud_position_x, cloud_position_y)
		
		cloud.name = "cloud_"+ str(all_clouds)
		cloud.texture = shadow_texture
		cloud.position = tilemap.map_to_local(target_position)
		canvas.add_child(cloud)
		cloud.change_animation(true)
		all_clouds += 1