extends Node2D

@export var spawn_object: PackedScene
@onready var spawn_location: Marker2D = $SpawnLocation

func _on_button_pressed() -> void:
	var test_object = spawn_object.instantiate()
	test_object.global_position = spawn_location.global_position
	add_child(test_object)
