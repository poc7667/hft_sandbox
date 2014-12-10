class CreateDataSources < ActiveRecord::Migration
  def change
    create_table :data_sources do |t|
      t.string :market
      t.string :product_type
      t.datetime :transaction_date
      t.string :file_name
      t.text :md5_sum
      t.string :comment

      t.timestamps
    end
  end
end
