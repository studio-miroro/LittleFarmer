extends Control

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var inventory:Control = get_node("/root/World/User Interface/Windows/Inventory")
@onready var balance:Control = get_node("/root/World/User Interface/HUD/Money")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")
@onready var animation:AnimationPlayer = $AnimationPlayer

@onready var letter_node:PackedScene = load("res://assets/nodes/ui/windows/mail/letter.tscn")
@onready var item_node:PackedScene = load("res://assets/nodes/ui/inventory/slot.tscn")
@onready var letters_container:VBoxContainer = $Panel/HBoxContainer/LettersScroll/VBoxContainer
@onready var content_container:VBoxContainer = $Panel/HBoxContainer/ContentScroll/VBoxContainer
@onready var items_container:GridContainer = $Panel/HBoxContainer/ContentScroll/VBoxContainer/Items/VBoxContainer/HBoxContainer/Items/GridContainer
@onready var items:MarginContainer = $Panel/HBoxContainer/ContentScroll/VBoxContainer/Items

@onready var header:Label = $Panel/HBoxContainer/ContentScroll/VBoxContainer/LetterHeader/Title
@onready var description:Label = $Panel/HBoxContainer/ContentScroll/VBoxContainer/MainContent/Text
@onready var author:Label = $Panel/HBoxContainer/ContentScroll/VBoxContainer/Author/Author
@onready var fixedItems:Label = $Panel/HBoxContainer/ContentScroll/VBoxContainer/Items/VBoxContainer/LabelContainer/Label

@onready var button:Button = $Panel/HBoxContainer/ContentScroll/VBoxContainer/Items/VBoxContainer/ButtonContainer/GetItems

var item:Object = Items.new()
var menu:bool = false
 
var index:int
var letters:Dictionary = {}

func _process(delta):
	if Input.is_action_just_pressed("menu")\
	and !blur.blur:
		close()
	
	if Input.is_action_just_pressed("test"):
		letter(
			"Благодарность",
			"
			Уважаемый фермер, \n
			Хочу выразить Вам искреннюю благодарность за Ваш труд и заботу о нашей земле. 
			Благодаря Вам на нашем столе всегда свежие и качественные продукты. 
			Ваш вклад в развитие сельского хозяйства неоценим.
			",
			"С уважением, Коровьев",
			500,
			{
				1:{"amount":100},
				2:{"amount":100},
				3:{"amount":10},
				4:{"amount":10},
				5:{"amount":10},
				6:{"amount":10},
			}
		)

func _ready():
	check_window()
	reset_data()
	delete_letters(letters, letter_node, letters_container)

func letter(_header:String, _description:String, _author:String, _money:int, _items:Dictionary) -> void:
	if _header != ""\
	or _description != ""\
	or _author != "": 
		var index = letters.size() + 1
		letters[index] = {}
		letters[index]["header"] = _header
		letters[index]["description"] = _description
		letters[index]["author"] = _author
		letters[index]["money"] = _money
		letters[index]["items"] = {}
		if _items != {}:
			check_all_keys(index, _items)

func check_all_keys(id:int, dictionary:Dictionary) -> void:
	for key in dictionary.keys():
		if !dictionary[key].has("amount"):
			if !letters[id]["items"].has(key):
				letters[id]["items"][key] = {}
			letters[id]["items"][key]["amount"] = 1
		else:
			letters[id]["items"][key] = dictionary[key]

func get_data(_index:int) -> void:
	if letters.has(_index):
		self.index = _index
		letter_delete_items(items_container, item_node)
		
		if letters[_index].has("header"):
			if typeof(letters[_index]["header"]) == TYPE_STRING:
				header.text = letters[_index]["header"]
				header.visible = true
			else:
				push_error("The 'header' is not a string. Variant.type: " + str(typeof(letters[_index]["header"])))
		else:
			header.visible = false
			
		if letters[_index].has("description"):
			if typeof(letters[_index]["description"]) == TYPE_STRING:
				description.text = letters[_index]["description"]
				description.visible = true
			else:
				push_error("The 'description' is not a string. Variant.type: " + str(typeof(letters[_index]["description"])))
		else:
			description.visible = false
			
		if letters[_index].has("author"):
			if typeof(letters[_index]["author"]) == TYPE_STRING:
				author.text = "— " + letters[_index]["author"]
				author.visible = true
			else:
				push_error("The 'author' is not a string. Variant.type: " + str(typeof(letters[_index]["author"])))
		else:
			author.visible = false
			
		if letters[_index].has("items"):
			if letters[_index]["items"] != {}:
				items.visible = true
				
				if !letters[_index]["items"].has("collected"):
					button.visible = true
				else:
					button.visible = false
				
				if letters[_index].has("money"):
					if typeof(letters[_index]["money"]) == TYPE_INT:
						fixedItems.text = "Вложение: " + str(letters[_index]["money"]) + " монет"
					else:
						push_error("The 'money' is not a integer. Variant.type: " + str(typeof(letters[_index]["money"])))
						fixedItems.text = "Вложение: 0 монет"
				else:
					fixedItems.text = "Вложение: 0 монет"
					
				for i in letters[_index]["items"]:
					var item = letters[_index]["items"][i]
					if typeof(item) == TYPE_DICTIONARY and item.has("amount"):
						if typeof(item["amount"]) == TYPE_INT:
							if item["amount"] > 0:
								letter_create_items(i, item["amount"], items_container, item_node)
							else:
								item.erase(_index)
						else:
							item.erase(_index)
			else:
				items.visible = false
				
	else:
		push_error("Invalid index: " + str(_index))

func get_all_items(letter:int, dictionary:Dictionary) -> void:
	if letter_items_check(0, index, dictionary) != {}:
		if letter_items_check(2, index, dictionary):
			letter_items_check(1, index, dictionary)
			dictionary[index]["items"]["collected"] = true
			button.visible = false
			if dictionary[index].has("money"):
				balance.add_money(dictionary[index]["money"])
		
func letter_items_check(check:int, _index:int, dictionary:Dictionary):
	match check:
		0:
			for key in dictionary:
				return dictionary[key]["items"]
		1:
			for key in dictionary[_index]["items"].keys():
				if key in item.content:
					inventory.add_item(key, dictionary[_index]["items"][key]["amount"])
				else:
					return false
		2:
			for key in dictionary:
				if key in item.content:
					return true
				else:
					return false

func create_letters(dictionary:Dictionary, node:PackedScene, parent:VBoxContainer) -> void:
	for i in dictionary:
		var letter = node.instantiate()
		parent.add_child(letter)
		letter.set_data(i, dictionary[i]["header"])
		
func delete_letters(dictionary:Dictionary, node:PackedScene, parent:VBoxContainer) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()
			
func letter_create_items(id:int, amount:int, parent:GridContainer, node:PackedScene) -> void:
	if item.content.has(id):
		var letter = node.instantiate()
		parent.add_child(letter)
		letter.set_data(id, amount)
	else:
		push_error("Invalid item ID: " + str(id))
		
func letter_delete_items(parent:GridContainer, node:PackedScene) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

func reset_data() -> void:
	header.text = ""
	description.text = ""
	author.text = ""
	items.visible = false

func open() -> void:
	menu = true
	pause.lock = true
	blur.blur(true)
	animation.play("open")
	create_letters(letters, letter_node, letters_container)
	
func close() -> void:
	menu = false
	self.index = 0
	pause.lock = false
	blur.blur(false)
	animation.play("close")
	delete_letters(letters, letter_node, letters_container)

func check_window() -> void:
	visible = menu

func _on_get_items_pressed():
	if button.visible:
		get_all_items(index, letters)

func _on_close_pressed() -> void:
	if blur.bluring:
		close()
