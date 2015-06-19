class CreateMetaPages < ActiveRecord::Migration
  def change
    create_table :meta_pages do |t|
      t.string :path

      t.timestamps
    end
  end
end
