USE High_School_Public_Results_2023;

-- This is a SQL query to retrieve all columns from the Final_Results table
-- where the Sitting_Number is 1457730
SELECT *
FROM Final_Results
WHERE Sitting_Number = 1457735;

-- عدد طلاب المدرسة
SELECT DISTINCT COUNT(Sitting_Number) AS 'Numbers Of Students'
FROM Final_Results

-- عدد الطلاب الناجحين 
SELECT COUNT(Student_Status) AS 'The number of successful students'
FROM Final_Results
WHERE Student_Status = N'ناجح'

-- عدد الطلاب دور ثاني
SELECT COUNT(Student_Status) AS 'The number of second round students'
FROM Final_Results
WHERE Student_Status = N'دور ثاني'

-- عدد الطلاب الراسبيين
SELECT COUNT(Student_Status) AS 'The number of repeat students'
FROM Final_Results
WHERE Student_Status = N'راسب'

-- عدد الطلاب الذين حصلوا علي نسبة < %90
SELECT count(Sitting_Number) 'The number of students who achieved a score of > 90%'
FROM Final_Results
WHERE Percentage >= '90.00%'

-- عدد الطلاب الذين حصلوا علي نسبة ما بين %70 الي %90
SELECT count(Sitting_Number) 'The number of students who got between 70% and 90%'
FROM Final_Results
WHERE Percentage >= '70.00%'
	AND Percentage < '90.00%'

-- عدد الطلاب الذين حصلوا علي نسبة أقل %50 
SELECT count(Sitting_Number) 'The number of students who scored less than 50%'
FROM Final_Results
WHERE Percentage <= '50.00%'

-- عدد الطلاب في كل شعبة
-- علمي علوم
SELECT COUNT(Branch) AS 'Scientific Division of Science'
	--,CAST(COUNT(Sitting_Number) * 100 / 215 AS DECIMAL(10, 3)) AS 'Sitting_Number Ratio'
FROM Final_Results
WHERE Branch = N'عملي علوم'

-- علمي رياضة
SELECT COUNT(Branch) AS 'Scientific Division of Math'
FROM Final_Results
WHERE Branch = N'عملي رياضة'

-- أدبي
SELECT COUNT(Branch) AS 'Scientific Division of Math'
FROM Final_Results
WHERE Branch = N'أدبي'


-- متوسط المجاميع	
SELECT CONCAT (
		CAST(AVG(Total) * 100 / 410 AS DECIMAL(10, 2))
		,'%'
		) AS 'AVG Results'
FROM Final_Results


--عدد الناجحين في كل مادة 















-- This is a SQL stored procedure named Student_Result
-- It takes an input parameter @ID_Num and retrieves all columns from the Final_Results table
-- where the Sitting_Number matches the @ID_Num parameter
CREATE PROCEDURE Student_Result (@ID_Num INT)
AS
BEGIN
    -- This is a SQL query inside the stored procedure
    -- It retrieves all columns from the Final_Results table
    -- where the Sitting_Number matches the @ID_Num parameter
    SELECT *
    FROM Final_Results
    WHERE Sitting_Number = @ID_Num;
END;

-- This is the execution of the Student_Result stored procedure with parameter value 1457730
-- It will retrieve student results for the sitting number 1457730
EXEC Student_Result 1457730;

-- return the top 10 most Percentage 
SELECT TOP 10 *
FROM Final_Results
ORDER BY Percentage DESC



CREATE PROCEDURE Top_Percentage
    @Top_Num INT,
    @BranchList NVARCHAR(MAX) = NULL
AS
BEGIN
    -- If @BranchList is NULL, use the default value 'عملي علوم'
    SET @BranchList = ISNULL(@BranchList, N'عملي علوم');

    -- Create a table variable to hold the branch values
    DECLARE @Branches TABLE (Branch NVARCHAR(50));

    -- Insert the split branch values into the table variable
    INSERT INTO @Branches (Branch)
    SELECT value
    FROM STRING_SPLIT(@BranchList, ',');

    -- Retrieve the top @Top_Num rows from the Final_Results table
    -- for the specified branch values
    SELECT TOP (@Top_Num) *
    FROM Final_Results
    WHERE Branch IN (SELECT Branch FROM @Branches)
    ORDER BY Percentage DESC;
END;


-- Retrieve top 5 results for branches 'عملي علوم' and 'عملي رياضة'
EXEC Top_Percentage @Top_Num = 10, @BranchList = N'عملي علوم,عملي رياضة';

EXEC Top_Percentage @Top_Num = 10

EXEC Top_Percentage 

