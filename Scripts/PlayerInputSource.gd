extends Node
class_name PlayerInputSource

var direction_vector: Vector2 = Vector2.ZERO
var wants_run: bool = false

func process_input_event(event: InputEvent) -> void:
	if event.is_action("run"):
		wants_run = event.is_pressed()
	direction_vector = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")

func get_direction_vector() -> Vector2:
	return direction_vector

func is_run_intended() -> bool:
	return wants_run
