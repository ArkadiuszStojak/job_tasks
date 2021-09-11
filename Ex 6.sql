------------------------------------------------------------------------------------------------------------
-- Exercise 6)

/*
Task:   Create a logic which results the following:
            The  current rating, the date since when is it applied and what was the last movement (increase/decrease) per instrument

        Something similar should be the result:     Instrument_id | rating | valid_since| last_change
*/


-- input table
IF OBJECT_ID('tempdb..#exercise_6') IS NOT NULL DROP TABLE #exercise_6
create table #exercise_6 (  load_date date not null
                          , instrument_id varchar(60) not null
                          , rating tinyint not null
                          , primary key (load_date, instrument_id)
                         )

-- some examples
insert into #exercise_6
values ('20191201', 100123, 3)
     , ('20191202', 100123, 3)
     , ('20191205', 100123, 4)
     , ('20191202', 100125, 6)
     , ('20191203', 100125, 5)
     , ('20191205', 100125, 5)
     , ('20191202', 100128, 4)
     , ('20191203', 100128, 4)
     , ('20191205', 100128, 4)



 SELECT Instrument_id, rating, valid_since, rating -ISNULL(PrevRating,0) as last_change
	 FROM 
	 (
	 Select Instrument_id, rating, load_date as valid_since, 
	 LEAD(rating) OVER (Partition by Instrument_id ORDER BY load_date desc) as PrevRating, 
	 ROW_NUMBER() OVER (Partition BY Instrument_id ORDER BY load_date desc) as rowNbr
	 from #exercise_6
	 ) as t 
	 WHERE rowNbr = 1 
	 
