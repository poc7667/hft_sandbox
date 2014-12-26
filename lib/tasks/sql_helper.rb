module SqlHelper

  def get_query_command(frequence, contract_month, product_type, market, sampling_begin_time)
    %{
      SELECT DISTINCT ON (1)
           date_trunc('#{frequence}', ticktime) AS time
         , first_value(last_price) OVER w AS open
         , max(last_price)         OVER w AS high
         , min(last_price)         OVER w AS low
         , last_value(last_price)  OVER w AS close
         , sum(last_volume)        OVER w AS volume
         , product_type
         , contract_month
        FROM   #{market}
        WHERE  product_type = '#{product_type}'
        AND    contract_month = '#{contract_month}'::timestamp
        AND    ticktime >= '#{sampling_begin_time}'
        WINDOW w AS (PARTITION BY date_trunc('#{frequence}', ticktime) ORDER BY ticktime
                     ROWS BETWEEN UNBOUNDED PRECEDING
                              AND UNBOUNDED FOLLOWING)
        ORDER  BY 1
    }.gsub(/\s+/, " ").strip
  end

  def get_query_command_interval_filling(frequence, contract_month, product_type, market, sampling_begin_time, hft_table)
    data_before_removing_empty_days = %{
        SELECT DISTINCT ON (time)
           time_series.ticktime AS time,
           t.high,
           t.low,
           t.open,
           t.close,
           t.volume,
           t.product_type,
           t.contract_month
        FROM 
        (
          SELECT DISTINCT ON (1) generate_series
          (
            date_trunc('second', min(ticktime)::TIMESTAMP),
            max(ticktime)::TIMESTAMP,
            '1 #{frequence}'::interval
          ) AS ticktime FROM #{market} WHERE product_type ='#{product_type}' AND contract_month = '#{contract_month}'::timestamp

        ) time_series
        LEFT JOIN
        (
          SELECT  DISTINCT ON (1)
            date_trunc('#{frequence}', ticktime) AS ticktime ,
            first_value(last_price) OVER w AS open,
            max(last_price) OVER w AS high ,
            min(last_price) OVER w AS low,
            last_value(last_price)  OVER w AS close,
            sum(last_volume) OVER w AS volume,
            product_type,
            contract_month
            FROM #{market}
            WHERE product_type ='#{product_type}' 
            AND contract_month = '#{contract_month}'::timestamp
            WINDOW w AS (PARTITION BY date_trunc('#{frequence}', ticktime) ORDER BY ticktime
                         ROWS BETWEEN UNBOUNDED PRECEDING
                         AND UNBOUNDED FOLLOWING)
        ) t USING (ticktime)
        WHERE time_series.ticktime::time >= '#{market_begin_end_time[market]["begin_at"]}'::time 
        AND time_series.ticktime::time < '#{market_begin_end_time[market]["end_at"]}'::time
        AND time_series.ticktime > '#{sampling_begin_time}'::TIMESTAMP 
        ORDER BY 1       
    }
    return %{
        SELECT data_with_itvl.*
        FROM
        (
          #{data_before_removing_empty_days}
        ) as data_with_itvl JOIN #{hft_table} t2 ON t2.time::date = data_with_itvl.time::date 
        WHERE t2.frequence = 'day'
        AND  t2.product_type ='#{product_type}'
        AND  t2.contract_month = '#{contract_month}'::timestamp ;
    }.gsub(/\s+/, " ").strip
  end

  def market_begin_end_time
    {
      "czces" => {
        "begin_at" => '00:59 am',
        "end_at" => '07:00 am'
        },
      "cffexes" => {
        "begin_at" => '01:14 am',
        "end_at" => '07:16 am'
      }
    }    
  end


end

