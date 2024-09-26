extends Node

var ingredients: Dictionary = {
	'test_ball': {
		'stock': 100
	},
	'blunt_ball': {
		'stock': 45
	},
	'pierce_ball': {
		'stock': 32
	},
	'slice_ball': {
		'stock': 35
	},
	'fire_ball': {
		'stock': 25
	},
	'ice_ball': {
		'stock': 25
	},
	'shock_ball': {
		'stock': 20
	},
	'wind_ball': {
		'stock': 24
	},
	'heal_ball': {
		'stock':8
	},
	'shield_ball': {
		'stock': 5
	}
}

func getStock(name) -> int:
	var _ingredient = _fetch_ingredient(name)
	if _ingredient:
		return _ingredient.stock
	#fallback
	return 0

func updateStock(name: String, num: int) -> void:
	var _ingredient = _fetch_ingredient(name)
	if _ingredient:
		_ingredient.stock = num

func _fetch_ingredient(name: String):
	match name:
		'test_ball': 
			return ingredients.test_ball
		'pierce_ball': 
			return ingredients.pierce_ball
		'blunt_ball': 
			return ingredients.blunt_ball
		'slice_ball': 
			return ingredients.slice_ball
		'fire_ball': 
			return ingredients.fire_ball
		'ice_ball': 
			return ingredients.ice_ball
		'shock_ball': 
			return ingredients.shock_ball
		'wind_ball': 
			return ingredients.wind_ball
		'heal_ball': 
			return ingredients.heal_ball
		'shield_ball': 
			return ingredients.shield_ball
	#fallback
	return null
