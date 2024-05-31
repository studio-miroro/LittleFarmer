extends Sprite2D

@onready var timer:Timer = $"../Timer"

var level:int
var plantID:int
var status:bool

func _ready():
	if crops.crops.has("atlas"):
		var texture = crops.crops["atlas"]
		if typeof(texture) == TYPE_OBJECT and texture is CompressedTexture2D:
			$".".texture = texture
		else:
			push_error("Atlas is not a CompressedTexture2D.")
	else:
		push_error("No atlas of crops.")

func rect(id):
	if crops.crops[id].has("rect_x")\
	and crops.crops[id].has("rect_y"):
		region_rect.position.x = crops.crops[id]['rect_x']
		region_rect.position.y = crops.crops[id]['rect_y']
	else:
		push_error("The X and Y coordinates cannot be determined.")

func _on_timer_timeout():
	if level < crops.crops[plantID]["growth_level"]:
		region_rect.position.x += 16
		level += 1
	else:
		timer.stop()
