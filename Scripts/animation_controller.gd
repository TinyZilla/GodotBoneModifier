extends Node
class_name AnimationController

var current_animation: PoseResolver
var prev_animation: PoseResolver

var accumulated_delta_time: float = 0
var last_queried_time: float = 0

var transition_timer: float = 0
var full_transition_time: float = 0

var current_pose: Dictionary

func transition_to_animation(new_animation: Animation, transition_time: float):
	if current_animation == null:
		current_animation = PoseResolver.new(new_animation)
		return
	
	if transition_timer <= 0 or prev_animation == null:
		prev_animation = current_animation
	
	current_animation = PoseResolver.new(new_animation, prev_animation.get_current_progress_factor(), prev_animation.get_anim_length())
	
	full_transition_time = transition_time
	transition_timer = transition_time

func get_current_bone_pose(skeleton: Skeleton3D) -> Dictionary:
	var delta_time = accumulated_delta_time
	accumulated_delta_time = 0
	if transition_timer > 0 and prev_animation != null:
		# Value goes from 0 -> 1 as transition happens.
		var transition_time_blend_factor: float = 1 - (transition_timer / full_transition_time)
		var prev_pose: Dictionary = prev_animation.get_bone_pose(skeleton, delta_time, transition_time_blend_factor)
		
		# Don't ignore the current pose at the beginning of transition. Otherwise it looks Jaggy.
		var from_pose: Dictionary = blend_bone_pose(current_pose, prev_pose, transition_time_blend_factor)
		var to_pose: Dictionary = current_animation.get_bone_pose(skeleton, delta_time, 1 - transition_time_blend_factor)
		
		current_pose = blend_bone_pose(from_pose, to_pose, transition_time_blend_factor)
		return current_pose
	
	current_pose = current_animation.get_bone_pose(skeleton, delta_time, 0)
	return current_pose

func blend_bone_pose(from_pose: Dictionary, to_pose: Dictionary, blend_ratio: float) -> Dictionary:
	var bone_pose_dict: Dictionary = {};
	
	# blend_ratio is 0 -> 1 that's going to be fed into the LERP.
	# Take one bone pose, iterate it, then blend between the two using LERP or SLERP
	for key: String in from_pose:
		bone_pose_dict.set(key, lerp(from_pose[key], to_pose[key], blend_ratio))

	return bone_pose_dict

func _process(delta: float) -> void:
	accumulated_delta_time += delta
	if transition_timer > 0:
		transition_timer -= delta
