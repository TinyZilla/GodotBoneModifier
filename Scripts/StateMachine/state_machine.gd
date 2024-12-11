# Credits: https://github.com/theshaggydev/the-shaggy-dev-projects/blob/main/projects/godot-4/state-machines/src/state_machine/state_machine.gd
extends Node
class_name StateMachine

@export
var starting_state: State
@export
var character_body: CharacterBody3D
@export
var animation_controller: AnimationController
@export
var input_source: PlayerInputSource
var current_state: State

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init() -> void:
	for child in get_children():
		child.character_body = character_body
		child.animation_controller = animation_controller
		child.input_source = input_source

	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	print(current_state.name)
	
# Pass through functions for the Player to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	input_source.process_input_event(event)
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
