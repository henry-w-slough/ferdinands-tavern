extends Node


@export var game: Node = null

@export var spawnable_customers: Array[PackedScene] = []

@export var customer_spawn_point: Node2D = null


func _process(_delta: float) -> void:

	if game.should_spawn_customer:
		_spawn_customer()



func _spawn_customer() -> void:
	
	var new_customer_scene = spawnable_customers.get(randi_range(0, len(spawnable_customers)-1))
	var new_customer = new_customer_scene.instantiate()

	new_customer.global_position = customer_spawn_point.global_position

	add_child(new_customer)
