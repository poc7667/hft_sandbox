class AddIndexToCffexHfts < ActiveRecord::Migration
  def change
    add_index "cffex_hfts", ["product_type", "contract_month", "frequence", "time"], name: "cffex_hfts_index", unique: true, using: :btree
  end
end