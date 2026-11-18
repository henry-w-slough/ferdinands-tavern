extends Node

#game handles the game loop along with holding variables
#that can be injected from other top level nodes.


@export var customer_handler: Node = null
@export var kitchen_handler: Node = null

@export var DAY_LENGTH: int = 3600
var day_running: bool = true
var day_time_left: float = 0.0
var money: int = 0

var orders: Array[Order] = []


func _ready() -> void:
	day_time_left = float(DAY_LENGTH) / float(Engine.physics_ticks_per_second)


func _physics_process(delta: float) -> void:

	if not day_running:
		return
	
	customer_handler.update()
	var had_active_order: bool = kitchen_handler.get("current_order") != null
	kitchen_handler.update(delta)
	if had_active_order and kitchen_handler.get("current_order") == null:
		money += 10

	for customer in customer_handler.customers:
		if is_instance_valid(customer) and customer.order != null:
			var customer_order: Order = customer.order
			if not orders.has(customer_order):
				orders.append(customer_order)
			customer.order = null

	if kitchen_handler.should_spawn_order:
		if len(orders) > 0:
			kitchen_handler.spawn_ingredients(orders.get(0))
			orders.remove_at(0)
		

	day_time_left = maxf(day_time_left - delta, 0.0)
	if day_time_left <= 0.0:
		day_running = false
	
