extends Node


@export var game: Node = null

var spawner: Node = null


@export var CUSTOMER_SPAWN_RATE = 120
var should_spawn_customer: bool = false


func _ready() -> void:
	spawner = get_node("Spawner")


func update() -> void:

	should_spawn_customer = false

	if Engine.get_physics_frames() % CUSTOMER_SPAWN_RATE == 0:
		should_spawn_customer = true
	
	if should_spawn_customer:
		spawner.spawn_customer()
