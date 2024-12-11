extends State

@export
var idle_state: State
@export
var run_state: State

func process_input(event: InputEvent) -> State:
	if input_source.get_direction_vector().is_zero_approx():
		return idle_state
	elif input_source.is_run_intended():
		return run_state
	return null
