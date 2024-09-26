extends Node2D

var colliding_body_ref = null
var action_queue = [null, null, null]

@onready var action_timer: Timer = $PlayerActionTimer
@onready var player_time_text: Label = $PlayerTimerText
var player_can_act = false

func _physics_process(delta: float) -> void:
	player_time_text.text = 'PLAYER TIMER: ' + str(roundf(action_timer.time_left))

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
		if colliding_body_ref and player_can_act:
			#action_queue = colliding_body_ref.fetch_action_queues()
			colliding_body_ref.queue_free()

			#reset action timer
			player_can_act = false
			action_timer.start(action_timer.wait_time)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('servable'):
		colliding_body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_body_ref = null


func _on_player_action_timer_timeout() -> void:
	player_can_act = true
