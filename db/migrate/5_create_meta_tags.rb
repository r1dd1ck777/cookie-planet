class CreateMetaTags < ActiveRecord::Migration
  def change
    create_table :meta_tags do |t|
      t.string :key
      t.text :text
      t.boolean :no_wrap_title
      t.string :value
      t.references :meta_tags_able, polymorphic: true

      t.integer :storage_width
      t.integer :storage_height
      t.integer :storage_depth
      t.string :storage_format
      t.string :storage_mime_type
      t.string :storage_size
      t.float :storage_aspect_ratio

      t.timestamps
    end
  end
end
