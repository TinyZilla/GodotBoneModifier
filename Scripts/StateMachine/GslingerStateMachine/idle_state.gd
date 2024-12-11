extends State

@export
var walk_state: State
@export
var run_state: State

func process_input(event: InputEvent) -> State:
	if !input_source.get_direction_vector().is_zero_approx():
		if input_source.is_run_intended():
			return run_state
		return walk_state
	return null