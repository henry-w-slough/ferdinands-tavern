extends Node


var should_spawn_customer: bool = false
var customer_spawn_chance: int = 2

var current_orders: Array[Order] = []

var total_customers: int = 0


func _process(_delta: float) -> void:

	should_spawn_customer = false	

	#checking orders to max_customers to max out the customers that will 
	#at any time enter an order
	if Engine.get_physics_frames() % 60 == 0:
		if randi_range(0, customer_spawn_chance) == 0:
			should_spawn_customer = true
