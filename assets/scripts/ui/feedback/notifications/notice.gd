extends Control

@onready var icon:TextureRect = $Main/Content/HBoxContainer/MarginIcon/Icon
@onready var label:Label = $Main/Content/HBoxContainer/MarginLabel/Label
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var time:Timer = $Timer

var icons:Dictionary = {
	"info": load("res://assets/resources/ui/notifications/icons/info.png"),
	"error": load("res://assets/resources/ui/notifications/icons/error.png"),
}

func notice(text:String, type = "") -> void:
	set_text(text)
	set_icon(type)
	anim.play("create")

func set_text(text:String) -> void:
	visible = true
	label.text = text

func set_icon(type) -> void:
	if type != null:
		if typeof(type) == TYPE_STRING\
		and icons.has(type):
			icon.texture = icons[type]
		else:
			if typeof(type) == TYPE_OBJECT and icon.texture is CompressedTexture2D:
				icon.visible = true
				icon.texture = type
			else:
				icon.visible = false
				push_warning("")
	else:
		icon.visible = false

func _on_timer_timeout() -> void:
	anim.play("delete")

func notice_delete() -> void:
	queue_free()
