extends Node2D

var colliding_body_ref = null

@onready var size_y: float = $Area2D/CollisionShape2D.shape.size.y

const tween_duration: float = 0.6
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite.position.y = size_y
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false and colliding_body_ref:
			colliding_body_ref.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('servable'):
		colliding_body_ref = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_body_ref = null

func tween_show() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, 'position:y', 0, tween_duration)

func tween_hide() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, 'position:y', size_y, tween_duration)
