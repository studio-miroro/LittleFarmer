extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var options:Control = get_node("/root/" + main_scene + "/UI/Windows/Options")
@export var languages:Array[String] = [
	"ru", "en"
	]
var lang:int = 1

func _ready():
	change_language()

func change_language() -> void:
	lang = (lang + 1) % languages.size()
	TranslationServer.set_locale(languages[lang])

func _on_button_pressed() -> void:
	if options.menu:
		change_language()
