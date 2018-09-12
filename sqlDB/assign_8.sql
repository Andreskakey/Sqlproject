--Kakey Fon
--CISC 3810
--Assignment 8 Extra
--http://www.sci.brooklyn.cuny.edu/~gordon/assets/answers_8.txt

BEGIN;
DROP TABLE IF EXISTS risk_factors CASCADE;
DROP TABLE IF EXISTS Count_N CASCADE;
DROP TABLE IF EXISTS sum_count CASCADE;
DROP TABLE IF EXISTS risk_scores CASCADE;

CREATE TABLE  risk_factors( 
id SERIAL NOT NULL PRIMARY KEY,
Management_risk TEXT NOT NULL,
Industry_risk TEXT NOT NULL ,
Financial_flex TEXT NOT NULL ,
Credib TEXT NOT NULL ,
Competit TEXT NOT NULL ,
Op_risk TEXT NOT NULL  ,
class VARCHAR(2) NOT NULL 

);
\COPY risk_factors FROM 'C:/Users/Public/Documents/ids.csv' DELIMITER ',' CSV;                                                                                                                                              

CREATE TABLE Count_N AS (
SELECT id,
    COUNT(*) total,
    SUM(CASE WHEN Management_risk = 'N' THEN 1 ELSE 0 END) AS Man,
    SUM(CASE WHEN Industry_risk = 'N' THEN 1 ELSE 0 END) AS Ind,
    SUM(CASE WHEN Financial_flex = 'N' THEN 1 ELSE 0 END) AS Fin,
	SUM(CASE WHEN Credib = 'N' THEN 1 ELSE 0 END) AS Cred,
	SUM(CASE WHEN Competit = 'N' THEN 1 ELSE 0 END) AS Comp,
	SUM(CASE WHEN Op_risk = 'N' THEN 1 ELSE 0 END) AS OpR, class
		FROM risk_factors
			GROUP BY id, class ORDER BY id ASC 
);

/*
 WITH SCOUNT AS (
SELECT id ,SUM(Exec1+Exec2+Exec3+Exec4+Exec5+Exec6) AS score,class FROM Count_N GROUP BY id, class ORDER BY id ASC
 )
 SELECT * FROM SCOUNT;
*/

CREATE TABLE sum_count AS
(
SELECT id ,SUM(Man + Ind + Fin + Cred + Comp + OpR) AS score, class FROM Count_N GROUP BY id, class ORDER BY id ASC
);
--Decision Tree part 
CREATE TABLE risk_scores AS(
SELECT id, score, class,
    CASE 
        WHEN 
            score <=2
			THEN 'LOW'
        WHEN score <4
            THEN 'MEDIUM'
        WHEN score <5 
            THEN 'MEDIUM_HIGH'
		ELSE 
			'HIGH'
        END AS Risk_Score	
FROM sum_count 
);

--Report the number of companies at each risk level from the bankrupt group. 
WITH Bankrupt_Comp AS (
SELECT risk_score, COUNT (*) AS Num_Companies_B FROM risk_scores WHERE class = 'B' GROUP BY risk_score ORDER BY Num_Companies_B DESC
)
SELECT * FROM Bankrupt_Comp;

--Report the number of companies at each risk level from the non-bankrupt group.
WITH Non_Bankrupt_Comp AS (
SELECT risk_score, COUNT (*) AS Num_Companies_NB FROM risk_scores WHERE class = 'NB' GROUP BY risk_score ORDER BY Num_Companies_NB DESC
)
SELECT * FROM Non_Bankrupt_Comp;

--Make a report of currently operating companies that are at a risk level of 'Medium' or higher.
--OR MEDIUM
WITH No_Bankrupt_At_Medium AS (
select * from risk_scores where class = 'NB' AND Risk_score = 'MEDIUM'
)
select * FROM No_Bankrupt_At_Medium;
--OR HIGH
WITH No_Bankrupt_At_Medium AS (
select * from risk_scores where class = 'NB' AND Risk_score = 'HIGH'
)
SELECT * FROM No_Bankrupt_At_Medium;



--ALTER TABLE risk_factors ADD COLUMN id SERIAL DEFAULT 0;
COMMIT;
ANALYZE risk_factors;
ANALYZE sum_count;
ANALYZE Count_N;
ANALYZE risk_scores;
