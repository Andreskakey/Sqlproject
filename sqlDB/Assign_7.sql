--Kakey Fon
--CISC 3810
--assignment 7
--http://www.sci.brooklyn.cuny.edu/~gordon/assets/answers.txt
BEGIN;
DROP TABLE IF EXISTS census CASCADE;
DROP TABLE IF EXISTS new_census CASCADE;
DROP TABLE IF EXISTS Demo_Dist CASCADE;
DROP TABLE IF EXISTS OpZip CASCADE;
--DROP TABLE IF EXISTS Female_Opt CASCADE;

CREATE TABLE  census( 

Zip_Code INTEGER,
Total_Population INTEGER,
Median_Age FLOAT,
Total_Males INTEGER,
Total_Female INTEGER,
Total__Household INTEGER,
AVG_House_Size FLOAT
);
\COPY census FROM 'C:/Users/Public/Documents/census.csv' DELIMITER ',' CSV;
 
CREATE TABLE new_census AS (
-- There are three ways of doing this one without precision and one short or long way of calculating the percentage of male similar method instead of Total_Males it's will be Total_Female
-- Without precision using float.
--SELECT Median_Age, CASE WHEN Total_Males = 0 THEN Total_Population 
		--ELSE ((Total_Males::FLOAT / Total_Population::FLOAT)) END 
			--AS perct_Males, AVG_House_Size FROM census 

--With precision using round and decimal, somehow sql doesn't accept float with round.
	SELECT Zip_Code, Total_Population, Median_Age, 
		(CASE WHEN  Total_Males = 0 THEN Total_Population 
			ELSE (Total_Males::DECIMAL / Total_Population::DECIMAL) END ::NUMERIC(10,3)) 
				AS perct_Males , AVG_House_Size FROM census

--Long way to calculate the percentage of male avoiding the zero division.
--	SELECT Median_Age,
		--((CASE WHEN  Total_Males = 0 THEN 1 ELSE Total_Males::DECIMAL END) / 
		--(CASE WHEN Total_Population = 0 THEN 1 ELSE Total_Population::DECIMAL END)::NUMERIC(10,3))::NUMERIC(10,3) 
				--AS perct_Males, AVG_House_Size FROM census 
);

CREATE TABLE OpZip AS (
SELECT Median_Age, perct_Males, AVG_House_Size from new_census WHERE Zip_Code ='93591 '
);
-- psql -d finalassign -U postgres -f Assign_7.sql -c "SELECT * FROM Demo_Dist" > MyOutput2.txt
CREATE TABLE Demo_Dist AS (
	SELECT new_census.Zip_Code,new_census.Total_Population ,new_census.Median_Age, new_census.perct_Males, new_census.AVG_House_Size, 
	(SQRT(POWER (OpZip.Median_Age::FLOAT - new_census.Median_Age ::FLOAT,2 )+ 
	POWER(OpZip.perct_Males ::FLOAT - new_census.perct_Males ::FLOAT,2)+ 
	POWER (OpZip.AVG_House_Size ::FLOAT -new_census.AVG_House_Size::FLOAT,2 ))::NUMERIC(10,3)) 
		AS Dist 
			FROM OpZip 
				CROSS JOIN new_census 
					ORDER BY Dist
						ASC LIMIT 11
);
/*
CREATE TEMPORARY TABLE Female_Opt AS (
SELECT Zip_Code, Median_Age, 
		(CASE WHEN  Total_Female = 0 THEN Total_Population 
			ELSE (Total_Female::DECIMAL / Total_Population::DECIMAL) END ::NUMERIC(10,3)) 
				AS perct_Female, AVG_House_Size FROM census
);
*/
WITH Dist AS (

	SELECT new_census.Zip_Code,new_census.Total_Population ,new_census.Median_Age, new_census.perct_Males, new_census.AVG_House_Size, 
	(SQRT(POWER (OpZip.Median_Age::FLOAT - new_census.Median_Age ::FLOAT,2 )+ 
	POWER(OpZip.perct_Males ::FLOAT - new_census.perct_Males ::FLOAT,2)+ 
	POWER (OpZip.AVG_House_Size ::FLOAT -new_census.AVG_House_Size::FLOAT,2 ))::NUMERIC(10,3)) 
		AS Dist 
			FROM OpZip 
				CROSS JOIN new_census 
					ORDER BY Dist
						ASC LIMIT 11
)
SELECT * FROM Dist;

COMMIT;
ANALYZE census;
ANALYZE new_census;
ANALYZE Demo_Dist;
ANALYZE OpZip;
--ANALYZE Female_Opt;