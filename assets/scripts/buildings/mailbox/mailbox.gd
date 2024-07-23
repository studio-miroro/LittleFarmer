extends Node2D

@onready var pause:Control = get_node("/root/World/UI/Pause")
@onready var tip:Control = get_node("/root/World/UI/HUD/Tooltip")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid")
@onready var blur:Control = get_node("/root/World/UI/Blur")
@onready var player:CharacterBody2D = get_node("/root/World/MainCamera")
@onready var mailbox:Control = get_node("/root/World/UI/Pop-up Menu/Mailbox")
@onready var sprite:Sprite2D = $Sprite2D

var max_distance:int = 250
var _mailbox:bool
var object:Dictionary = {
	"caption" = "Почтовый ящик",
	"description" = "Хранит письма от ваших соседей.",
	"default" = preload("res://assets/resources/buildings/mailbox/object_0.png"),
	"hover" = preload("res://assets/resources/buildings/mailbox/object_1.png"),
}

func _ready():
	if object.has("default"):
		if typeof(object["default"]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object["default"]
		else:
			push_error("The specified sprite cannot be installed.")
	else:
		push_error("The specified key is missing.")

func _process(delta):
	if Input.is_action_just_pressed("click left")\
	and _mailbox:
		mailbox.open()

func change_sprite(type:bool) -> void:
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.gridmode.NOTHING and distance < max_distance:
			check_sprite("hover")
			if object.has("caption")\
			and object.has("description"):
				tip.tooltip(
					object["caption"]+"\n"
					+object["description"]
				)
				_mailbox = true
			else:
				push_error("Check the 'caption', 'description' elements.")
	else:
		check_sprite("default")
		tip.tooltip("")
		_mailbox = false
	
func check_sprite(key:String) -> void:
	if object.has(key):
		if typeof(object[key]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
			sprite.texture = object[key]
		else:
			push_error("The specified sprite cannot be installed.")
	else:
		push_error("The specified key is missing.")

func _on_area_2d_mouse_entered() -> void:
	if !blur.bluring:
		change_sprite(true)

func _on_area_2d_mouse_exited() -> void:
	change_sprite(false)
