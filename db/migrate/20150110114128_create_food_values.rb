class CreateFoodValues < ActiveRecord::Migration
  def change
    create_table :food_values do |t|
      t.decimal :energy, :precision => 20, :scale => 4
      t.decimal :protein, :precision => 20, :scale => 4
      t.decimal :fat, :precision => 20, :scale => 4
      t.decimal :sugar, :precision => 20, :scale => 4
      t.decimal :sugar_index, :precision => 20, :scale => 4

      t.references :nutritionable, polymorphic: true
    end
  end
end
