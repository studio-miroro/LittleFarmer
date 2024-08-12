extends Control

@onready var icon:TextureRect = $Margin/HBoxContainer/Icon/TextureRect
@onready var text:Label = $Margin/HBoxContainer2/Label/Label

const max:int = 999999999
const min:int = 0
var balance:int = 0
	
func _ready():
	set_money(randi_range(1000, 100000000))

func balance_update() -> void:
	check_balance(balance)
	text.text = format(balance)

func set_money(amount:int = 0) -> void:
	self.balance = amount
	balance_update()

func add_money(amount:int = 0) -> void:
	if amount > 0 and amount <= max:
		self.balance += amount
		balance_update()

func remove_money(amount:int = 0) -> void:
	if amount > 0 and amount <= max:
		self.balance -= amount
		balance_update()

func purchase(price:int) -> bool:
	if balance >= price:
		remove_money(price)
		balance_update()
		return true
	return false

func check_balance(balance) -> void:
	if balance < min:
		self.balance = min
		balance_update()
	if balance > max:
		self.balance = max
		balance_update()

func format(number:int) -> String:
	if number > min:
		if number <= max:
			var num_str = str(number)
			var separator = ","
			var result = ""
			var count = 0
			
			for i in range(num_str.length() - 1, -1, -1):
				result = num_str[i] + result
				count += 1
				if count % 3 == 0 and i != 0:
					result = separator + result
					
			return result
		else:
			return "999,999,999"
	else:
		return "0"
