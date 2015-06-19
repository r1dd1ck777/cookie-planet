class CreateFoodWeights < ActiveRecord::Migration
  def change
    create_table :food_weights do |t|
      t.decimal :kg, :precision => 20, :scale => 4
      t.string :count_type, :limit => 10

      t.references :weightable, polymorphic: true

      t.timestamps
    end
  end
end
