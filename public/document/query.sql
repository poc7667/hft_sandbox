SELECT date_trunc('minute', ticktime) AS ticktime
,max(bid_price) as price, max(bid_volume) as volume
From  czces
Group BY 1
ORDER BY 1
limit 1000;


SELECT cast(ticktime as timestamp(1)) AS ticktime
,max(bid_price) as price, max(bid_volume) as volume
From  czces
Group BY 1
ORDER BY 1
limit 1000;


SELECT date_trunc('hour', ticktime) AS ticktime
,max(bid_price) as price, max(bid_volume) as volume
From  czces
Group BY 1
ORDER BY 1

SELECT date_trunc('hour', ticktime) AS hour_stump
,(extract(minute FROM ticktime)::int / 5) AS min5_slot
,max(bid_price) as price, max(bid_volume) as volume
From  czces
Group BY 1
ORDER BY 1
