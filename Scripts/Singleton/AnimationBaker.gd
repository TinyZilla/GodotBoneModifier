extends Node

var target_animation: Animation
var root_bone_path: NodePath

func _ready() -> void:
	target_animation = load("res://Assets/Animations/gslinger_run.res")
	root_bone_path = "root/Skeleton3D:root.x"
	#bake_animation()

func bake_animation() -> void:
	
	# Get Root bone Location First Frame
	var root_track_idx: int = target_animation.find_track(root_bone_path, Animation.TrackType.TYPE_POSITION_3D)
	var initial_position: Vector3 = target_animation.track_get_key_value(root_track_idx, 0)
	print(initial_position)
	
	# Insert into Track with offset on the property "offset_position" 
	var new_track_idx: int = target_animation.add_track(Animation.TYPE_POSITION_3D);
	target_animation.track_set_path(new_track_idx, "offset_position")
	print(new_track_idx)
	for key_idx: int in target_animation.track_get_key_count(root_track_idx):
		var time: float = target_animation.track_get_key_time(root_track_idx, key_idx)
		var position: Vector3 = target_animation.track_get_key_value(root_track_idx, key_idx) - initial_position
		target_animation.position_track_insert_key(new_track_idx, time, position)
	
	# Current Problem -- Changing the names to match...
	
	
	# Modify the Root Bone to a static location
	for key_idx: int in target_animation.track_get_key_count(root_track_idx):
		var position: Vector3 = target_animation.track_get_key_value(root_track_idx, key_idx)
		position.z = initial_position.z
		target_animation.track_set_key_value(root_track_idx, key_idx, position)
	
	target_animation.set_name(target_animation.get_name() + '_baked');
	
	# Save Animation
	ResourceSaver.save(target_animation, "res://Assets/Animations/gslinger_run_baked.res")
	pass
