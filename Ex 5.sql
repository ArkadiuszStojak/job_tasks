------------------------------------------------------------------------------------------------------------
-- Exercise 5)

/*
Task:   Create a logic which checks if there are records with entry_long_name null/empty or equal to entry_name.
        Throw an error if it finds matching records.
        The following information also has to be printed out in case of the error:
            id, entry_name, entry_long_name, home_zip, home_city and the exact reason why the record is in the list (empty or equal)
*/

IF OBJECT_ID('tempdb..#exercise_5') IS NOT NULL DROP TABLE #exercise_5
create table #exercise_5 (  id int not null primary key
                          , entry_name varchar(60) not null
                          , related_to int null
                          , entry_long_name varchar(250) null
                          , home_zip int not null
                          , home_city varchar(250) null
                         )

Create procedure dbo.CheckEntityLongName
AS 
DECLARE @Counter INT , @MaxId INT, 
        @EntityLongName varchar(250),
		@EntityName varchar(60), 
		@HomeZip INT,  
		@HomeCity varchar(250)

SELECT @Counter = min(Id) , @MaxId = max(Id) 
FROM #exercise_5
 
WHILE(@Counter IS NOT NULL
      AND @Counter <= @MaxId)
BEGIN
   SELECT @EntityLongName = entry_long_name, @EntityName = entry_name, @HomeCity = home_city, @HomeZip = home_zip
   FROM #exercise_5 WHERE Id = @Counter
		

	IF @EntityLongName IS NULL 
	BEGIN 
	PRINT CAST(@Counter AS Varchar) + ', ' + @EntityName + ', ' + isnull( @EntityLongName,'null')+ ', ' + CAST(@HomeZip AS VARCHAR)+ ', ' + @HomeCity + ', ' +  'Entity Long Name IS NULL' 
	RAISERROR (N'Entity Long Name IS NULL', -- Message text.  
           10, -- Severity,  
           1 -- State,  
		   );
	END

IF @EntityLongName = @EntityName 
BEGIN 

	PRINT CAST(@Counter AS Varchar) + ', ' + @EntityName + ', ' + @EntityLongName + ', ' + CAST(@HomeZip AS VARCHAR)+ ', ' + @HomeCity + ', ' + 'Entity Long Name  is equal to Entity Name' 
	RAISERROR (N'Entity Long Name is equal to Entity Name', -- Message text.  
           10, -- Severity,  
           1 -- State,  
		   );

END 

IF @EntityLongName = ''

 BEGIN 

	PRINT CAST(@Counter AS Varchar) + ', ' + @EntityName + ', ' +isnull( @EntityLongName,'null') + ', ' + CAST(@HomeZip AS VARCHAR)+ ', ' + @HomeCity + ', ' + 'Entity Long Name IS empty' 
	RAISERROR (N'Entity Long Name is empty', -- Message text.  
           10, -- Severity,  
           1 -- State,  
		   );

END 
   SET @Counter  = @Counter  + 1        
END


exec dbo.CheckEntityLongName 


