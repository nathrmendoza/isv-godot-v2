extends RigidBody2D

#ingredient specific properties
@export_range(1, 15, 1) var cook_timer: int = 6

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_body: CollisionShape2D = $CollisionShape2D
@onready var shape_collider: CollisionShape2D = $Area2D/Shape

var is_dragging: bool = false
var cooked: bool = false
var draggable: bool = true

var drag_start: Vector2
var last_pointer_position: Vector2
var pointer_velocity: Vector2

var throw_force_mult: float = 15.0
var throw_max_velocity: float = 30.0

var offscreen_margin: float
var viewport_height: float

func _ready() -> void:
	#set collider to pickable
	input_pickable = true
	
	#set viewport bottom
	viewport_height = get_viewport_rect().size.y
	offscreen_margin = shape_collider.shape.size.y
	get_tree().root.size_changed.connect(_on_viewport_change)

#on change update viewport height value
func _on_viewport_change() -> void:
	viewport_height = get_viewport_rect().size.y

#handle press and release on collider
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and draggable:
			if check_pointer_within_shape(event.global_position):
				grabbing_object(event.global_position)

func grabbing_object(pointer_position: Vector2) -> void:
	if not is_dragging:
		is_dragging = true
		drag_start = pointer_position - global_position
		last_pointer_position = pointer_position
		freeze = true
	
#handle object physics updates
func _physics_process(delta: float) -> void:
	if is_dragging:
		var current_pointer_position = get_global_mouse_position()
		if Input.is_action_pressed('click'):
			# update the position of object
			global_position = current_pointer_position - drag_start
			pointer_velocity = (current_pointer_position - last_pointer_position) / delta
			pointer_velocity = pointer_velocity.limit_length(throw_max_velocity)
			last_pointer_position = current_pointer_position
		elif Input.is_action_just_released('click'):
			is_dragging = false
			freeze = false
			apply_central_impulse(pointer_velocity * throw_force_mult)
			
	#remove if below boundary
	if global_position.y > viewport_height + offscreen_margin:
		queue_free()

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

#stove cooking handler (triggered from stove)
func start_cooking(cooking_position: Vector2):
	if not cooked:
		draggable = false
		global_position = cooking_position
		set_deferred('freeze', true)
		hide()

func finish_cooking():
	show()
	cooked = true
	draggable = true
	animated_sprite.animation = 'cooked'
	freeze = false
	_tween_pop_off('right')

#getting texture from animation (single frame only)
func get_anim_texture(state: String) -> Texture2D:
	var sprite_frames = animated_sprite.get_sprite_frames()
	return sprite_frames.get_frame_texture(state, 0)

#tween
func _tween_pop_off(direction: String):
	#disable collider for 2 seconds (avoids bumping to each other)
	set_collision_mask_value(1, false)
	
	var rand_x = randi_range(75, 250)
	match direction:
		'straight':
			apply_central_impulse(Vector2(0, -500))
		'left':
			apply_central_impulse(Vector2(-rand_x, -500))
		'right':
			apply_central_impulse(Vector2(rand_x, -500))
	
	
	await get_tree().create_timer(0.75).timeout
	set_collision_mask_value(1, true)
