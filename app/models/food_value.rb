class FoodValue < ActiveRecord::Base
  belongs_to :nutritionable, polymorphic: true

  def usefull?
    (energy + protein + fat + sugar) > 0
  end
end
