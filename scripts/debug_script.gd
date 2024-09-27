extends Node2D

var health = 100
var armor = 3

@onready var ui_player_healthbar = $CanvasLayer/Control/UiPlayerHealth
@onready var ui_player_armor = $CanvasLayer/Control/UiPlayerArmor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_player_healthbar.init_health(health)
	ui_player_armor.init_armor(armor)

func _debug_reduce_health() -> void:
	if armor <= 0:
		health -= 10
		ui_player_healthbar.health = health
	else:
		armor -= 1
		ui_player_armor.armor = armor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_key"):
		_debug_reduce_health()
