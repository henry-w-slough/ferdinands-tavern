extends CharacterBody2D

enum State {
	ENTERING,
	ORDERING,
	EXITING,
}

enum WalkAnimation {
	DOWN = 0,
	LEFT = 1,
	RIGHT = 2,
	UP = 3
}

const CUSTOMER_SPRITE_SHEETS = [
	preload("res://Assets/character1.png"),
	preload("res://Assets/character2.png"),
	preload("res://Assets/character3.png"),
	preload("res://Assets/character4.png"),
	preload("res://Assets/character5.png")
]

const WALK_ANIMATIONS = {
	WalkAnimation.DOWN: &"walk_down",
	WalkAnimation.LEFT: &"walk_left",
	WalkAnimation.RIGHT: &"walk_right",
	WalkAnimation.UP: &"walk_up"
}

const FRAME_SIZE = Vector2(16, 20)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var state: State = State.ENTERING

var game: Node = null

var order_point: Node2D
var spawn_point: Node2D

var _navigation_ready: bool = false

const move_speed: float = 50.0

var order_wait_time = 60


func _ready() -> void:

	var sprite_sheet: Texture2D = CUSTOMER_SPRITE_SHEETS[randi_range(0, CUSTOMER_SPRITE_SHEETS.size() - 1)]
	sprite.sprite_frames = _create_sprite_frames(sprite_sheet)

	sprite.play(WALK_ANIMATIONS[WalkAnimation.LEFT])

	await get_tree().physics_frame
	_navigation_ready = true
	_set_target_position(order_point.global_position)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _physics_process(_delta: float) -> void:

	if state == State.ORDERING:
		order_wait_time -= 1
		if order_wait_time > 0:
			return
		_add_order()
		state = State.EXITING
		
	_navigate()
	move_and_slide()


func _process(_delta: float) -> void:
	_animate()


func _on_mouse_entered() -> void:
	if sprite.material:
		# Set outline thickness to 1 pixel (or 2.0 for a thicker pixel border)
		sprite.material.set_shader_parameter("outline_width", 1.0)


func _on_mouse_exited() -> void:
	if sprite.material:
		# Hide the outline completely
		sprite.material.set_shader_parameter("outline_width", 0.0)


func _add_order() -> void:
	var new_order = Order.new()
	game.current_orders.append(new_order)



func _animate() -> void:

	var real_velocity = get_real_velocity()

	if abs(real_velocity.x) > abs(real_velocity.y):
		if real_velocity.x > 0:
			sprite.play(WALK_ANIMATIONS[WalkAnimation.RIGHT])
		if real_velocity.x < 0:
			sprite.play(WALK_ANIMATIONS[WalkAnimation.LEFT])
	else:
		if real_velocity.y > 0:
			sprite.play(WALK_ANIMATIONS[WalkAnimation.DOWN])
		if real_velocity.y < 0:
			sprite.play(WALK_ANIMATIONS[WalkAnimation.UP])


func _navigate() -> void:

	match state:
		State.ENTERING:
			_set_target_position(order_point.global_position)
		State.EXITING:
			_set_target_position(spawn_point.global_position)

	if not _navigation_ready:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var next_pos := nav_agent.get_next_path_position()
	
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		if state == State.EXITING:
			self.queue_free()

		if state == State.ENTERING:
			state = State.ORDERING

		return

	velocity = global_position.direction_to(next_pos) * move_speed


func _set_target_position(target: Vector2) -> void:
	if not nav_agent.target_position.is_equal_approx(target):
		nav_agent.target_position = target


func _create_sprite_frames(sprite_sheet: Texture2D) -> SpriteFrames:

	var sprite_frames := SpriteFrames.new()

	for animation in WALK_ANIMATIONS:
		var animation_name: StringName = WALK_ANIMATIONS[animation]
		sprite_frames.add_animation(animation_name)
		sprite_frames.set_animation_speed(animation_name, 5.0)
		sprite_frames.set_animation_loop(animation_name, true)

		var row: int = animation
		for column in range(3):
			var frame := AtlasTexture.new()
			frame.atlas = sprite_sheet
			frame.region = Rect2(column * FRAME_SIZE.x, row * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
			sprite_frames.add_frame(animation_name, frame)

	return sprite_frames
