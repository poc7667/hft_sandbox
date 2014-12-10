class ChangeIdToBigIntToCzces < ActiveRecord::Migration
  def change
    change_column :czces, :id , "bigint"
  end
end
