extends Control

@onready var text:Label = $Label
@onready var player = Camera.new()
@onready var money:int = 0

func _ready():
	text.text = str(money)
	
func _process(delta):
	if money < 0:
		money = 0
	text.text = str(money)

func add_money(amount:int):
	self.money += amount
	if amount < 0:pass
