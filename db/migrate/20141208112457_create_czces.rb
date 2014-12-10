class CreateCzces < ActiveRecord::Migration
  def change
    create_table :czces do |t|
      t.string :product_type
      t.datetime :ticktime
      t.string :float
      t.float :last_volume
      t.float :last_total_price
      t.float :bid_price
      t.float :bid_volume
      t.float :ask_price
      t.float :ask_volume
      t.float :open_interest
      t.float :trade_volume

      t.timestamps
    end
  end
end
