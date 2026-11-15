extends Node


var should_spawn_customer: bool = false
var customer_spawn_chance: int = 50


func _process(_delta: float) -> void:
	
	should_spawn_customer = false
	
	if randi_range(1, customer_spawn_chance) == 1:
		should_spawn_customer = true


