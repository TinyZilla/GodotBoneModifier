extends Resource
class_name PoseResolver

# For Now it's an animation. Change it to a Pose Provider Class for 8 way animation.
var _pose_provider: Animation

var _pose_time: float
var _target_length: float

func _init(pose_provider: Animation, pose_progress_factor: float = 0, target_length: float = -1) -> void:
	_pose_provider = pose_provider
	_pose_time = pose_provider.length * pose_progress_factor
	_target_length = target_length if target_length > 0 else pose_provider.length

func get_current_progress_factor() -> float:
	return _pose_time / _pose_provider.length

func get_anim_length() -> float:
	return _pose_provider.length

func set_target_length(length: float) -> void:
	_target_length = length

func get_bone_pose(skeleton: Skeleton3D, time_delta: float, target_length_factor: float = 0) -> Dictionary:
	var target_time_scale: float = _pose_provider.length / _target_length
	var influence_factor = lerp(1.0, target_time_scale, target_length_factor)
	_pose_time += time_delta * influence_factor
	_pose_time = _clamp_time_to_duration(_pose_time, _pose_provider.length)
	return _get_bone_pose(skeleton, _pose_provider, _pose_time)

func _get_bone_pose(skeleton: Skeleton3D, animation_clip: Animation, clip_time: float) -> Dictionary:
	var bone_pose_dict: Dictionary = {};
		
	for bone_idx: int in skeleton.get_bone_count():
		var bone_name: StringName = skeleton.get_bone_name(bone_idx)
		
		# Maybe i can avoid hard coding this if i get the first track and strip out the base, then construct the nodepath... but that's for later
		var bone_path: NodePath = NodePath("root/Skeleton3D:" + bone_name)
		
		var position_track_idx: int = animation_clip.find_track(bone_path, Animation.TYPE_POSITION_3D)
		var rotation_track_idx: int = animation_clip.find_track(bone_path, Animation.TYPE_ROTATION_3D)
		
		if position_track_idx >= 0:
			var target_pose_position: Vector3 = animation_clip.position_track_interpolate(position_track_idx, clip_time)
			bone_pose_dict.set("position_%d" % bone_idx, target_pose_position);
			#skeleton.set_bone_pose_position(bone_idx, target_pose_position);
		
		if rotation_track_idx >= 0:
			var target_pose_rotation: Quaternion = animation_clip.rotation_track_interpolate(rotation_track_idx, clip_time)
			bone_pose_dict.set("rotation_%d" % bone_idx, target_pose_rotation);
			#skeleton.set_bone_pose_rotation(bone_idx, target_pose_rotation)
	
	return bone_pose_dict

func _clamp_time_to_duration(clip_time: float, clip_duration: float) -> float:
	return clip_time if clip_time < clip_duration else clip_time - floor(clip_time / clip_duration) * clip_duration
