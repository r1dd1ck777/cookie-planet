class AddCurrencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currency, :string, :limit => 3
  end
end
