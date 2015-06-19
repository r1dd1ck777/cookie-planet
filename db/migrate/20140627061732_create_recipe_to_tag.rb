class CreateRecipeToTag < ActiveRecord::Migration
  def self.up
    create_table :recipe_to_tag do |t|
      t.column :recipe_tag_id, :integer
      t.column :recipe_id, :integer
    end
  end

  def self.down
    drop_table :recipe_to_tag
  end
end
