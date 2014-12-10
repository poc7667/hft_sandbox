class FixLastPriceToCzces < ActiveRecord::Migration
  def change
    remove_column :czces, :float
    add_column :czces, :last_price, :float
  end
end