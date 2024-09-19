extends Node2D

@export var spawn_object: PackedScene

func _on_button_pressed() -> void:
	var test_object = spawn_object.instantiate()
	test_object.global_position = Vector2(240, 100)
	add_child(test_object)
