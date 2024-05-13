extends Control
var money = game_variables.money

func _ready():
	$Label.text = str(game_variables.money)
	
func _process(delta):
	if money < 0:
		money = 0
		
	$Label.text = str(money)
