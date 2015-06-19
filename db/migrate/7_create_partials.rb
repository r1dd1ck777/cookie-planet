class CreatePartials < ActiveRecord::Migration
  def change
    create_table :partials do |t|
      t.string :placement
      t.text :text
    end

    add_index :partials, :placement, unique: true

  end
end
