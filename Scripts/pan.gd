extends CharacterBody2D

var follows_mouse: bool = false
var mouse_offset: Vector2 = Vector2.ZERO


@export var move_lerp_speed: float = 10.0

var pan_collision_shape: CollisionShape2D
var animated_sprite: AnimatedSprite2D
var stove_query: PhysicsShapeQueryParameters2D
var contained_ingredients: Array[Node2D] = []
var is_on_stove: bool = false
var done_animation_time_remaining: float = 0.0


func _ready() -> void:
	input_pickable = true
	pan_collision_shape = get_node("CollisionShape2D")
	animated_sprite = get_node("AnimatedSprite2D")

	stove_query = PhysicsShapeQueryParameters2D.new()
	stove_query.shape = pan_collision_shape.shape
	stove_query.collision_mask = collision_mask
	stove_query.exclude = [get_rid()]
	stove_query.collide_with_bodies = true



func _physics_process(delta: float) -> void:
	stove_query.transform = pan_collision_shape.global_transform
	var collisions = get_world_2d().direct_space_state.intersect_shape(stove_query)
	var over_stove := false

	for collision in collisions:
		var collider = collision["collider"]
		if collider is Node and collider.name == "Stove":
			over_stove = true
			break

	is_on_stove = over_stove
	if done_animation_time_remaining > 0.0:
		done_animation_time_remaining = maxf(done_animation_time_remaining - delta, 0.0)
		if done_animation_time_remaining > 0.0:
			if animated_sprite.animation != &"done":
				animated_sprite.play(&"done")
			return

	var target_animation: StringName = &"frying" if over_stove else &"default"
	if animated_sprite.animation != target_animation:
		animated_sprite.play(target_animation)


func show_done_animation() -> void:
	done_animation_time_remaining = 3.0
	animated_sprite.play(&"done")


func _process(delta: float) -> void:
	if follows_mouse and not _is_interaction_camera_active():
		follows_mouse = false

	var movement := Vector2.ZERO
	if follows_mouse:
		var previous_position := global_position
		var target_position := get_global_mouse_position() + mouse_offset
		var weight := 1.0 - exp(-move_lerp_speed * delta)
		global_position = global_position.lerp(target_position, weight)
		movement = global_position - previous_position

	for i in range(contained_ingredients.size() - 1, -1, -1):
		var ingredient := contained_ingredients[i]
		if not is_instance_valid(ingredient):
			contained_ingredients.remove_at(i)
		elif follows_mouse:
			ingredient.global_position += movement


func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	if not _is_interaction_camera_active():
		return
	if not _is_mouse_over_pan():
		return

	if _place_held_ingredient():
		get_viewport().set_input_as_handled()
		return

	follows_mouse = not follows_mouse
	if follows_mouse:
		mouse_offset = global_position - get_global_mouse_position()
	get_viewport().set_input_as_handled()


func _is_interaction_camera_active() -> bool:
	var current_camera := get_viewport().get_camera_2d()
	return current_camera != null and current_camera.is_in_group("pan_interaction_camera")


func _is_mouse_over_pan() -> bool:
	var mouse_position := get_global_mouse_position()
	for node in find_children("*", "CollisionShape2D"):
		var shape_node := node as CollisionShape2D
		if shape_node == null or shape_node.disabled or shape_node.shape == null:
			continue

		var local_position := shape_node.to_local(mouse_position)
		if shape_node.shape is CircleShape2D:
			var circle := shape_node.shape as CircleShape2D
			if local_position.length_squared() <= circle.radius * circle.radius:
				return true
		elif shape_node.shape is RectangleShape2D:
			var rectangle := shape_node.shape as RectangleShape2D
			if abs(local_position.x) <= rectangle.size.x * 0.5 and abs(local_position.y) <= rectangle.size.y * 0.5:
				return true

	return false


func check_ingredients_in(ingredients: Array[Order.Ingredients]) -> bool:
	var available_ingredients: Array[Order.Ingredients] = []

	for ingredient_node in contained_ingredients:
		if is_instance_valid(ingredient_node) and _contains_position(ingredient_node.global_position):
			available_ingredients.append(ingredient_node.get_meta("ingredient_type"))

	for ingredient in ingredients:
		var ingredient_index := available_ingredients.find(ingredient)
		if ingredient_index == -1:
			return false
		available_ingredients.remove_at(ingredient_index)

	return true


func _contains_position(position: Vector2) -> bool:
	var pan_circle := pan_collision_shape.shape as CircleShape2D
	var local_position := pan_collision_shape.to_local(position)
	return local_position.length_squared() <= pan_circle.radius * pan_circle.radius


func _place_held_ingredient() -> bool:
	for node in get_tree().get_nodes_in_group("pan_ingredients"):
		var ingredient := node as Node2D
		if ingredient == null or ingredient.get("follows_mouse") != true:
			continue

		ingredient.set("follows_mouse", false)
		ingredient.global_position = pan_collision_shape.global_position
		if not contained_ingredients.has(ingredient):
			contained_ingredients.append(ingredient)
		return true

	return false
