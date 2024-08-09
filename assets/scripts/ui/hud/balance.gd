extends Control

@onready var text:Label = $Label
@onready var player = get_node("/root/World/Camera")
@onready var money:int = 0
	
func _process(delta):
	if money < 0:
		money = 0
	text.text = str(money)

func set_money(amount:int) -> void:
	self.money = amount

func add_money(amount:int) -> void:
	if amount > 0:
		self.money += amount

func remove_money(amount:int) -> void:
	if amount > 0:
		self.money -= amount
