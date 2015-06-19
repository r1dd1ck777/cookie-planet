require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test "delete relations" do
    food = FoodTest.newFood
    food.save!

    id = food.id
    assert FoodWeight.where(food_id: id).count > 0
    assert FoodPrice.where(food_id: id).count > 0

    food.destroy
    assert FoodWeight.where(food_id: id).count == 0
    assert FoodPrice.where(food_id: id).count == 0
  end

  test "trans_weight" do
    food = FoodTest.newFood

    assert food.trans_weight_to_kg_from(:glass) == 0.2
    assert food.trans_weight_from_kg_to(:glass) == 5

    assert food.trans_weight_to_kg_from(:s_spoon) == 0.015
    assert food.trans_weight_from_kg_to(:s_spoon) == 66.667

    assert_equal 0.075, food.trans_weight(:glass, :s_spoon)
    assert_equal 13.333, food.trans_weight(:s_spoon, :glass)

    assert_equal 0.2, food.trans_weight(:kg, :glass)
    assert_equal 0.015, food.trans_weight(:kg, :s_spoon)

    assert_equal 0.001, food.trans_weight(:kg, :gr)
    assert_equal 1000, food.trans_weight(:gr, :kg)

    assert_equal 1000, food.trans_weight(:ml, :l)
    assert_equal 0.001, food.trans_weight(:l, :ml)

    assert_equal 1, food.trans_weight(:kg, :kg)
  end

  test "cost_of" do
    food = FoodTest.newFood
    food.food_price.assign_attributes(price: 10, count_type: :kg)

    assert_equal 10, food.cost_of(:kg)
    assert_equal 0.01, food.cost_of(:gr)
    assert_equal 2, food.cost_of(:glass)
    assert_equal 0.15, food.cost_of(:s_spoon)

    food.food_price.assign_attributes(price: 10, count_type: :glass)

    assert_equal 50, food.cost_of(:kg)
    assert_equal 0.05, food.cost_of(:gr)
    assert_equal 10, food.cost_of(:glass)
    assert_equal 0.75, food.cost_of(:s_spoon)
  end

  test "bad_cost_of" do
    food = FoodTest.newFood
    food.food_price.assign_attributes(price: 10, count_type: :l)

    # assert_equal 50, food.cost_of(:kg)
  end

  def self.newFood
    food = Food.new
    food.food_weights.new(kg: 0.2, count_type: :glass)
    food.food_weights.new(kg: 0.015, count_type: :s_spoon)
    food.save!
    food
  end
end
