class CreateCzceHfts < ActiveRecord::Migration
  def change
    create_table :czce_hfts do |t|
      t.string :product_type
      t.datetime :contract_month
      t.string :frequency
      t.datetime :ticktime
      t.float :open
      t.float :high
      t.float :low
      t.float :clost
      t.float :volume
      t.timestamps
    end
    add_index :czce_hfts, [:product_type, :contract_month, :frequency, :ticktime], :unique => true , :name => 'czce_hfts_index'
  end
end
