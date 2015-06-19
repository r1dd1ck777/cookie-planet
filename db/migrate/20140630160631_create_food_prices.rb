class CreateFoodPrices < ActiveRecord::Migration
  def change
    create_table :food_prices do |t|
      t.decimal :price, :precision => 10, :scale => 4
      t.belongs_to :food, index: true
      t.belongs_to :user
      t.string :count_type, :limit => 10
      t.string :currency, :limit => 3

      t.timestamps
    end
  end
end
