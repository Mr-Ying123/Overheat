extends Node

var player
var camera 

var order = [] setget order_set 
var players_ingredients = [] setget players_ingredients_set

var Orders_left = 6
var temp = 0

var speedrun_time = 0.0
var best_speedrun_time = 0.0
var time_passed = ""

var ingredients = ["res://Chease.png","res://Bread.png","res://CookedFish.png","res://Egg.png"]
func generate_order(amount : int):
	randomize()
	var tempvar = ingredients.duplicate()
	order.clear()
	order_set([])
	for _index in range(amount):
		var using = ingredients[randi() % ingredients.size()]
		order_set(using)
		ingredients.erase(using)
	ingredients = tempvar

signal players_ingredients_set
func players_ingredients_set(set):
	if set is Array:
		players_ingredients = set
	else:
		players_ingredients.push_back(set)
	emit_signal("players_ingredients_set")

signal order_set
func order_set(set):
	if set is Array:
		order = set
	else:
		order.push_back(set)
	emit_signal("order_set")

func _ready():
	yield(get_tree(),"idle_frame")
	generate_order(1)

func deliver():
	var tempvar = players_ingredients.duplicate()
	var tempvar2 = order.duplicate()
	for ingredient in players_ingredients.duplicate():
		if order.find(ingredient) != -1:
			order.erase(ingredient)
			for _X in range(players_ingredients.count(ingredient)):
				players_ingredients.erase(ingredient)
	if order.size() == 0:
		Orders_left -= 1
		players_ingredients_set(players_ingredients)
		generate_order(2)
	else:
		players_ingredients_set(tempvar)
		order_set(tempvar2)

func reset_game_state():

	order = []
	players_ingredients = []

	Orders_left = 6
	temp = 0

	speedrun_time = 0.0
	best_speedrun_time = 0.0

	generate_order(1)
