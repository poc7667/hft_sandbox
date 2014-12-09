class AddContractMonthToCzce < ActiveRecord::Migration
  def change
    add_column :czces, :contract_month, :datetime
  end
end
