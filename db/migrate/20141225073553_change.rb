class Change < ActiveRecord::Migration
  def change
    change_column :cffexes, :id , "bigint"
  end
end
