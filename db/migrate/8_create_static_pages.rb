class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :slug, index: true
      t.string :title
      t.text :text

      t.timestamps
    end

  end
end
