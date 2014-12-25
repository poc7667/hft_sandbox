class CreateCffexHfts < ActiveRecord::Migration
  def change
    create_table :cffex_hfts do |t|
      t.string :product_type
      t.datetime :contract_month
      t.string :frequence
      t.datetime :time
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.float :volume

      t.timestamps
    end
  end
end
