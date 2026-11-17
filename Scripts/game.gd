extends Node

#game handles the game loop along with holding variables
#that can be injected from other top level nodes.


@export var customer_handler: Node = null


@export var DAY_LENGTH = 3600
var day_running = true


func _physics_process(_delta: float) -> void:

	if not day_running:
		return
	
	#handler updates should be called here
	customer_handler.update()
	
	if Engine.get_physics_frames() % DAY_LENGTH == 0:
		day_running = false
	
