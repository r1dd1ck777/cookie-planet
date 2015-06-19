class Ajax::FoodsController < ApplicationController
  def all
    user_id = current_user ? current_user.id : nil
    Food.current_user_id = user_id

    key = "/ajax/foods/all#user_id:#{user_id}"

    @foods_json = Rails.cache.fetch(key, expires_in: 1.minute) do
      foods = Food.only_public.includes(:food_weights, :food_prices, :food_value )
      @foods_json = foods.to_json only: [:id, :name],
                                  include: {
                                      food_weights: { only: [:kg, :count_type] },
                                      food_value: { only: [:energy, :protein, :fat, :sugar] }
                                  },
                                  methods: [:prices]
    end

    render :text => @foods_json
  end
end
