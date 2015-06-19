class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.string :image
      t.string :slug
      t.integer :food_price_id
      t.belongs_to :user
      t.belongs_to :food_category
      t.boolean :is_moderated

      t.integer :count_type_preset
      t.integer :count_type_preset

      t.timestamps
    end
  end
end
