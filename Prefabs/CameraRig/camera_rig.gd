extends Node3D

@onready var y_offset = $Y_Offset
@onready var z_offset = $Y_Offset/Camera3D
#@onready var tween: Tween = Tween.new()

# Stores mouse input for rotating the camera in the process
var mouseInput : Vector2 = Vector2(0,0)

## How far the player turns when the mouse is moved.
@export var mouse_sensitivity : float = 0.1
## Invert the Y input for mouse and joystick
@export var invert_mouse_y : bool = false # Possibly add an invert mouse X in the future
@export var follow_target: NodePath
@export var distance_from_pivoit: float = 3.5
@export var height_offset: float = 1.5
@export var scroll_speed: float = 0.2

var target_node: Node3D
var target_z_distance: float

func _ready() -> void:
	#It is safe to comment this line if your game doesn't start with the mouse captured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	target_z_distance = distance_from_pivoit
	z_offset.position.z = distance_from_pivoit
	y_offset.position.y = height_offset
	
	if !follow_target.is_empty():
		target_node = get_node(follow_target)


func _unhandled_input(event : InputEvent):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouseInput.x += event.relative.x
		mouseInput.y += event.relative.y
	if event is InputEventMouseButton and event.pressed and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		target_z_distance += scroll_speed if event.button_index == MOUSE_BUTTON_WHEEL_DOWN else -scroll_speed
		target_z_distance = clamp(target_z_distance, 0.2, 10.0)
	if event.is_action_pressed("ui_cancel"):
		#if Input.mouse_mode 
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED 

func _process(delta: float) -> void:
	handle_rotation()
	handle_follow_target(delta)
	handle_camera_zoom_smoothing(delta)

func handle_follow_target(delta: float) -> void:
	if follow_target.is_empty():
		return
	
	position = damp(transform.origin, target_node.transform.origin, 3.0,  delta)

func handle_camera_zoom_smoothing(delta) -> void:
	z_offset.position.z = damp(z_offset.position.z, target_z_distance, 3, delta)

# Frame Rate independent Dampening.
# How do i understand Lambda? Smoothing factor -- Arbatrary... i guess.// https://www.rorydriscoll.com/2016/03/07/frame-rate-independent-damping-using-lerp/
func damp(a: Variant, b: Variant, lambda: float, delta: float):
	return lerp(a, b, 1 - exp(-lambda * delta))

func handle_rotation() -> void:
	y_offset.rotation_degrees.y -= mouseInput.x * mouse_sensitivity
	if invert_mouse_y:
		y_offset.rotation_degrees.x -= mouseInput.y * mouse_sensitivity * -1.0
	else:
		y_offset.rotation_degrees.x -= mouseInput.y * mouse_sensitivity
	
	mouseInput = Vector2(0,0)
	y_offset.rotation.x = clamp(y_offset.rotation.x, deg_to_rad(-90), deg_to_rad(90))
