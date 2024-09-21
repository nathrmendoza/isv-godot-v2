extends Node2D

@export var ingredient: Ingredient
@export_enum('straight', 'left', 'right') var pop_direction = 'straight'
var stock: int = 0

@onready var stockText: Label = $Control/StockLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if ingredient != null:
		stock = PlayerData.getStock(ingredient.ingredient_id)
		update_stock(stock)

func update_stock(num) -> void:
	stock = num
	stockText.text = str(num)

#run this when scene is done
func update_player_data() -> void:
	PlayerData.updateStock(ingredient.ingredient_id, stock)

#click container, instantiate ingredient
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if ingredient and stock > 0:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				update_stock(stock - 1)
				var _ingredient = ingredient.ingredient_scene.instantiate()
				_ingredient.position = Vector2(0, 0)
				#UPDATE THIS TO MAIN SCENE
				add_child(_ingredient)
				_ingredient._tween_pop_off(pop_direction)
				
				#test parent node
				print_debug(_ingredient.get_parent())
