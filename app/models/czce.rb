class Czce < ActiveRecord::Base
  default_scope  do
    exclude_columns = %w(created_at updated_at product_type open_interest trade_volume)
    filtered_cols = (column_names - exclude_columns.map(&:to_s)).map{|i| "czces."+i}
    self.select(filtered_cols)
  end


  def self.raw_query
    raw_q = 'SELECT cast(ticktime as timestamp(1)) AS ticktime
              ,max(bid_price) as price, max(bid_volume) as volume
              From  czces
              Group BY 1
              ORDER BY ticktime DESC
              limit 10;'
    ActiveRecord::Base.connection.select_all(raw_q)
  end
end
