extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print_debug('body entered', body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	print_debug('body exited', body)
