extends ProgressBar

@onready var catchup_timer: Timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar

var health = 0 : set = set_health

func set_health(_new_health):
	var prev_health = health
	health = min(max_value, _new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		catchup_timer.start()
	else:
		damage_bar.value = health

func init_health(_health):
	health = _health

	max_value = _health
	value = _health
	
	damage_bar.max_value = _health
	damage_bar.value = _health


func _on_timer_timeout() -> void:
	damage_bar.value = health
