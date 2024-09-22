extends Node

var ingredients: Dictionary = {
	'test_ball': {
		'stock': 10
	},
	'blunt_ball': {
		'stock': 0
	},
	'pierce_ball': {
		'stock': 0
	},
	'slice_ball': {
		'stock': 0
	},
	'fire_ball': {
		'stock': 20
	},
	'water_ball': {
		'stock': 0
	},
	'shock_ball': {
		'stock': 0
	},
	'wind_ball': {
		'stock': 0
	},
	'heal_ball': {
		'stock': 0
	},
	'shield_ball': {
		'stock': 0
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
		'water_ball': 
			return ingredients.water_ball
		'shock_ball': 
			return ingredients.shock_ball
		'wind_ball': 
			return ingredients.wind_ball
		'heal_ball': 
			return ingredients.test_ball
		'shield_ball': 
			return ingredients.shield_ball
	#fallback
	return null
