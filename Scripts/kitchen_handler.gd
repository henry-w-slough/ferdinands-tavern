extends Node


const INGREDIENT_SCENES = {
	Order.Ingredients.CORN: preload("res://Scenes/corn.tscn"),
	Order.Ingredients.BEANS: preload("res://Scenes/beans.tscn"),
	Order.Ingredients.SQUASH: preload("res://Scenes/squash.tscn"),
	Order.Ingredients.PORK: preload("res://Scenes/pork.tscn"),
	Order.Ingredients.FISH: preload("res://Scenes/fish.tscn")
}

@export var ingredient_spawn: Node2D = null

@export var pan: CharacterBody2D = null
@export var min_cook_time: float = 5.0

var should_spawn_order: bool = true

var current_order: Order = null
var spawned_ingredients: Array[Node] = []
var cook_time_elapsed: float = 0.0
var is_cooking: bool = false

func spawn_ingredients(order: Order) -> void:

	current_order = order
	cook_time_elapsed = 0.0
	is_cooking = false

	for ingredient in order.ingredients:
		var ingredient_scene: PackedScene = INGREDIENT_SCENES[ingredient]
		var ingredient_instance = ingredient_scene.instantiate()
		ingredient_instance.add_to_group("pan_ingredients")
		ingredient_instance.set_meta("ingredient_type", ingredient)
		add_child(ingredient_instance)
		var spawn_offset := Vector2(randf_range(-40.0, 40.0), randf_range(-80.0, 80.0))
		ingredient_instance.global_position = ingredient_spawn.global_position + spawn_offset
		spawned_ingredients.append(ingredient_instance)

	should_spawn_order = false


func update(delta: float) -> void:

	if current_order == null:
		return

	if not is_cooking:
		if not pan.is_on_stove or not pan.check_ingredients_in(current_order.ingredients):
			return
		is_cooking = true
		cook_time_elapsed = 0.0
		return

	if not pan.is_on_stove:
		return

	cook_time_elapsed += delta
	if cook_time_elapsed < min_cook_time:
		return

	pan.show_done_animation()
	for ingredient in spawned_ingredients:
		if is_instance_valid(ingredient):
			ingredient.queue_free()

	spawned_ingredients.clear()
	current_order = null
	cook_time_elapsed = 0.0
	is_cooking = false
	should_spawn_order = true





	
