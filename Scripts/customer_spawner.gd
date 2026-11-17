extends Node


const SPAWN_CLEARANCE_SQUARED = 64.0


@export var game: Node = null

@export var customer_scene: PackedScene = null

@export var customer_spawn_point: Node2D
@export var customer_order_point: Node2D



func _process(_delta: float) -> void:
	
	if game.should_spawn_customer:
		_spawn_customer()



func _spawn_customer() -> void:

	var new_customer = customer_scene.instantiate()

	new_customer.global_position = customer_spawn_point.global_position

	new_customer.order_point = customer_order_point
	new_customer.spawn_point = customer_spawn_point

	new_customer.game = game

	add_child(new_customer)
