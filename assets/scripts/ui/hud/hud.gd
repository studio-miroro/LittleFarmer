extends Control

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var inventory:Control = get_node("/root/"+main+"/UI/Interactive/Inventory")
@onready var crafting:Control = get_node("/root/"+main+"/UI/Interactive/Crafting")
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var grid:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid")
@onready var anim:AnimationPlayer = $AnimationHud

var hud:bool	

func state(hud_state:bool, context:String) -> void:
	if hud_state:
		match context:
			"all":
				hud_all_hide()
			"tools":
				tools_hide()
			"balance":
				balance_hide()
			"clocks":
				clock_hide()
	else:
		match context:
			"all":
				hud_all_show()
			"tools":
				tools_show()
			"balance":
				balance_show()
			"clocks":
				clock_show()

func hud_all_hide() -> void:
	anim.play("hide_all")
	hud = false
	
func hud_all_show() -> void:
	anim.play("show_all")
	hud = true

func tools_hide() -> void:
	if !hud:
		pass

func tools_show() -> void:
	if !hud:
		pass

func balance_hide() -> void:
	if !hud:
		pass

func balance_show() -> void:
	if !hud:
		pass

func clock_hide() -> void:
	if !hud:
		pass

func clock_show() -> void:
	if !hud:
		pass

func window() -> void:
	visible = hud
