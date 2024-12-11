#@tool
class_name BaseAnimationModifier3D
extends SkeletonModifier3D

@export
var animation_controller: AnimationController

func _ready() -> void:
	active = true

func _process_modification() -> void:
	var pose_dict: Dictionary = animation_controller.get_current_bone_pose(get_skeleton())
	apply_pose_dict(pose_dict)
	
func apply_pose_dict(pose_dict: Dictionary) -> void:
	var skeleton: Skeleton3D = get_skeleton()
	
	for key: String in pose_dict:
		var key_split: Array = key.split('_')
		match (key_split[0]):
			'position':
				skeleton.set_bone_pose_position(int(key_split[1]), pose_dict[key])
			'rotation':
				skeleton.set_bone_pose_rotation(int(key_split[1]), pose_dict[key])
