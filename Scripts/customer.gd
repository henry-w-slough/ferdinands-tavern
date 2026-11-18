extends CharacterBody2D


enum WalkAnimation {
	DOWN = 0,
	LEFT = 1,
	RIGHT = 2,
	UP = 3
}


const WALK_ANIMATIONS = {
	WalkAnimation.DOWN: &"walk_down",
	WalkAnimation.LEFT: &"walk_left",
	WalkAnimation.RIGHT: &"walk_right",
	WalkAnimation.UP: &"walk_up"
}


const SPRITESHEETS = [
	preload("res://Assets/Customers/Customer1.png"),
	preload("res://Assets/Customers/Customer2.png"),
	preload("res://Assets/Customers/Customer3.png"),
	preload("res://Assets/Customers/Customer4.png"),
	preload("res://Assets/Customers/Customer5.png")
]


enum State {
	ENTERING,
	ORDERING,
	EXITING
}


const FRAME_SIZE = Vector2(16, 20)
const OUTLINE_SHADER = preload("res://Assets/Outline.gdshader")

var order_position: Node2D = null
var exit_position: Node2D = null

@export var movement_speed: float = 100.0

var sprite: AnimatedSprite2D = null
var default_material: Material = null
var hover_material: ShaderMaterial = null
var nav_agent: NavigationAgent2D = null
var has_navigation_target: bool = false
var has_exit_target: bool = false

var state: State = State.ENTERING

#order is only set when the order has been placed.
var order: Order = null


func _ready() -> void:

	#setting up nav agent for first target
	nav_agent = get_node("NavigationAgent2D")
	nav_agent.target_position = order_position.global_position
	input_pickable = true

	#animated sprite setup
	sprite = get_node("AnimatedSprite2D")

	#setting material defaults
	default_material = sprite.material
	hover_material = ShaderMaterial.new()
	hover_material.shader = OUTLINE_SHADER
	hover_material.set_shader_parameter("color", Color.WHITE)
	hover_material.set_shader_parameter("width", 1.0)
	hover_material.set_shader_parameter("inside", false)
	hover_material.set_shader_parameter("number_of_images", Vector2(3.0, 4.0))
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	#making spritesheet based on random int
	var sprite_sheet: Texture2D = SPRITESHEETS.pick_random()
	sprite.sprite_frames = _create_sprites(sprite_sheet)

	sprite.play(WALK_ANIMATIONS[WalkAnimation.LEFT])


func _physics_process(delta: float) -> void:
	_navigation(delta)


func _process(_delta: float) -> void:
	_animate()


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if state != State.ORDERING:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		order = Order.new()
		state = State.EXITING


func _on_mouse_entered() -> void:
	sprite.material = hover_material


func _on_mouse_exited() -> void:
	sprite.material = default_material


func _navigation(delta: float) -> void:

	if not has_navigation_target:
		nav_agent.target_position = order_position.global_position
		nav_agent.get_next_path_position()
		has_navigation_target = true
		return

	if state == State.ORDERING:
		velocity = Vector2.ZERO
		return

	if state == State.EXITING and not has_exit_target:
		#setting final nav
		nav_agent.target_position = exit_position.global_position
		nav_agent.get_next_path_position()
		has_exit_target = true
		return

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO

		match state:
			State.ENTERING:
				state = State.ORDERING
			State.EXITING:
				#distance check to prevent immediate free
				if global_position.distance_to(exit_position.global_position) <= nav_agent.target_desired_distance:
					queue_free()
					return

	#getting velocity based on nav path
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var desired_velocity := global_position.direction_to(next_path_position) * movement_speed

	#checking for early collisions to prevent jitter in the direction of velocity
	var collision := KinematicCollision2D.new()
	if test_move(global_transform, desired_velocity * delta, collision):
		if desired_velocity.dot(collision.get_normal()) < 0.0:
			velocity = Vector2.ZERO
			return

	velocity = desired_velocity
	move_and_slide()


func _animate() -> void:
	
	var real_velocity := get_real_velocity()

	if real_velocity.is_zero_approx():
		return

	var animation_name: StringName
	if abs(real_velocity.x) > abs(real_velocity.y):
		animation_name = WALK_ANIMATIONS[WalkAnimation.RIGHT if real_velocity.x > 0 else WalkAnimation.LEFT]
	else:
		animation_name = WALK_ANIMATIONS[WalkAnimation.DOWN if real_velocity.y > 0 else WalkAnimation.UP]

	if sprite.animation != animation_name:
		sprite.play(animation_name)


func _create_sprites(sprite_sheet: Texture2D) -> SpriteFrames:

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
			frame.filter_clip = true
			sprite_frames.add_frame(animation_name, frame)

	return sprite_frames
