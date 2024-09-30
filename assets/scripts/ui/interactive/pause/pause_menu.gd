extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var ui:CanvasLayer = get_node("/root/" + main_scene + "/UI")
@onready var hud:Control = get_node("/root/" + main_scene + "/UI/HUD/GameHud")
@onready var options:Control = get_node("/root/" + main_scene + "/UI/Interactive/Options")
@onready var blackout:Control = get_node("/root/" + main_scene + "/UI/Decorative/Blackout")
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/Decorative/Blur")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/ConstructionManager/Grid")
@onready var zoom:Camera2D = get_node("/root/" + main_scene + "/Player/Camera2D")
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Player")
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var version:Label = $MarginContainer/MarginContainer/container/version/version

var paused:bool
var other_menu:bool
var lock:bool = true

func _ready():
	player.switch = true
	player.check_switch()
	await get_tree().create_timer(0.75).timeout
	player.switch = true
	zoom.zooming = false
	zoom.change_zoom = true
	blackout.blackout(false)
	await get_tree().create_timer(0.25).timeout
	hud.hud_show()
	player.switch = false
	player.check_switch()
	lock = false

func _process(_delta):
	if Input.is_action_just_pressed("pause")\
	and !other_menu\
	and !other_menu\
	and !options.visible:
		pause()

func pause():
	if !paused\
	and !other_menu:
		open()
	else:
		close()
	
func open() -> void:
	paused = true
	anim.play("open")
	blur.blur(true)
	hud.hud_hide()
	player.check_switch()
	version.text = "v"+str(ProjectSettings.get_setting("application/config/version"))

	if has_node("/root/" + main_scene + "/ConstructionManager/Grid"):
		grid.visible = false

func close() -> void:
	paused = false
	anim.play("close")
	blur.blur(false)
	hud.hud_show()
	player.check_switch()

func _check_window() -> void:
	visible = paused