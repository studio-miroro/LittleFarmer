extends Control

@onready var options:Control = get_node("/root/World/User Interface/Windows/Options")
@export var languages:Array[String] = [
	"ru", "en"
	]
var next_lang:int = 1

func _ready():
	change_language()

func change_language() -> void:
	next_lang = (next_lang + 1) % languages.size()
	TranslationServer.set_locale(languages[next_lang])

func _on_button_pressed() -> void:
	if options.menu:
		change_language()
