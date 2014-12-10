SELECT
      cast(ticktime as timestamp(1)) AS ticktime,
      max(bid_price) as price,
      max(bid_volume) as volume,
      max(product_type) as product_type
      From  czces
      WHERE  ticktime >=  '2014-02-09 00:00:00'::timestamp
      AND  ticktime <  '2014-02-11 00:00:00'::timestamp
      AND  product_type ='RS'
      Group BY 1
      ORDER BY 1
      limit 1000;

-- not work
SELECT
  TIMESTAMP WITH TIME ZONE 'epoch' + INTERVAL '1 second' * round((extract('epoch' from ticktime) / 300) * 300)
  as ticktime,
  max(bid_price) as price,
  max(bid_volume) as volume,
  max(product_type) as product_type
  From  czces
  WHERE  ticktime >=  '2014-02-09 00:00:00'::timestamp
  AND  ticktime <  '2014-02-11 00:00:00'::timestamp
  GROUP BY round(extract('epoch' from ticktime) / 300), ticktime
  ORDER BY 1
  limit 1000;


week

SELECT date_trunc('hour', ticktime) AS hourstamp,
      max(bid_price) as high,
      min(bid_price) as low,
      sum(bid_volume) as volume,
      max(product_type) as product_type
FROM   czces
WHERE  ticktime >=  '2014-02-11 00:00:00'::timestamp
AND  ticktime <  '2014-02-28 00:00:00'::timestamp
AND  product_type ='RS'
GROUP  BY 1
ORDER  BY hourstamp ASC
limit 1000;


SELECT date_trunc('hour', ticktime) AS hourstamp,
      (extract(minute FROM ticktime)::int / 5) AS minute_slot,
      max(bid_price) as high,
      min(bid_price) as low,
      sum(bid_volume) as volume,
      max(product_type) as product_type
FROM   czces
WHERE  ticktime >=  '2014-02-11 00:00:00'::timestamp
AND  ticktime <  '2014-02-15 00:00:00'::timestamp
AND  product_type ='RS'
GROUP  BY 1, 2
ORDER  BY 1, 2
limit 1000;


WITH x AS (
    SELECT t1, t1 + interval '5min' AS t2
    FROM   generate_series('2014-02-11 0:0'::timestamp
                          ,'2014-02-15 23:55'::timestamp, '5min') AS t1
    )
SELECT DISTINCT
      x.t1
      ,min(bid_price) OVER w
      ,max(bid_price) OVER w
      ,first_value(bid_price) OVER w
      ,last_value(bid_price) OVER w
FROM   x
JOIN   czces y ON  y.t >= x.t1 -- use LEFT JOIN to include empty intervals
                AND y.t <  x.t2 -- don't use BETWEEN
WINDOW w AS (PARTITION BY x.t1)
ORDER  BY x.t1;