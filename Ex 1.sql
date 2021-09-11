
------------------------------------------------------------------------------------------------------------
-- Exercise 1)
/*
There is a table which contains daily snapshots of suggested transaction groups for portfolios ("sell shareA and buy shareB").
One transaction group is defined by the generation_date, portfolio_id, trigger_id and package_id columns and represents a list of sell and buy actions.
Triggers define the initial reason for the transaction group.
Portfolio_id, trigger_id, is_sell and instrument_id values have the same meaning across days - i.e. the same trigger_id means the same reason on day0 and on day1 also.
Be aware that the same package_id can represent different package from day to day.

Task:
    Identify those transaction groups which are not new today (20191218) because they were already existing on the previous day.

Example for matching packages:
    generation_date     portfolio_id    trigger_id  package_id  is_sell     instrument_id 
    '20191218'          10012           123            1          1             112233
    '20191218'          10012           123            1          0             112234
    '20191216'          10012           123            7          1             112233
    '20191216'          10012           123            7          0             112234
These records represent the same transaction group so this is a match.

Example for NOT matching packages:
    generation_date     portfolio_id    trigger_id  package_id  is_sell     instrument_id 
    '20191218'          10012           123            1          1             112233
    '20191218'          10012           123            1          0             112234

    '20191216'          10012           123            5          1             112233
    '20191216'          10012           123            5          0             112235

    '20191216'          10012           123            8          1             112233
    '20191216'          10012           123            8          0             112234
    '20191216'          10012           123            8          0             112238
These records represent different transaction groups so there is no match beteeen them. 
(At least one leg transaction of the package has a different sell_instrument or buy_instrument.)

*/



drop table if exists  #transactions
create table #transactions ( generation_date date not null, portfolio_id int not null, trigger_id int not null, package_id tinyint not null, is_sell bit not null, instrument_id int not null
                            , primary key clustered (generation_date, portfolio_id, trigger_id, package_id, is_sell, instrument_id)
                           )


-- some sample data
insert into #transactions
values ('20191218', 10012, 123, 1, 1, 112233)
     , ('20191218', 10012, 123, 1, 0, 112234)
     , ('20191218', 10012, 123, 2, 1, 112233)
     , ('20191218', 10012, 123, 2, 0, 112238)
     , ('20191218', 10012, 127, 1, 1, 445566)
     , ('20191218', 10012, 127, 1, 0, 445567)
     , ('20191218', 10012, 127, 2, 1, 112233)
     , ('20191218', 10012, 127, 2, 0, 445567)
     , ('20191218', 10012, 127, 3, 1, 112266)
     , ('20191218', 10012, 127, 3, 1, 112262)
     , ('20191218', 10012, 127, 3, 0, 445567)
     , ('20191218', 10012, 109, 1, 0, 447788)
     , ('20191206', 10012, 127, 1, 1, 112233)
     , ('20191206', 10012, 127, 1, 0, 445567)

-- T-SQL code

DECLARE @Date as date = '20191218'

;with matches as
(
	 SELECT 
		t1.generation_date, t1.portfolio_id, t1.trigger_id, t1.package_id, t1.cnt, t2.cnt as cnt2 
	-- t1.generation_date, t1.portfolio_id, t1.trigger_id,  t1.cnt , Count(*), t2.cnt, t1.package_id, t2.generation_date
	 -- t1.generation_date, t1.portfolio_id, t1.trigger_id, t1.is_sell, t1.instrument_id,t1.package_id, MatchResult, t1.cnt
	 FROM 
	 (
	 SELECT generation_date, portfolio_id, trigger_id, is_sell, instrument_id,package_id,  Count(*) OVER (partition by generation_date, package_id)  cnt, 'Not new today' as MatchResult 
	 FROM #transactions 
	 WHERE generation_date = @Date
	 ) as t1 
	 INNER JOIN 
	 ( 
	 	 SELECT generation_date, portfolio_id, trigger_id, is_sell, instrument_id, Count(*) OVER (partition by generation_date, package_id)  cnt
	 FROM #transactions 
	 WHERE generation_date <> @Date
	 ) as t2 
	 ON t1.instrument_id = t2.instrument_id AND t1.is_sell = t2.is_sell AND t1.portfolio_id = t2.portfolio_id AND t1.trigger_id = t2.trigger_id 
	 GROUP BY t1.generation_date, t1.portfolio_id, t1.trigger_id, t1.package_id, t1.cnt, t2.cnt
	 HAVING Count(*) = t2.cnt
) 
SELECT t.* 
FROM matches m
	INNER JOIN 
	#transactions t ON t.generation_date = m.generation_date and t.package_id = m.package_id and t.portfolio_id = m.portfolio_id and t.trigger_id = m.trigger_id
