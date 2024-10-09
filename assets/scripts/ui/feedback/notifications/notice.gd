extends Control

@onready var main = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/"+main)
@onready var icon:TextureRect = $Main/Content/HBoxContainer/MarginIcon/Icon
@onready var label:Label = $Main/Content/HBoxContainer/MarginLabel/Label
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var time:Timer = $Timer

func notice(text:String, type = "") -> void:
	set_text(text)
	set_icon(type)
	anim.play("create")

func set_text(text:String) -> void:
	visible = true
	label.text = text

func set_icon(type) -> void:
	if type is CompressedTexture2D:
		icon.texture = type

func _on_timer_timeout() -> void:
	anim.play("delete")

func notice_delete() -> void:
	queue_free()
