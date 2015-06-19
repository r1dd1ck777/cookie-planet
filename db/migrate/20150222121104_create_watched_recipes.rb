class CreateWatchedRecipes < ActiveRecord::Migration
  def change
    create_table :watched_recipes do |t|
      t.belongs_to :recipe, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
