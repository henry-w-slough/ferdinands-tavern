extends Node


@export var customer_scene: PackedScene = null
@export var customer_spawn: Node2D = null


func spawn_customer() -> void:

	var new_customer = customer_scene.instantiate()

	new_customer.global_position = customer_spawn.global_position

	add_child(new_customer)


	
