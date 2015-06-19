class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :user_id
      t.string :title
      t.text :text
      t.string :image
      t.integer :views_count, default: 1

      t.integer :duration
      t.decimal :kg, :precision => 20, :scale => 4

      t.timestamps
    end
  end
end
