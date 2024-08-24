extends Control

@onready var anim:AnimationPlayer = $Animation

func _ready():
	z_index = 999

func blackout(state:bool, speed:int = 4, path:String = ""):
	match state:
		true:
			anim.play("Blackout")
			anim.speed_scale = speed

			if path != "":
				await get_tree().create_timer(1.25).timeout
				var result = get_tree().change_scene_to_file(path)

				if result == OK:
					pass
				else:
					match result:
						ERR_CANT_OPEN:
							push_warning("Error: Can't open the scene file.")

						ERR_FILE_NOT_FOUND:
							push_warning("Error: Scene file not found.")

						ERR_INVALID_DATA:
							push_warning("Error: Invalid scene file format.")

						ERR_FILE_CORRUPT:
							push_warning("Error: Scene file is corrupt.")

						ERR_UNAVAILABLE:
							push_warning("Error: The scene is unavailable.")

						_:
							push_warning("An unknown error occurred: ", result)
		false:
			anim.play("Blackout_reset")
			anim.speed_scale = speed
