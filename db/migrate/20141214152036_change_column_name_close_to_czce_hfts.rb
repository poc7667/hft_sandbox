class ChangeColumnNameCloseToCzceHfts < ActiveRecord::Migration
  def change
    rename_column :czce_hfts, :clost, :close
  end
end
