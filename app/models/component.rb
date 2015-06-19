class Component < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe
  delegate :price, to: :food

  def cost
     self.food.cost_of(self.count_type) * self.count
  end

  def count=(value)
    write_attribute(:count, value.gsub(",",'.'))
  end

  protected

end
