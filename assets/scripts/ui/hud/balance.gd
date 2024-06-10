extends Control
var money = gamedata.money

func _ready():
	$Label.text = str(gamedata.money)
	
func _process(delta):
	if money < 0:
		money = 0
		
	$Label.text = str(money)
