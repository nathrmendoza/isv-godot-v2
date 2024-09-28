extends Node2D

@export var health: float = 140
@export var damage: int = 10
@export var action_speed: float = 20
@export var enemy_name: String = 'Protoclops'

@onready var action_timer = $ActionTimer
@onready var animated_sprite = $AnimatedSprite2D

@onready var ui_health_bar = $AnimatedSprite2D/Control/UiPlayerHealth
@onready var ui_name = $AnimatedSprite2D/Control/EnemyName
@onready var ui_timer = $AnimatedSprite2D/Control/UiActionTimer

var running_action = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_timer.wait_time = action_speed
	action_timer.one_shot = true
	action_timer.autostart = true
	
	ui_timer._init_action_timer(action_timer)	
	ui_health_bar.init_health(health)


func _on_action_timer_timeout() -> void:
	pass
	#do action, for now only idle and attacking
	#update animated sprite
