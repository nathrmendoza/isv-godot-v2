extends RigidBody2D

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

@onready var collision_body: CollisionShape2D = $CollisionShape2D

const TWEEN_SPEED = 0.45
var last_position: Vector2 = Vector2.ZERO

var drag_start: Vector2
var is_dragging: bool = false
var is_inside_droppable: bool = false

func _ready() -> void:
	freeze = true
	last_position = global_position


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#dragging
			if not prep_state:
				if check_pointer_within_shape(event.global_position):
					is_dragging = true
					drag_start = event.global_position - global_position
					get_tree().call_group('trash', 'tween_show')
		else:
			#ingredient drop
			if prep_state and mouse_inside and colliding_body_ref:
				add_ingredient(colliding_body_ref)

func _physics_process(delta: float) -> void:
	if is_dragging:
		var current_pointer_position = get_global_mouse_position()
		if Input.is_action_pressed('click'):
			if not prep_state:
				global_position = current_pointer_position
		elif Input.is_action_just_released('click'):
			if not prep_state:
				is_dragging = false
				tween_go_to_position(last_position)
				get_tree().call_group('trash', 'tween_hide')


#tweens
func tween_go_to_position(mv_position: Vector2) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'global_position', mv_position, TWEEN_SPEED)


#check if mouse/touch is within collision_body shape
func check_pointer_within_shape(point: Vector2) -> bool:
	if collision_body.shape:
		var local_point = to_local(point)
		if collision_body.shape is RectangleShape2D:
			var half_extents = collision_body.shape.size / 2
			return abs(local_point.x) <= half_extents.x and abs(local_point.y) <= half_extents.y
		elif collision_body.shape is CircleShape2D:
			return local_point.length() <= collision_body.shape.radius
		elif collision_body.shape is CapsuleShape2D:
			var half_height = collision_body.shape.height / 2 - collision_body.shape.radius
			#horizontal
			if abs(local_point.y) <= half_height:
				return abs(local_point.y) <= collision_body.shape.radius
			else:
				#vertical
				var circle_center = Vector2(0, sign(local_point.y) * half_height)
				return abs(local_point - circle_center).length() <= collision_body.shape.radius
	#fallback
	return false


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

func fetch_action_queues() -> void:
	pass
	#return an array(3) of dictionaries that have action_type

func _on_body_entered(body: Node) -> void:
	if body.is_in_group('ingredients'):
		colliding_body_ref = body


func _on_body_exited(body: Node) -> void:
	colliding_body_ref = null


func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false
