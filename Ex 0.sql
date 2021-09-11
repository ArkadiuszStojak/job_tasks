------------------------------------------------------------------------------------------------------------
--Exercise 0)

--C. Create a script to update the max(CurrentWeight) record in that way that the select from the step 2 do not return back any rows after the update (sum(CurrentWeight) must be 100)
		BEGIN TRAN
		UPDATE a 
		SET CurrentWeight = 100 - TotalWeight + CurrentWeight
		FROM 
		(
		SELECT 
		UserID, 
		AssetType,
		CurrentWeight,  
		ROW_NUMBER() OVER (PARTITION BY UserID, AssetType ORDER BY CurrentWeight desc) Rnk, 
		SUM(CurrentWeight) OVER (PARTITION BY UserID) TotalWeight
		from tempdb.dbo.Asset 
		) AS a 
		WHERE  Rnk = 1 
		COMMIT TRAN
		
		
/* D. Delete the duplicated records from the table by keeping the max(CurrentWeight) record to be able to execute the following script:
		ALTER TABLE tempdb.dbo.Asset
		ADD CONSTRAINT PK_Asset PRIMARY KEY CLUSTERED (UserId) */
		
		BEGIN TRAN

		;WITH cte AS 
		(
		SELECT 
		UserID, 
		ROW_NUMBER() OVER (PARTITION BY UserID ORDER BY CurrentWeight desc) Rnk
		from tempdb.dbo.Asset 
		) 
		DELETE 
		FROM cte 
		WHERE Rnk <> 1
		COMMIT TRAN
