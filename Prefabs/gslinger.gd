extends CharacterBody3D


@onready
var state_machine: StateMachine = $GslingerStateMachine


func _ready():
	state_machine.init()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
