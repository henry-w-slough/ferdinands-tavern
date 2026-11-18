class_name Order

#this class just holds order info 
#and what is needed so it stays consistent


enum Ingredients {
	CORN,
	BEANS,
	SQUASH,
	PORK,
	FISH
}


enum Culture {
	NEW_WORLD,
	OLD_WORLD,
	MIXED_WORLD
}


enum Meal {
	COLUMBUS_PORK_AND_SQUASH,
	POLOS_SQUASH_COMBO,
	HOUSE_SOUP,
	MEAT_LOVERS_MEAL,
	GODS_FAVORITE_SOUP
}


var culture: Culture = Culture.NEW_WORLD
var ingredients: Array[Ingredients] = []
var meal: Meal = Meal.COLUMBUS_PORK_AND_SQUASH
var meal_name: String = ""


func _init() -> void:
	meal = Meal.values().pick_random()
	meal_name = String(Meal.keys()[meal]).replace("_", " ").to_lower().capitalize()
	match meal:
		Meal.COLUMBUS_PORK_AND_SQUASH:
			culture = Culture.MIXED_WORLD
			ingredients.append(Ingredients.PORK)
			ingredients.append(Ingredients.SQUASH)
			ingredients.append(Ingredients.CORN)
		Meal.POLOS_SQUASH_COMBO:
			culture = Culture.NEW_WORLD
			ingredients.append(Ingredients.SQUASH)
			ingredients.append(Ingredients.CORN)
			ingredients.append(Ingredients.BEANS)
		Meal.HOUSE_SOUP:
			culture = Culture.OLD_WORLD
			ingredients.append(Ingredients.FISH)
			ingredients.append(Ingredients.BEANS)
			ingredients.append(Ingredients.CORN)
		Meal.MEAT_LOVERS_MEAL:
			culture = Culture.MIXED_WORLD
			ingredients.append(Ingredients.PORK)
			ingredients.append(Ingredients.FISH)
			ingredients.append(Ingredients.BEANS)
		Meal.GODS_FAVORITE_SOUP:
			culture = Culture.OLD_WORLD
			ingredients.append(Ingredients.CORN)
			ingredients.append(Ingredients.BEANS)
			ingredients.append(Ingredients.SQUASH)
