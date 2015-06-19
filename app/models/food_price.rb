class FoodPrice < ActiveRecord::Base
  belongs_to :food
  belongs_to :user

  def self.new_kg
    self.new(price: 0, count_type: :kg, currency: :UAH)
  end

end
