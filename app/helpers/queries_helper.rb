module QueriesHelper

  def query_str(interval, begin_time, end_time, product_type)
      %{SELECT date_trunc(\'#{interval}\', ticktime) AS ticktime_stamp,
            max(bid_price) as high,
            min(bid_price) as low,
            sum(bid_volume) as volume,
            max(product_type) as product_type
            FROM   czces
            WHERE  ticktime >=  \'#{begin_time}\'::timestamp
            AND  ticktime <  \'#{end_time}\'::timestamp
            AND  product_type =\'#{product_type}\'
            GROUP  BY 1
            ORDER  BY ticktime_stamp ASC;}.gsub(/\s+/, " ").strip
  end

  def check_product_type_and_sample_freq
    ["CF", "ME", "RI", "PM", "RS", "WH", "RM", "OI", "TC", "TA", "FG", "JR", "SR"]
  end

end

