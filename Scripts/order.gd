extends Node
class_name Order


enum Ingredient {
	Beef,
	Wheat,
	Broth,
	Vegetables,
	Egg
}


enum OrderType { 
	Wellington, 
	BeefStew, 
}


# Use the enum as the dictionary keys
const OrderIngredient := {

	OrderType.Wellington: [
		Ingredient.Beef, Ingredient.Wheat, Ingredient.Egg
	],

	OrderType.BeefStew: [
		Ingredient.Beef, Ingredient.Broth, Ingredient.Vegetables
	]

}


var type: OrderType = OrderType.values().pick_random()
var ingredients: Array = OrderIngredient[type]




