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
            ORDER  BY ticktime_stamp ASC;
        }.gsub(/\s+/, " ").strip

%{
  SELECT DISTINCT ON (1)
       date_trunc('#{interval}', ticktime) AS ticktime_stamp
     , max(bid_price)         OVER w AS high
     , min(bid_price)         OVER w AS low
     , sum(bid_volume)        OVER w AS volume
     , max(product_type)      OVER w AS product_type
     , min(product_type)      OVER w AS product_type
     , first_value(bid_price) OVER w AS open
     , lAst_value(bid_price)  OVER w AS close
    FROM   czces
    WHERE  ticktime >= '#{begin_time}'::timestamp
    AND    ticktime <  '#{end_time}'::timestamp
    AND    product_type ='#{product_type}'
    WINDOW w AS (PARTITION BY date_trunc('#{interval}', ticktime) ORDER BY ticktime
                 ROWS BETWEEN UNBOUNDED PRECEDING
                          AND UNBOUNDED FOLLOWING)
    ORDER  BY 1

    ;

}.gsub(/\s+/, " ").strip

  end

  def check_product_type_and_sample_freq
    ["CF", "ME", "RI", "PM", "RS", "WH", "RM", "OI", "TC", "TA", "FG", "JR", "SR"]
  end

end

