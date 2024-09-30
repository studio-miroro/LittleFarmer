extends Button

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var data:Node2D = get_node("/root/"+main)
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var blackout:Control = get_node("/root/"+main+"/UI/Decorative/Blackout")

@onready var path:String = "res://levels/main.tscn"

func _on_pressed() -> void:
	if blur.state:
		if pause.paused:
			blackout.blackout(true)
			if main == "Farm":
				data.gamesave()

			blackout.change_scene(path)
