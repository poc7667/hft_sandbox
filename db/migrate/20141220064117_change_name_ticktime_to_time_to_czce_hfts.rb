class ChangeNameTicktimeToTimeToCzceHfts < ActiveRecord::Migration
  def change
    rename_column :czce_hfts, :ticktime, :time
  end
end
