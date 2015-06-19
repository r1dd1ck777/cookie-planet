class Food < ActiveRecord::Base
  COUNT_TYPE_PRESET_FLUID = 1
  @@current_user_id = 0
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :food_weights, as: :weightable, :dependent => :destroy
  has_many :food_prices, :dependent => :destroy
  belongs_to :user
  belongs_to :food_category
  has_one :food_value, as: :nutritionable, :dependent => :destroy

  accepts_nested_attributes_for :food_weights, :food_prices, :food_value, allow_destroy: true

  mount_uploader :image, FoodImageUploader

  # after_initialize :create_price, :create_food_value
  before_create :check_preset

  validates :name, presence: true

  scope :only_public, -> do
    where(is_moderated: true)
  end

  def self.current_user_id= id
    @@current_user_id = id
  end

  def prices
    objects = food_prices.select { |p| p.user_id == nil || p.user_id == @@current_user_id }
    objects.map do |p|
      {
          price: p.price,
          user_id: p.user_id,
          count_type: p.count_type,
          currency: p.currency,
      }
    end
  end

  # returns cost of 1 item of some :count_type
  def cost_of count_type  #glass
    coof = self.trans_weight self.food_price.count_type, count_type
    # puts coof
    self.food_price.price * coof
  end

  # returns how many :from_count_type are in :to_count_type
  def trans_weight from_count_type, to_count_type
    return 1 if from_count_type.equal?(to_count_type)
    return 1000 if from_count_type.equal?(:ml) && to_count_type.equal?(:l)
    return 0.001 if from_count_type.equal?(:l) && to_count_type.equal?(:ml)
    # other
    in_kg = self.trans_weight_to_kg_from to_count_type
    (in_kg * self.trans_weight_from_kg_to(from_count_type)).round(3)
  end

  def trans_weight_to_kg_from count_type
    case count_type
      when :kg
        return 1
      when :gr
        return 0.001
      else
        return self.food_weights.find_by(count_type: count_type).kg
    end
  end

  def trans_weight_from_kg_to count_type
    case count_type
      when :kg
        return 1
      when :gr
        return 1000
      else
        return (1 / self.food_weights.find_by(count_type: count_type).kg).round(3)
    end
  end

  protected

  def create_price
    food_prices << FoodPrice.new_kg if food_prices.empty?
  end

  def create_food_value
    food_value = FoodValue.new if food_value.nil?
  end

  def check_preset
    case count_type_preset
      when COUNT_TYPE_PRESET_FLUID
        food_weights.new kg: 0.001, count_type: :ml
        food_weights.new kg: 1, count_type: :l
      else
        food_weights.new kg: 0.001, count_type: :gr
        food_weights.new kg: 1, count_type: :kg
    end
  end

  # def delete_weights
  #   FoodWeight.delete_all(food_id: id)
  # end
  #
  # def delete_food_price
  #   FoodPrice.delete_all(food_id: id)
  # end
end
