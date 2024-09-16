extends Control

@onready var icon:TextureRect = $Main/Content/HBoxContainer/MarginIcon/Icon
@onready var label:Label = $Main/Content/HBoxContainer/MarginLabel/Label
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var time:Timer = $Timer

var icons:Dictionary = {
	"info": load("res://assets/resources/ui/notifications/icons/info.png"),
	"error": load("res://assets/resources/ui/notifications/icons/error.png"),
}

func notice(text:String, image = "") -> void:
	set_text(text)
	set_icon(image)
	anim.play("create")

func set_text(text:String) -> void:
	visible = true
	label.text = text

func set_icon(image) -> void:
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

func _on_timer_timeout() -> void:
	anim.play("delete")

func notice_delete() -> void:
	queue_free()
