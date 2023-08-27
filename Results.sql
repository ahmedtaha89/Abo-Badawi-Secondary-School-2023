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

-- عدد الطلاب في كل شعبة (USING GROUP BY)
SELECT Branch
	,COUNT(Branch) 'The number of students in each division'
FROM Final_Results
GROUP BY Branch
ORDER BY Branch DESC

-- متوسط المجاميع	
SELECT ROUND(AVG(Percentage), 2) AS 'AVG Results'
FROM Final_Results

-- This Query To convert Percentage To Float Use Removeing '%'
UPDATE Final_Results
SET Percentage = REPLACE(Percentage, '%', '')


-- MAX()
SELECT Sitting_Number , NAME , MAX(Percentage)  'MAX Percentage' 
FROM Final_Results
GROUP BY Sitting_Number , Percentage , NAME
ORDER BY Percentage DESC


--عدد الناجحين في كل مادة 
-- اللغة العربية
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Arabic'
FROM Final_Results
WHERE Arabic >= 40

-- اللغة الأنجليزية
SELECT COUNT(Sitting_Number) AS 'The number of successful students in English'
FROM Final_Results
WHERE English >= 30

--اللغة الفرنسية 
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Second Foreign Language2'
FROM Final_Results
WHERE Second_Foreign_Language2 >= 30

-- الكيمياء
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Chemistry'
FROM Final_Results
WHERE Chemistry >= 30

--الفيزياء
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Physics'
FROM Final_Results
WHERE Physics >= 30

--الجيولوجيا وعلوم البيئة 
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Geology'
FROM Final_Results
WHERE Geology >= 30

-- الأحياء
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Biology'
FROM Final_Results
WHERE Biology >= 30

-- الرياضيات التطبيقية
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Applied Mathematics'
FROM Final_Results
WHERE Applied_Mathematics >= 30

-- الرياضيات التطبيقية
SELECT COUNT(Sitting_Number) AS 'The number of successful students in Total Pure Mathematics '
FROM Final_Results
WHERE Total_Pure_Mathematics >= 30

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

-- This is the execution of the Student_Result stored procedure with parameter value 1457734
-- It will retrieve student results for the sitting number 1457734
EXEC Student_Result 1457734;

-- return the top 10 most Percentage 
SELECT TOP 10 *
FROM Final_Results
ORDER BY Percentage DESC

CREATE PROCEDURE Top_Percentage @Top_Num INT
	,@BranchList NVARCHAR(MAX) = NULL
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
	WHERE Branch IN (
			SELECT Branch
			FROM @Branches
			)
	ORDER BY Percentage DESC;
END;

-- Retrieve top 5 results for branches 'عملي علوم' and 'عملي رياضة'
EXEC Top_Percentage @Top_Num = 10
	,@BranchList = N'عملي علوم,عملي رياضة';

EXEC Top_Percentage @Top_Num = 15

EXEC Top_Percentage


-- 
ALTER TABLE Final_Results
ADD rank_no  INT  NULL ;


UPDATE Final_Results
SET rank_no = (SELECT RANK() OVER (ORDER BY Percentage desc))



WITH RankedResults AS (
    SELECT
        Sitting_Number,
        RANK() OVER (ORDER BY Percentage asc) AS Student_rank
    FROM Final_Results
)
UPDATE Final_Results
SET rank_no = rr.Student_rank
FROM RankedResults rr
WHERE Final_Results.Sitting_Number = rr.Sitting_Number;

select * from Final_Results 
order by rank_no asc