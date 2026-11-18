extends Node


var spawner: Node = null


var customers: Array[CharacterBody2D] = []


func _ready() -> void:
	spawner = get_node("Spawner")


func update() -> void:

	spawner.update()
	customers = spawner.customers
