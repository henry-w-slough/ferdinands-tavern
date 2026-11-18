extends Node


@export var customer_scene: PackedScene = null

@export var customer_spawn: Node2D = null
@export var customer_order: Node2D = null
@export var customer_exit: Node2D = null

@export var customer_spawn_rate = 60

var customers: Array[CharacterBody2D] = []
var should_spawn_customer: bool = false

@export var max_customers: int = 1


func update() -> void:

	should_spawn_customer = false

	for i in range(customers.size() - 1, -1, -1):
		if not is_instance_valid(customers[i]):
			customers.remove_at(i)

	if Engine.get_physics_frames() % customer_spawn_rate == 0 and len(customers) < max_customers:
		should_spawn_customer = true

	if should_spawn_customer:
		customers.append(spawn_customer())


func spawn_customer() -> CharacterBody2D:

	var new_customer = customer_scene.instantiate()

	new_customer.global_position = customer_spawn.global_position

	new_customer.order_position = customer_order
	new_customer.exit_position = customer_exit

	add_child(new_customer)

	return new_customer



	
