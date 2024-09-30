extends Control

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var inventory:Control = get_node("/root/"+main+"/UI/Interactive/Inventory")
@onready var crafting:Control = get_node("/root/"+main+"/UI/Interactive/Crafting")
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var grid:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid")
@onready var anim:AnimationPlayer = $Animation

var hud:bool

func hud_hide():
	anim.play("hide")
	hud = false
	
func hud_show():
	anim.play("show")
	hud = true

func state(hud_state:bool):
	match hud_state:
		true:
			hud_hide()
		false:
			hud_show()

func window():
	visible = hud
