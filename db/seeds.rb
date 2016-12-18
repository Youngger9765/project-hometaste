# Cuisines Table seeds
all_cuisines_name = [
	"Sandwiches",
	"African",
	"American",
	"Breakfast & Brunch",
	"Burgers",
	"BBQ",
	"Caribbean",
	"Chinese",
	"East European",
	"French",
	"Greek",
	"Halal",
	"Indian",
	"Italian",
	"Japanese",
	"Lebanese",
	"Mexican",
	"Moroccan",
	"Pizza",
	"Seafood",
	"Spanish",
	"Salad",
	"Thai",
	"Turkish",
	"Vegan",
	"Vegetarian",
	"Vietnamese",
]

all_cuisines_name.each do |cuisine|
	Cuisine.create!(:name => cuisine)
end
