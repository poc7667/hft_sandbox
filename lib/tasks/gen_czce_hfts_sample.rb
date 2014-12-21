
['second', 'minute', 'hour', 'day', 'month'].each do |frequence|
    query = %{
        Copy 
        (SELECT * from czce_hfts WHERE product_type= 'TA' AND frequence='#{frequence}' AND contract_month='2014-08-01 00:00:00' ORDER BY 5 LIMIT 1000) 
        TO '/tmp/market_czce_product_TA_#{frequence}.csv' With CSV  HEADER;
    }
    print query
end

