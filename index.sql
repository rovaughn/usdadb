
create unique index nutrient_description_units on nutrient(description, units);
create unique index food_long_description on food(long_description);
create index weight_food on weight(food);
create index food_nutrient_food on food_nutrient(food);

