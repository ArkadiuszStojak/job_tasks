
------------------------------------------------------------------------------------------------------------
-- Exercise 4)

/*
There is a table which is designed to contain very basic information about some kind of entries and its implementation is not yet finished. 
The deleted_at and deleted_by represents when and who marked the entry as deleted.
However the logic which enforces the field deleted_by to be filled when the deleted_at column gets a timestamp value is not yet in place.

Task: Create this missing logic to enforce the above mentioned integrity.
*/

IF OBJECT_ID('tempdb..#exercise_4') IS NOT NULL DROP TABLE #exercise_4
create table #exercise_4 (  id int not null primary key
                          , entry_name varchar(60) not null
                          , related_to int null
                          , started_at date not null
                          , deleted_at datetime null
                          , deleted_by int null
                         )
						 
						 
/*  
Hi, this one is not clear to me, so I have a couple of questions. 

My first thought was to use a trigger. However, in the sample script provided, there is a temporary table defined. So the trigger is no option.
If the logic needs to be just a script, I would like to know how I should update the deleted_by column. As it's an integer, the SYSTEM_USER is no option. 
Any clarification would be appreciated. 


*/