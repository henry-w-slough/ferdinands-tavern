extends CanvasLayer


@export var kitchen_handler: Node = null

@onready var order_info: Label = $OrderPanel/Content/MarginContainer/VBoxContainer/OrderInfo


func _process(_delta: float) -> void:
	var current_order: Order = kitchen_handler.get("current_order")
	if current_order == null:
		order_info.text = "Waiting for order..."
		return

	var culture_name := String(Order.Culture.keys()[current_order.culture]).replace("_", " ").to_lower().capitalize()
	var ingredient_names := PackedStringArray()
	for ingredient in current_order.ingredients:
		ingredient_names.append(String(Order.Ingredients.keys()[ingredient]).capitalize())

	order_info.text = "%s\nCulture: %s\nIngredients: %s" % [
		current_order.meal_name,
		culture_name,
		", ".join(ingredient_names)
	]
