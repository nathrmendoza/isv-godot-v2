extends Node

const MAX_COOK = 6
var cooking_slots: Array
var cooking_sprites: Array
var cooking_tweens: Array

var colliding_body_ref = null

@onready var cooking_positions: Array = [
	$ParentMask/Position1,
	$ParentMask/Position2,
	$ParentMask/Position3,
	$ParentMask/Position4,
	$ParentMask/Position5,
	$ParentMask/Position6
]

#load child sprites under mask
@onready var sprite_parent: Sprite2D = $ParentMask
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooking_slots = [null, null, null, null, null, null]
	cooking_sprites = [null, null, null, null, null, null]
	cooking_tweens = [null, null, null, null, null, null]

func can_accept_ingredient() -> bool:
	return cooking_slots.count(null) > 0
	
func get_available_slot() -> int:
	return cooking_slots.find(null)
	
#stove start cooking
func start_cooking(ingredient):
	var slot = get_available_slot()
	if slot == -1: return false
	
	cooking_slots[slot] = ingredient
	ingredient.start_cooking(cooking_positions[slot].global_position)
	
	#change stove animation
	animated_sprite.animation = 'cooking'
	animated_sprite.play()
	
	#instantiate ingredient sprite
	var sprite = Sprite2D.new()
	sprite.texture = ingredient.get_anim_texture('raw')
	sprite.position = cooking_positions[slot].position
	
	#add the sprite as child to mask
	sprite_parent.add_child(sprite)
	cooking_sprites[slot] = sprite
	
	#add bouncing tween to sprite instantiated
	var tween = create_tween()
	tween.set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, 'position:y', sprite.position.y - 6, 0.25)
	tween.tween_property(sprite, 'position:y', sprite.position.y, 0.15)
	cooking_tweens[slot] = tween
	
	#create cooking timer signal that triggers finish method
	get_tree().create_timer(ingredient.cook_timer).timeout.connect(
		finish_cooking.bind(slot)
	)

#stove finished cooking
func finish_cooking(slot: int):
	animated_sprite.animation = 'default'
	var ingredient = cooking_slots[slot]
	
	#clear slots
	if ingredient:
		ingredient.finish_cooking()
		cooking_slots[slot] = null
		cooking_sprites[slot].queue_free()
		cooking_sprites[slot] = null
		cooking_tweens[slot].kill()
		cooking_tweens[slot] = null

#check for colliding bodies, start cooking method if has group ingredients
func _on_area_2d_body_entered(colliding_body: Node2D) -> void:
	if colliding_body.is_in_group('ingredients') and colliding_body.cooked != true:
		colliding_body_ref = colliding_body

func _on_area_2d_body_exited(colliding_body: Node2D) -> void:
	if colliding_body_ref == colliding_body:
		colliding_body_ref = null

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false and colliding_body_ref:
			start_cooking(colliding_body_ref)
