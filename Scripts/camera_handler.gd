extends Node


@export var cameras: Array[Camera2D] = []
var current_cam = 0

func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("change_camera_left"):
		current_cam -= 1
		_update_current_cam()

	if Input.is_action_just_pressed("change_camera_right"):
		current_cam += 1
		_update_current_cam()


func _update_current_cam() -> void:

	if current_cam < 0:
		current_cam = len(cameras)-1

	if current_cam > len(cameras)-1:
		current_cam = 0

	cameras[current_cam].make_current()







