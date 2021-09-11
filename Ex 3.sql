------------------------------------------------------------------------------------------------------------
-- Exercise 3)

/*
There is a table which contains the last 12 monthly income figures of several shops.
Write a query which the lists the highest income value within the last 12 months for each shops.
Please note that shops could have been opened/closed during the last twelve months either temporarily or permanently.
*/

-- table schema:
IF OBJECT_ID('tempdb..#exercise_3') IS NOT NULL DROP TABLE #exercise_3
create table #exercise_3 (  shop_id int not null primary key
                          , m12 decimal(19,3) null
                          , m11 decimal(19,3) null
                          , m10 decimal(19,3) null
                          , m09 decimal(19,3) null
                          , m08 decimal(19,3) null
                          , m07 decimal(19,3) null
                          , m06 decimal(19,3) null
                          , m05 decimal(19,3) null
                          , m04 decimal(19,3) null
                          , m03 decimal(19,3) null
                          , m02 decimal(19,3) null
                          , m01 decimal(19,3) null
                         )
						 
 SELECT shop_id,
  (SELECT Max(val) 
   FROM (VALUES (m01), (m02), (m03),(m04),(m05),(m06),(m07), (m08), (m09),(m10),(m11),(m12)) AS value(val)) as [MaxValue]
FROM #exercise_3
