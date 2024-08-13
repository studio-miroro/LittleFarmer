extends Node2D

@onready var background:ColorRect = $MainUI/Background
@onready var blackout:Control = $MainUI/Blackout

func _ready():
	blackout.visible = true
	await get_tree().create_timer(1.25).timeout
	blackout.blackout(false, 4)
