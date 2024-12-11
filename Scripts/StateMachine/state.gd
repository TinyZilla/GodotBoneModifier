class_name State
extends Node

@export
var animation: Animation

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var character_body: CharacterBody3D
var animation_controller: AnimationController
var input_source: PlayerInputSource

func enter() -> void:
	animation_controller.transition_to_animation(animation, 0.2)

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
