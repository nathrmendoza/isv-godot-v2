extends Node

var area_1_colliding_body = null
var area_2_colliding_body = null
var area_3_colliding_body = null

#array of ingredient dictionaries
var area_1_slots: Array = [null, null, null]
var area_2_slots: Array = [null, null, null]
var area_3_slots: Array = [null, null, null]

#signals:
#mouse signals: dictates which prep area is being hovered, this avoids having multiple
#prep areas triggering body collisions, mouse signals serves as checkers
#body signals: detects body collisions from ingredients and set them to the variable which
#will later be used if the mouse releases within the collider
func _on_area_1_mouse_entered() -> void:
	print_debug('mouse entered')

func _on_area_1_mouse_exited() -> void:
	print_debug('mouse exited')

func _on_area_1_body_entered(body: Node2D) -> void:
	print_debug('body entered')

func _on_area_1_body_exited(body: Node2D) -> void:
	print_debug('body exited')
