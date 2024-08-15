extends Node2D

@onready var background:ColorRect = $CanvasLayer/Background
@onready var blackout:Control = $CanvasLayer/Blackout

func _ready():
	blackout.visible = true
	await get_tree().create_timer(1.25).timeout
	blackout.blackout(false, 4)