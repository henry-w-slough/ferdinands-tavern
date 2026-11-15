extends CharacterBody2D


const CUSTOMER_SPRITE_SHEETS = [
	preload("res://Assets/character1.png"),
	preload("res://Assets/character2.png"),
	preload("res://Assets/character3.png"),
	preload("res://Assets/character4.png"),
	preload("res://Assets/character5.png")
]
const WALK_ANIMATION_ROWS = {
	&"walk_down": 0,
	&"walk_left": 1,
	&"walk_right": 2,
	&"walk_up": 3
}
const FRAME_SIZE = Vector2(16, 20)


enum State {
	ENTERING,
	ORDERING,
	EXITING
}


var order_point: Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	var sprite_sheet: Texture2D = CUSTOMER_SPRITE_SHEETS[randi_range(0, CUSTOMER_SPRITE_SHEETS.size() - 1)]
	sprite.sprite_frames = _create_sprite_frames(sprite_sheet)
	sprite.play(&"walk_left")


func _process(_delta: float) -> void:

	pass


func _create_sprite_frames(sprite_sheet: Texture2D) -> SpriteFrames:

	var sprite_frames := SpriteFrames.new()

	for animation_name in WALK_ANIMATION_ROWS:
		sprite_frames.add_animation(animation_name)
		sprite_frames.set_animation_speed(animation_name, 5.0)
		sprite_frames.set_animation_loop(animation_name, true)

		var row: int = WALK_ANIMATION_ROWS[animation_name]
		for column in range(3):
			var frame := AtlasTexture.new()
			frame.atlas = sprite_sheet
			frame.region = Rect2(column * FRAME_SIZE.x, row * FRAME_SIZE.y, FRAME_SIZE.x, FRAME_SIZE.y)
			sprite_frames.add_frame(animation_name, frame)

	return sprite_frames
