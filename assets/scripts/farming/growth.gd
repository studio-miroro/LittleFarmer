extends Sprite2D

@onready var plant = $".."
@onready var timer = $"../Timer"
var crops = Crops.new()
var level:int

func _ready():
	if crops.crops.has("atlas"):
		if typeof(crops.crops["atlas"]) == TYPE_OBJECT and texture is CompressedTexture2D:
			texture = texture
		else:
			push_error("Atlas is not a CompressedTexture2D.")
	else:
		push_error("No atlas of crops.")

func _process(_delta):
	if plant.plantID != 0:
		if level == crops.crops[plant.plantID]["growthLevel"]\
		and plant.condition != plant.phases.INCREASED:
			plant_increased()
	else:
		push_error("Invalid variable index: " + str(plant.plantID))
		remove_child(plant)
		queue_free()
		
func rect(id):
	if crops.crops[id].has("X")\
	and crops.crops[id].has("Y"):
		region_rect.position.x = crops.crops[id]['X']
		region_rect.position.y = crops.crops[id]['Y']
	else:
		push_error("The X and Y coordinates cannot be determined.")

func _on_timer_timeout() -> void:
	if level < crops.crops[plant.plantID]["growthLevel"]:
		region_rect.position.x += 16
		level += 1
	else:
		plant_increased()

func plant_increased():
	plant.condition = plant.phases.INCREASED
	timer.stop()
