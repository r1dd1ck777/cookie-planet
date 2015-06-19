class CreateRecipeTextNodes < ActiveRecord::Migration
  def change
    create_table :recipe_text_nodes do |t|
      t.string :image
      t.string :node, limit: 10
      t.text :text
      t.belongs_to :recipe

      t.timestamps
    end
  end
end
