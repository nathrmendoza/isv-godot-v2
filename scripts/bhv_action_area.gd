extends Node2D

var colliding_body_ref = null
var action_queue = [null, null, null]

@onready var action_timer: Timer = $PlayerActionTimer
@onready var ui_player_action_timer = $UiActionTimer
@onready var ui_player_description = $PlayerActionDescription
var ui_player_description_load_check = false

var player_can_act = false

func _ready() -> void:
	ui_player_action_timer._init_action_timer(action_timer)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
		if colliding_body_ref and player_can_act:
			#action_queue = colliding_body_ref.fetch_action_queues()
			colliding_body_ref.queue_free()

			#reset action timer
			player_can_act = false
			action_timer.start(action_timer.wait_time)
			tween_description_hide()
			
		elif colliding_body_ref and player_can_act == false:
			tween_action_not_ready()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('servable'):
		colliding_body_ref = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_body_ref = null


func _on_player_action_timer_timeout() -> void:
	player_can_act = true
	tween_action_ready()

func tween_action_ready() -> void:
	ui_player_description.text = 'READY TO SERVE!'
	
	#ui_player_description.modulate.a = 0
	#ui_player_description.position.x = -110
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(ui_player_description, 'position:x', -90, 0.6)
	tween.parallel().tween_property(ui_player_description, 'modulate:a', 1, 1)

func tween_action_not_ready() -> void:
	if not ui_player_description_load_check:
		ui_player_description_load_check = true
		ui_player_description.text = 'NOT YET READY!'
		
		ui_player_description.modulate.a = 0
		ui_player_description.position.x = -110
		
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(ui_player_description, 'position:x', -90, 0.6)
		tween.parallel().tween_property(ui_player_description, 'modulate:a', 1, 1)
		
		await get_tree().create_timer(2).timeout
		ui_player_description_load_check = false

		if not player_can_act:
			tween_description_hide()
	

func tween_description_hide() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(ui_player_description, 'position:x', -70, 0.6)
	tween.parallel().tween_property(ui_player_description, 'modulate:a', 0, 0.6)
	await tween.finished
	
	ui_player_description.position.x = -110
	ui_player_description.modulate.a = 0
