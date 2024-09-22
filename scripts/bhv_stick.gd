extends RigidBody2D

var colliding_body_ref = null
var ingredient_slots: Array = [null, null, null]
#set to false if stick leaves prep area (avoids adding ingredient outside)
var prep_state = true

@onready var sprite_positions: Array = [
	$SpritePosition1,
	$SpritePosition2,
	$SpritePosition3
]

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("click"):
		if colliding_body_ref and prep_state:
			add_ingredient(colliding_body_ref)

func add_ingredient(ingredient) -> void:
	if ingredient_slots.has(null):
		var slot = get_available_slot()
		
		#add ingredient to sitck slots
		ingredient_slots[slot] = ingredient.fetch_ingredient_stats()
		
		#render ingredient sprite
		var sprite = Sprite2D.new()
		sprite.scale = Vector2(0.8, 0.8)
		
		#render appropriate texture based on cooked value
		if ingredient.cooked:
			sprite.texture = ingredient.get_anim_texture('cooked')
		else:
			sprite.texture = ingredient.get_anim_texture('raw')
		sprite.position = sprite_positions[slot].position
		
		add_child(sprite)
		ingredient.destroy()
		print_debug(ingredient_slots[slot])
	else:
		print_debug('no more slots on this stick!')

func get_available_slot() -> int:
	print_debug(ingredient_slots.find(null))
	return ingredient_slots.find(null)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group('ingredients'):
		colliding_body_ref = body

func _on_body_exited(body: Node) -> void:
	colliding_body_ref = null
