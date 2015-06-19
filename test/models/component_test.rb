require 'test_helper'

class ComponentTest < ActiveSupport::TestCase
  test "culc price" do
    food = FoodTest.newFood
    food.food_price.assign_attributes(price: 2, count_type: :glass)

    component = Component.new(food: food, count: 2, count_type: :glass)
    assert_equal 4, component.cost

    component = Component.new(food: food, count: 2, count_type: :kg)
    assert_equal 20, component.cost

    component = Component.new(food: food, count: 2, count_type: :s_spoon)
    assert_equal 0.3, component.cost
  end
end
