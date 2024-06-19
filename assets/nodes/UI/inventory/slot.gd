extends Panel

@onready var itemSprite:Sprite2D = $CenterContainer/Panel/Sprite2D

func update(item):
	if !item:
		itemSprite.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = item.texture
