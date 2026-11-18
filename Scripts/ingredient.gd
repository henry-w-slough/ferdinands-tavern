extends CharacterBody2D


var follows_mouse: bool = false
var mouse_offset: Vector2 = Vector2.ZERO


@export var move_lerp_speed: float = 10.0


@export var can_be_picked_up: bool = true:
	set(value):
		can_be_picked_up = value
		input_pickable = value


func _ready() -> void:
	input_pickable = can_be_picked_up

	# 1. Enforces sorting overlapping objects (by Z-index / Canvas layer)
	get_viewport().physics_object_picking_sort = true

	# 2. Ensures only the single top-most object fires the input event
	get_viewport().physics_object_picking_first_only = true



func _process(delta: float) -> void:
	if follows_mouse:
		var target_position := get_global_mouse_position() + mouse_offset
		var weight := 1.0 - exp(-move_lerp_speed * delta)
		global_position = global_position.lerp(target_position, weight)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not can_be_picked_up:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		follows_mouse = not follows_mouse
		if follows_mouse:
			mouse_offset = global_position - get_global_mouse_position()
