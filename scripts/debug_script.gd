extends Node2D

@onready var player_healthbar = $CanvasLayer/Control/UiPlayerHealth

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_healthbar.init_health(100)

func _debug_reduce_health() -> void:
	player_healthbar.health = player_healthbar.health - 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_key"):
		_debug_reduce_health()
