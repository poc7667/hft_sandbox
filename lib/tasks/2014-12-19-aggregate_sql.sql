SELECT 
       t.high,
       t.low
FROM 
(

  SELECT generate_series(
    date_trunc('second', min(ticktime)) ,
    date_trunc('second', max(ticktime)) ,
    interval '1 sec'
  ) FROM czces  AS g (time)
 
  LEFT JOIN
  (
    SELECT 
      date_trunc('second', ticktime) AS time ,
      max(last_price) OVER w AS high ,
      min(last_price) OVER w AS low 
   FROM czces
   WHERE product_type ='TA' AND contract_month = '2014-08-01 00:00:00'::TIMESTAMP 
     WINDOW w AS (
      PARTITION BY date_trunc('second', ticktime)
      ORDER BY ticktime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      )
  ) t USING (time)



  ORDER BY 1 
) AS t ;
;;;



SELECT 
       time_series.ticktime,
       t.high,
       t.low
FROM 
(
  SELECT generate_series
  (
    -- start from 2014-01-01
    min(ticktime)::timestamp,
    -- end at 2014-12-20
    max(ticktime)::timestamp,
     '1 minute'::interval
  ) AS ticktime FROM czces  
  where ticktime::time >= '01:09 am'::time AND ticktime::time < '2:01 am'::time
) time_series
 
LEFT JOIN
(
  SELECT 
    date_trunc('second', ticktime) AS ticktime ,
    max(last_price) OVER w AS high ,
    min(last_price) OVER w AS low 
  FROM czces
  WHERE product_type ='TA' AND contract_month = '2014-08-01 00:00:00'::TIMESTAMP 
     WINDOW w AS 
     (
      PARTITION BY date_trunc('second', ticktime)
      ORDER BY ticktime ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
      )
) t USING (ticktime)

ORDER BY 1 
;


with filled_interval as (
  select day, 0 as blank_count from
    generate_series('2014-01-01 00:00'::timestamptz, current_date::timestamptz, '1 day') 
      as day
  select interval from generate_series(
    date_trunc('second', min(ticktime)) ,
    date_trunc('second', max(ticktime)) ,
    interval '1 sec'
  )    
),


with filled_interval as (
  SELECT interval FROM 
),


  SELECT generate_series(
    date_trunc('second', min(ticktime)) ,
    date_trunc('second', max(ticktime)) ,
    interval '1 sec'
  ) AS interval
  FROM czces ;



-- sample 2


SELECT 
   time_series.ticktime,
   t.high,
   t.low,
   t.open,
   t.close,
   t.contract_month,
   t.product_type,
   t.volume
FROM
(
  SELECT DISTINCT ON (1) 
   generate_series 
    (min(ticktime)::TIMESTAMP, max(ticktime)::TIMESTAMP, '1 minute'::interval)
     AS ticktime
   FROM czces
   WHERE ticktime::time >= '01:09 am'::time
     AND ticktime::time < '2:01 am'::time     
) time_series
LEFT JOIN
(
  SELECT  DISTINCT ON (1)
      date_trunc('minute', ticktime) AS ticktime ,
      first_value(last_price) OVER w AS OPEN,
      max(last_price) OVER w AS high ,
      min(last_price) OVER w AS low,
      last_value(last_price) OVER w AS CLOSE,
      sum(last_volume > 5) OVER w AS volume,
      product_type,
      ticktime,
      contract_month
 FROM czces
 WHERE product_type ='TA'
   AND contract_month = '2014-08-01 00:00:00'::TIMESTAMP 
  WINDOW w AS 
  (
    PARTITION BY date_trunc('minute', ticktime)
    ORDER BY ticktime 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  )
) t USING (ticktime)
ORDER BY 1 ;


-- aggregate without condition
-- The product SR is most popular
-- where ticktime::time >= '00:59 am'::time AND ticktime::time < '2:01 am'::time


 SELECT
      ticktime,
      last_price,
      last_volume,
      product_type,
      contract_month
 FROM czces
 WHERE product_type ='SR'
   AND contract_month = '2014-05-01 00:00:00'::TIMESTAMP 
   AND ticktime >= '2014-02-07 01:02:00'::TIMESTAMP AND ticktime < '2014-02-07 01:03:00'::TIMESTAMP
 ;


-- Add conditional than aggreate value greater than 

  SELECT 
    foo.ticktime,
    foo.open,
    foo.high,
    foo.low,
    foo.close,
    foo.volume
  FROM 
  (
  SELECT  DISTINCT ON (1)
      date_trunc('minute', czces.ticktime) AS ticktime ,
      first_value(last_price) OVER w AS open,
      max(last_price) OVER w AS high ,
      min(last_price) OVER w AS low,
      last_value(last_price) OVER w AS close,
      sum(last_volume ) OVER w AS volume,
      product_type,
      contract_month
 FROM czces
 WHERE product_type ='SR'
   AND contract_month = '2014-05-01 00:00:00'::TIMESTAMP 
  WINDOW w AS 
  (
    PARTITION BY date_trunc('minute', ticktime)
    ORDER BY ticktime 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) 
  
  )AS foo
  
  WHERE foo.volume > 0
  LIMIT 100
  ;


-- raw query

  SELECT t.volume
  FROM 
  (
  SELECT  DISTINCT ON (1)
      date_trunc('minute', ticktime) AS ticktime ,
      first_value(last_price) OVER w AS OPEN,
      max(last_price) OVER w AS high ,
      min(last_price) OVER w AS low,
      last_value(last_price) OVER w AS CLOSE,
      sum(last_volume) OVER w AS volume,
      product_type,
      ticktime,
      contract_month
 FROM czces
 WHERE product_type ='TA'
   AND contract_month = '2014-08-01 00:00:00'::TIMESTAMP 
  WINDOW w AS 
  (
    PARTITION BY date_trunc('minute', ticktime)
    ORDER BY ticktime 
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ) AS t 
  ) ;