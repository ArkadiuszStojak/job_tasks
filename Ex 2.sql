------------------------------------------------------------------------------------------------------------
-- Exercise 2)

/*
Implement a table in which the records form a parent-child like hierarchy. 
Make sure the integrity of the hierarchy is enforced.
Provide sample data and write a query which lists a given record and all its parents. 
*/

CREATE TABLE ParentChildSample 
(
	UserID INT PRIMARY KEY,
	ManagerID INT REFERENCES ParentChildSample(UserID), 
	UserName nvarchar(50)
	); 
	GO

	--Populate table
	DECLARE @maxCount INT,
        @count INT,
        @parentId INT;        
SET @maxCount = 20;        
SET @count = 1;

WHILE @count <= @maxCount
BEGIN
    If @count = 1
        SET @parentId = NULL;
    ELSE
        SET @parentId = @count - 1;
        
    INSERT INTO ParentChildSample(UserID, UserName, ManagerID)
        VALUES (@count, 'User_' + CONVERT(VARCHAR(400), @count), @parentId)
    SET @count = @count + 1;
END

SELECT * FROM ParentChildSample

/*row possible childs in a column*/
;WITH Hierarchy(UserID, UserName, ManagerID, Childs)
AS
(
    SELECT UserID, UserName, ManagerID, CAST('' AS VARCHAR(MAX))
        FROM ParentChildSample AS LastGeneration
        WHERE UserID NOT IN (SELECT COALESCE(ManagerID, 0) FROM ParentChildSample)     
    UNION ALL
    SELECT PrevGeneration.UserID, PrevGeneration.UserName, PrevGeneration.ManagerID,
    CAST(CASE WHEN Child.Childs = ''

        THEN(CAST(Child.UserID AS VARCHAR(MAX)))
        ELSE(Child.Childs + '.' + CAST(Child.UserID AS VARCHAR(MAX)))
    END AS VARCHAR(MAX))
        FROM ParentChildSample AS PrevGeneration
        INNER JOIN Hierarchy AS Child ON PrevGeneration.UserID = Child.ManagerID    
)
SELECT *
    FROM Hierarchy
	--WHERE USERID = 12
OPTION(MAXRECURSION 32767)

