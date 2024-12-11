extends State

@export
var idle_state: State
@export
var walk_state: State

func process_input(event: InputEvent) -> State:
	if input_source.get_direction_vector().is_zero_approx():
		return idle_state
	if !input_source.is_run_intended():
		return walk_state
	return null
