AdminUser.create!(email: 'mrriddick7@gmail.com', password: 'password', password_confirmation: 'password')
# user1 = User.create!(email: 'mrriddick7@gmail.com', password: 'password', password_confirmation: 'password')
# user2 = User.create!(email: 'mrriddick8@gmail.com', password: 'password', password_confirmation: 'password')
#
# food_prices = [
#     FoodPrice.create(price: 0.8, count_type: :kg, currency: :UAH),
#     FoodPrice.create(price: 2, count_type: :kg, currency: :RUB),
#     FoodPrice.create(price: 1, count_type: :item, currency: :BYR),
#     FoodPrice.create(price: 0.5, count_type: :item, currency: :UAH, user: user1),
#     FoodPrice.create(price: 1, count_type: :item, currency: :UAH, user: user2),
# ]
#
# f1 = Food.create name: 'картошка', food_prices: food_prices, food_weights: [FoodWeight.create(kg: 0.2, count_type: :item)], food_value: FoodValue.create(energy: 200, protein: 4, fat: 2, sugar: 50, sugar_index: 35)
#
# food_prices = [
#     FoodPrice.create(price: 12, count_type: :kg, currency: :UAH),
# ]
#
# f2 = Food.create name: 'сахар', food_prices: food_prices
# f3 = Food.create name: 'масло'
# f4 = Food.create name: 'куркума'
# f5 = Food.create name: 'молоко'
# f6 = Food.create name: 'вода', count_type_preset: 1
#
# rt1 = RecipeTag.create name: '1е блюда'
# rt2 = RecipeTag.create name: '2е блюда'
# rt3 = RecipeTag.create name: 'выпечка'
#
# r1 = Recipe.create title: 'картоха сахарна1', recipe_tags: [rt1]
# r2 = Recipe.create title: 'картоха сахарна11', recipe_tags: [rt1]
# r3 = Recipe.create title: 'картоха сахарна12', recipe_tags: [rt1, rt2]
# r4 = Recipe.create title: 'картоха сахарна2', recipe_tags: [rt2]
# r5 = Recipe.create title: 'картоха сахарна123', recipe_tags: [rt1, rt2, rt3]
#
# 200.times do |i|
#   Food.create name: "fixture - #{i}"
# end