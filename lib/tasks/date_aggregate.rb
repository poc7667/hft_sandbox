module DateAggregate


  def query_by_interval(interval, begin_time, end_time, product_type='SR', market='czces')
    %{
      SELECT DISTINCT ON (1)
           date_trunc('#{interval}', ticktime) AS ticktime_stamp
         , first_value(last_price) OVER w AS open
         , max(last_price)         OVER w AS high
         , min(last_price)         OVER w AS low
         , last_value(last_price)  OVER w AS close
         , sum(last_volume)        OVER w AS tt_volume
         , product_type
         , contract_month
        FROM   #{market}
        WHERE  ticktime >= '#{begin_time}'::timestamp
        AND    ticktime <  '#{end_time}'::timestamp
        AND    product_type ='#{product_type}'
        AND    contract_month = '2014-09-01 00:00:00'::timestamp
        WINDOW w AS (PARTITION BY date_trunc('#{interval}', ticktime) ORDER BY ticktime
                     ROWS BETWEEN UNBOUNDED PRECEDING
                              AND UNBOUNDED FOLLOWING)
        ORDER  BY 1
        LIMIT 10
        ;

    }.gsub(/\s+/, " ").strip
  end


  def get_contract_month_by_product_type
    ActiveRecord::Base.connection.execute(
      %{SELECT DISTINCT
        contract_month, product_type
        FROM czces;}
      )
  end


  def get_query_command(interval, contract_month, product_type='SR', market='czces')
    %{
      SELECT DISTINCT ON (1)
           date_trunc('#{interval}', ticktime) AS ticktime_stamp
         , first_value(last_price) OVER w AS open
         , max(last_price)         OVER w AS high
         , min(last_price)         OVER w AS low
         , last_value(last_price)  OVER w AS close
         , sum(last_volume)        OVER w AS tt_volume
         , product_type
         , contract_month
        FROM   #{market}
        WHERE  ticktime >= '#{begin_time}'::timestamp
        AND    ticktime <  '#{end_time}'::timestamp
        AND    product_type ='#{product_type}'
        AND    contract_month = '#{contract_month}'::timestamp
        WINDOW w AS (PARTITION BY date_trunc('#{interval}', ticktime) ORDER BY ticktime
                     ROWS BETWEEN UNBOUNDED PRECEDING
                              AND UNBOUNDED FOLLOWING)
        ORDER  BY 1
        ;

    }.gsub(/\s+/, " ").strip
  end


end

