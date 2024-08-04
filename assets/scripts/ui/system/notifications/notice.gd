extends Control

@onready var icon:TextureRect = $Main/Content/HBoxContainer/Icon/Icon
@onready var label:Label = $Main/Content/HBoxContainer/Label/Label
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var time:Timer = $Timer

var icons:Dictionary = {
	"info": load("res://assets/resources/ui/notifications/icons/info.png"),
	"error": load("res://assets/resources/ui/notifications/icons/error.png"),
}

func notice(icon, text):
	set_text(text)
	set_icon(icon)
	anim.play("create")

func set_text(text:String):
	visible = true
	label.text = text

func set_icon(image):
	if image != null:
		if typeof(image) == TYPE_STRING\
		and icons.has(image):
			icon.texture = icons[image]
		else:
			if typeof(image) == TYPE_OBJECT and icon.texture is CompressedTexture2D:
				icon.visible = true
				icon.texture = image
			else:
				icon.visible = false
				push_warning("")
	else:
		icon.visible = false

func _on_timer_timeout():
	anim.play("delete")

func delete():
	queue_free()
