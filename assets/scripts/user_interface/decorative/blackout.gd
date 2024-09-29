extends Control

@onready var background:ColorRect = $ColorRect
@onready var anim:AnimationPlayer = $Animation

func _ready():
	z_index = 999
	background.modulate = "ffffff"

func blackout(state:bool, speed:int = 4) -> void:
	match state:
		true:
			anim.play("blackout")
			anim.speed_scale = speed
		false:
			anim.play("blackout_reset")
			anim.speed_scale = speed

func change_color(colouring:Color, default_clear_color:bool = false):
	if typeof(colouring) == TYPE_COLOR:
		background.color = colouring
		if default_clear_color:
			RenderingServer.set_default_clear_color(colouring)
	else:
		push_error("The variable 'coloring' is not a type of 'Color'.")

func change_scene(path:String) -> void:
	if path != "":
		await get_tree().create_timer(1.25).timeout
		var result = get_tree().change_scene_to_file(path)
		
		if result == OK:
			pass
		else:
			match result:
				ERR_CANT_OPEN:
					push_warning("Can't open the scene file.")
				ERR_FILE_NOT_FOUND:
					push_warning("Scene file not found.")
				ERR_INVALID_DATA:
					push_warning("Invalid scene file format.")
				ERR_FILE_CORRUPT:
					push_warning("Scene file is corrupt.")
				ERR_UNAVAILABLE:
					push_warning("The scene is unavailable.")
				_:
					push_warning("An unknown error occurred: ", result)
