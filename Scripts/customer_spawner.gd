extends Node


@export var customer_scene: PackedScene = null

@export var customer_spawn: Node2D = null
@export var customer_order: Node2D = null
@export var customer_exit: Node2D = null


func spawn_customer() -> void:

	var new_customer = customer_scene.instantiate()

	new_customer.global_position = customer_spawn.global_position

	new_customer.order_position = customer_order
	new_customer.exit_position = customer_exit

	add_child(new_customer)


	
