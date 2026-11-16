extends Node

	
const MAX_CUSTOMERS = 5


var should_spawn_customer: bool = false
var customer_spawn_chance: int = 3

var total_customers: int = 0


var current_orders: Array[Order] = []


func _process(_delta: float) -> void:

	should_spawn_customer = false
	
	if Engine.get_physics_frames() % 60 == 0 and total_customers < MAX_CUSTOMERS:
		if randi_range(0, customer_spawn_chance) == 0:
			should_spawn_customer = true



