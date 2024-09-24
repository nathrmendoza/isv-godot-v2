extends Node2D

var colliding_body_ref = null
var ingredient_slots: Array = [null, null, null]
#set to false if stick leaves prep area (avoids adding ingredient outside)
var prep_state = true
var mouse_inside = false

@onready var sprite_positions: Array = [
	$SpritePosition1,
	$SpritePosition2,
	$SpritePosition3
]

@onready var collision_body: CollisionShape2D = $Area2D/CollisionShape2D
var last_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	last_position = global_position


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#dragging logic
			if mouse_inside and not prep_state:
				print_debug('grab')
		else:
			#release ingredient
			if prep_state and mouse_inside and colliding_body_ref:
				add_ingredient(colliding_body_ref)


func add_ingredient(ingredient) -> void:
	if ingredient_slots.has(null):
		var slot = get_available_slot()
		
		#add ingredient to sitck slots
		ingredient_slots[slot] = ingredient.fetch_ingredient_stats()
		if not ingredient_slots.has(null):
			prep_state = false
		
		#render ingredient sprite
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(0.8, 0.8)
		
		#render appropriate texture based on cooked value
		if ingredient.cooked:
			sprite.texture = ingredient.get_anim_texture('cooked')
		else:
			sprite.texture = ingredient.get_anim_texture('raw')
		sprite.position = sprite_positions[slot].position
		
		#clear colliding body ref
		colliding_body_ref = null
		
		add_child(sprite)
		ingredient.destroy()
	else:
		print_debug('no more slots on this stick!')

func get_available_slot() -> int:
	return ingredient_slots.find(null)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('ingredients') or body.is_in_group('prep_area') or body.is_in_group('serve_area') or body.is_in_group('trash_area'):
		colliding_body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_body_ref = null


func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
