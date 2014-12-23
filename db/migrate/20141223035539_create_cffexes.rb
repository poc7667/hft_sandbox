class CreateCffexes < ActiveRecord::Migration
  def change
    create_table :cffexes do |t|
      t.string :product_type
      t.datetime :contract_month
      t.datetime :ticktime
      t.float :last_price
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
