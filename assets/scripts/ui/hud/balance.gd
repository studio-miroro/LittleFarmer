extends Control
var money = data.money

func _ready():
	$Label.text = str(data.money)
	
func _process(delta):
	if money < 0:
		money = 0
		
	$Label.text = str(money)
