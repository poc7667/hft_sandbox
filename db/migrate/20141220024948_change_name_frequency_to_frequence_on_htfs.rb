class ChangeNameFrequencyToFrequenceOnHtfs < ActiveRecord::Migration
  def change
    rename_column :czce_hfts, :frequency, :frequence

  end
end
