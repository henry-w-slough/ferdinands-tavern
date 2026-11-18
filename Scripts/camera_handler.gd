extends Node


@export var cameras: Array[Camera2D] = []

var current_camera: int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("change_camera_left"):
		current_camera -= 1
	if Input.is_action_just_pressed("change_camera_right"):
		current_camera += 1

	if current_camera < 0:
		current_camera = len(cameras)-1
	if current_camera > len(cameras)-1:
		current_camera = 0

	cameras[current_camera].make_current()
