extends Node2D

var colliding_body_ref = null
var action_queue = [null, null, null]

@onready var action_timer: Timer = $PlayerActionTimer

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
		if colliding_body_ref:
			action_queue = colliding_body_ref.fetch_action_queues()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('servable'):
		colliding_body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_body_ref = null
