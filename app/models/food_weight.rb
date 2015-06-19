class FoodWeight < ActiveRecord::Base
  belongs_to :weightable, polymorphic: true

  # def self.new_gr
  #   FoodWeight.new(count_type: CountType.where(title: 'гр.').first, kg: 0.001)
  # end
end
