extends Sprite2D

var frames = texture.get_width() / region_rect.size.x

func growth(ID):
	region_rect.position.x = region_rect.position.x + 16
	region_rect.position.y = ID
