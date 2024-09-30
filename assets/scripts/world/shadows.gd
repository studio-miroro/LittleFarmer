extends Node

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var tilemap:TileMap = get_node("/root/"+main+"/Tilemap")
@onready var collision:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid/GridCollision")
@onready var canvas:CanvasGroup = $CanvasGroup

func create_shadow(shadow_name:String, shadow_texture:CompressedTexture2D, shadow_position:Vector2i) -> void:
    if shadow_name == "":
        shadow_name = "shadow"
    var shadow:Sprite2D = Sprite2D.new()
    shadow.name = shadow_name
    shadow.texture = shadow_texture
    shadow.position = tilemap.map_to_local(shadow_position)
    shadow.z_index = collision.shadow_layer
    canvas.add_child(shadow)