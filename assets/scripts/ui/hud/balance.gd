extends Control

@onready var player = Camera.new()
@onready var money = player.money

func _ready():
	$Label.text = str(player.money)
	
func _process(delta):
	if money < 0:
		money = 0
	$Label.text = str(money)
