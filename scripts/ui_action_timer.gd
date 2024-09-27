extends TextureProgressBar

var action_timer: Timer = null

func _init_action_timer(timer: Timer) -> void:
	action_timer = timer
	max_value = action_timer.wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if action_timer:
		value = action_timer.time_left
