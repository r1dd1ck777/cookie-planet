class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.decimal :count, :precision => 50, :scale => 3
      t.belongs_to :food, index: true
      t.belongs_to :recipe, index: true
      t.string :count_type, :limit => 10

      t.timestamps
    end
  end
end
