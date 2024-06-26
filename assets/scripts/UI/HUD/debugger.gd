extends Control

func _ready():
	$".".z_index = 998
	$VBoxContainer/Name.text = ProjectSettings.get_setting("application/config/name") + " v" + ProjectSettings.get_setting("application/config/version")

func _process(delta):
	var fps:float = Engine.get_frames_per_second()
	$VBoxContainer/FPS.text = "FPS: "+str(fps)
