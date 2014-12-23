SELECT time_series.ticktime,
t.high,
t.low,
t.open,
t.close,
t.volume
FROM
(SELECT DISTINCT ON (1) generate_series (min(ticktime)::TIMESTAMP, max(ticktime)::TIMESTAMP, '1 minute'::interval) AS ticktime
FROM czces) time_series
LEFT JOIN
(SELECT DISTINCT ON (1) date_trunc('minute', ticktime) AS ticktime ,
first_value(last_price) OVER w AS OPEN,
max(last_price) OVER w AS high ,
min(last_price) OVER w AS low,
last_value(last_price) OVER w AS CLOSE,
sum(last_volume) OVER w AS volume,
product_type,
contract_month
FROM czces
WHERE product_type ='TA'
AND contract_month = '2014-08-01 00:00:00'::TIMESTAMP WINDOW w AS (PARTITION BY date_trunc('minute', ticktime)
ORDER BY ticktime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) t USING (ticktime)
WHERE time_series.ticktime::time >= '01:09 am'::time
AND time_series.ticktime::time < '2:01 am'::time
ORDER BY 1 ;