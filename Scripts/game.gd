extends Node


var should_spawn_customer: bool = false
var customer_spawn_chance: int = 50


var ticks = 0

func _process(_delta: float) -> void:

	should_spawn_customer = false
	
	ticks += 1
	if ticks % 360 == 0:
		should_spawn_customer = true


