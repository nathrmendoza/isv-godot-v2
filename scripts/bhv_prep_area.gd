extends Node

var colliding_body_ref = null
var has_stick = false
var stick_obj = null
var mouse_inside = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == false and colliding_body_ref:
			#check if ref is ingredient or stick
			if mouse_inside and colliding_body_ref.is_in_group('ingredients'):
				#add ingredient to slot, if no stick yet instantiate first
				if not has_stick:
					has_stick = true
					stick_obj = preload("res://scenes/obj_stick.tscn").instantiate()
					add_child(stick_obj)
					stick_obj.add_ingredient(colliding_body_ref)
			elif mouse_inside and colliding_body_ref.is_in_group('serveable'):
				#just switch position with stick here
				pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('ingredients') or body.is_in_group('servable'):
		colliding_body_ref = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_body_ref = null


func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
