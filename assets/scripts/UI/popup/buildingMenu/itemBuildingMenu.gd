extends Control

@onready var icon		:TextureRect	= $Button/HBoxContainer/TextureRect
@onready var caption	:Label			= $Button/HBoxContainer/Label
@onready var index		:int			= 1

var store 	= StoreBuilding.new()
@onready var build	= get_node("/root/World/UI/Pop-up Menu/BuildingMenu")

func _ready():
	set_data(index)

func set_data(index:int):
	self.index		= index
	caption.text	= store.content[index]["caption"]
	#icon.texture	= store.content[index]["icon"]

func _on_button_pressed():
	build.get_data(index)
