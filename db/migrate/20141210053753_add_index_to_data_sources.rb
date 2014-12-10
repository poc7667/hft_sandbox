class AddIndexToDataSources < ActiveRecord::Migration
  def change
    add_index :data_sources, [:transaction_date, :file_name, :md5_sum], :unique => true,:name => 'data_source_index'
  end
end
