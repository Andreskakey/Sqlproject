--Kakey Fon
--CISC 3810
--assignment 6
--Assignment 5 added some class note
--Assignment 4 update some query 

BEGIN;
SET client_encoding = 'UTF8';
--Already created the database for assignment4 throught postgres
--CREATE DATABASE BigAssignment;
--Updating the table
DROP TABLE IF EXISTS Securities CASCADE;
DROP TABLE IF EXISTS Fundamentals CASCADE;
DROP TABLE IF EXISTS Prices CASCADE;
DROP TABLE IF EXISTS year_end_price CASCADE;
DROP TABLE IF EXISTS Annual_Return CASCADE;
DROP TABLE IF EXISTS top_thirty CASCADE;
DROP TABLE IF EXISTS Year_end CASCADE;
DROP TABLE IF EXISTS NetWorth CASCADE;
DROP TABLE IF EXISTS Comp_NetInc CASCADE;
DROP TABLE IF EXISTS Comp_EarnPerShare CASCADE;
DROP TABLE IF EXISTS Comp_TRevenue CASCADE;
DROP TABLE IF EXISTS Comp_NetWorth CASCADE;
DROP TABLE IF EXISTS Cash_ratio CASCADE;
DROP TABLE IF EXISTS PE CASCADE;
DROP TABLE IF EXISTS Comp_PE CASCADE;
DROP TABLE IF EXISTS MarginGross CASCADE;
DROP TABLE IF EXISTS stock1 CASCADE;
DROP TABLE IF EXISTS stock2 CASCADE;
DROP TABLE IF EXISTS correl CASCADE;
DROP TABLE IF EXISTS invest_date CASCADE;
DROP TABLE IF EXISTS sectordist CASCADE;
DROP TABLE IF EXISTS Row_numb CASCADE;


CREATE TABLE Securities (
Symbol2 TEXT ,
Company TEXT,
Sector TEXT,
SumIndustry TEXT,
InitTradeDate VARCHAR(10) 

);

\COPY Securities FROM 'C:/Users/Public/Documents/securities.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE Fundamentals (
 id SERIAL,
 Symbol1 TEXT,
 YearEnd TEXT,
 CASHEQ BIGSERIAL,
 EarnBefIntTax BIGSERIAL,
 GMargin BIGSERIAL,
 NetInc BIGSERIAL,
 TAssets BIGSERIAL,
 TLiabilities BIGSERIAL,
 TRevenue BIGSERIAL,
 Year SERIAL,
 EarnPerShare FLOAT,
 ShareOdt FLOAT
 
);
\COPY Fundamentals FROM 'C:/Users/Public/Documents/fundamentals.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE Prices (
 Date TEXT, --NOT NULL,
 Symbol TEXT,
 SOpen FLOAT,
 SClose FLOAT,
 Low FLOAT,
 High FLOAT,
 Volume FLOAT

);
\COPY Prices FROM 'C:/Users/Public/Documents/prices.csv' WITH (FORMAT csv);

--Use the window function (command prompt) to create the table in the database
CREATE TABLE year_end_price AS
	(SELECT Symbol, Date, SClose FROM Prices 
	WHERE Date::TEXT LIKE '%-12-31' 
	OR 
	Date::TEXT LIKE '2010-12-31%'
	ORDER BY Symbol, Date, SClose
	);

--Created the table with annual return
--100 is the percentange to be multiply with the return 	
CREATE TABLE Annual_Return AS (
	SELECT Symbol, Date,AVG(returns) AS return 
	FROM (SELECT Symbol, Date,SClose,(((CAST(SClose AS DECIMAL)/start_SClose)-1)*100) AS returns -- (((CAST(SClose AS DECIMAL)/start_SClose)-1)*100) ==  Cash Ratio 
	FROM (SELECT *, LAG(SClose) OVER (PARTITION BY Symbol ORDER BY Date) AS start_SClose 
	FROM year_end_price
		)t 
			)t2 
				GROUP BY Symbol, Date

	);
		
CREATE TABLE top_thirty AS (
SELECT DISTINCT Symbol, Date,return AS Top_30 
	FROM Annual_Return 
		WHERE return <> 0  
			ORDER BY return
				DESC LIMIT 30

);

--HW5-6
CREATE TABLE Year_end AS
	(SELECT * FROM Fundamentals
	WHERE YearEnd::TEXT LIKE '%-12-31' 
	OR 
	YearEnd::TEXT LIKE '2010-12-31%'
	ORDER BY Symbol1, Year, YearEnd 
	);

CREATE TABLE  NetWorth AS( 
	SELECT Symbol1, Year, (TAssets - TLiabilities) AS Net_Worth FROM Year_end
--asset - liability 

);

--1)
CREATE TABLE Comp_NetWorth AS 
	(SELECT *, LAG(Net_Worth) 
		OVER (PARTITION BY Symbol1 ORDER BY Year) AS Prev_yr_networth, 
			LAG (Top_30) 
				OVER (PARTITION BY Symbol ORDER BY Date) AS Prev_yr_return  
					FROM NetWorth INNER JOIN top_thirty 
						ON NetWorth.Symbol1 = top_thirty.Symbol 
							ORDER BY Net_Worth DESC
);

CREATE TABLE Comp_NetInc AS 
	(SELECT Symbol, Date , Symbol1, Year, LAG(NetInc) 
		OVER (PARTITION BY Symbol1 ORDER BY Year) AS Prev_yr_netinc, 
			LAG (Top_30) 
				OVER (PARTITION BY Symbol ORDER BY Date) AS Prev_yr_return  
					FROM Fundamentals INNER JOIN top_thirty 
						ON Fundamentals.Symbol1 = top_thirty.Symbol 
							ORDER BY NetInc DESC
	);

CREATE TABLE Comp_TRevenue AS 
	(SELECT Symbol, Date , Symbol1, Year, LAG(TRevenue) 
		OVER (PARTITION BY Symbol1 ORDER BY Year) AS Prev_yr_Revenue, 
			LAG (Top_30) 
				OVER (PARTITION BY Symbol ORDER BY Date) AS Prev_yr_return  
					FROM Fundamentals INNER JOIN top_thirty 
						ON Fundamentals.Symbol1 = top_thirty.Symbol 
							ORDER BY TRevenue DESC
	);
	
CREATE TABLE Comp_EarnPerShare AS
	(SELECT Symbol, Date , Symbol1, Year, LAG(EarnPerShare) 
		OVER (PARTITION BY Symbol1 ORDER BY Year) AS Prev_yr_earpershare, 
			LAG (Top_30) 
				OVER (PARTITION BY Symbol ORDER BY Date) AS Prev_yr_return  
					FROM Fundamentals INNER JOIN top_thirty 
						ON Fundamentals.Symbol1 = top_thirty.Symbol 
							ORDER BY EarnPerShare DESC

	);
	
CREATE TABLE PE AS (
	SELECT Symbol1, Year,ShareOdt, EarnPerShare,  CAST(ShareOdt AS DECIMAL)/EarnPerShare AS PERatio 
		FROM Year_end
	);
	
--	Amount of cash in the bank vs. total liabilities
CREATE TABLE Cash_ratio AS (
SELECT Symbol1, Year,TLiabilities, CASHEQ, CAST (CASHEQ AS DECIMAL)/TLiabilities AS Ratio 
	FROM Year_end

	);

CREATE TABLE Comp_PE AS 
	(SELECT Symbol, Date , Symbol1, Year, LAG(PERatio) 
		OVER (PARTITION BY Symbol1 ORDER BY Year) AS Prev_yr_pe, 
			LAG (Top_30) 
				OVER (PARTITION BY Symbol ORDER BY Date) AS Prev_yr_return  
					FROM PE INNER JOIN top_thirty 
						ON PE.Symbol1 = top_thirty.Symbol 
							ORDER BY PERatio ASC
	);

--2)
-- Found out one criterial between the top 30 or annual return with the Cash ratio who have something in common, 
-- the rest of the five query doesn't have anything in common   
CREATE TABLE MarginGross AS (
SELECT DISTINCT Symbol1, GMargin 
    FROM Fundamentals 
    WHERE GMargin BETWEEN 25 AND 61 AND (Year = '2016') ORDER BY GMargin DESC LIMIT 30
	);

	
--3)	
-- The 10 selected stock  I choose for investment are MA, V, AMZN, NFLX,  NVDA,QCOM, , STT, GPN, GILD,  BSX
-- The reason why I choosen those ten Stock is due to the fact that it have high return and most audience either buy from this company or 
-- use their products. At the same time I choosen one random stock to see if the correction will affect the most high annual return and cash ration.


--===note from class =========================
CREATE TABLE sectordist AS(
 SELECT DISTINCT (sector), Symbol2,SumIndustry FROM Securities ORDER BY Sector
);

CREATE TABLE Row_numb AS (
SELECT *, ROW_NUMBER () OVER (PARTITION by b.sector) AS rowid
 FROM Fundamentals a 
 INNER JOIN Securities b 
 ON a.Symbol1=b.Symbol2
 -- WHERE id <= 2 ORDER BY Sector
 );
 
--SELECT Row_number,sector, company, from Row_numb  where rowid<=1;
--============================================
CREATE TABLE stock1 AS (
SELECT Symbol AS Stock1, Date,SClose 
	FROM Prices 
		WHERE 
			Symbol = 'MA' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
			OR Symbol='AMZN' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
			OR Symbol = 'NVDA' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
			OR Symbol = 'STT' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
			OR Symbol = 'GILD' AND Date BETWEEN '2016-1-1' and '2016-12-31'

);

CREATE TABLE stock2 AS (
SELECT  Symbol AS Stock2, Date,SClose 
	FROM Prices 
		WHERE Symbol = 'V' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
		OR Symbol='NFLX' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
		OR Symbol = 'QCOM' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
		OR Symbol = 'GPN' AND Date BETWEEN '2016-1-1' and '2016-12-31' 
		OR Symbol = 'BSX' AND Date BETWEEN '2016-1-1' and '2016-12-31'
);
-- Using the AS to fix the conflict of column " symbol" specified more than once SQL
CREATE TABLE correl AS(
SELECT  stock1.Stock1 AS Stock_1,stock2.Stock2 AS Stock_2, CORR(stock1.SClose, stock2.SClose) AS Corr_stock
    FROM stock1 
        inner join stock2  ON stock2.Stock2 != stock1.Stock1 
            GROUP BY  stock1.Stock1,  stock2.Stock2
			ORDER BY  Corr_stock ASC
	);

-- HW 6
-- >pg_dump -U postgres -d bigassign > Backup_Invest.sql
-- >psql -U postgres -f Backup_Invest.sql 

-- CREATE [TEMP] VIEW MyInvest AS 
-- Select * from MyInvest_View to the table as a non-programers 
CREATE VIEW MyInvest_View AS 
(
 SELECT a.*, b.SClose AS CLOSE
    FROM Securities a
	INNER JOIN  Prices b ON a.Symbol2 = b.Symbol
		WHERE a.Symbol2 = 'V' 
			OR a.Symbol2 = 'MA' 
			OR a.Symbol2 = 'AMZN' 
			OR a.Symbol2 = 'NVDA' 
			OR a.Symbol2 = 'STT' 
			OR a.Symbol2 = 'GILD' 
			OR a.Symbol2 = 'NFLX' 
			OR a.Symbol2 = 'QCOM' 
			OR a.Symbol2 = 'GPN' 
			OR a.Symbol2 = 'BSX' 
			--OR a.InitTradaDate  BETWEEN '2001-1-31' AND '2016-12-31' with LOCAL check option
			--WITH CASCADE CHECK OPTION
			--GROUP BY a.Symbol2, a.Company,a.Sector, a.SumIndustry,a.InitTradeDate, CLOSE
			--WITH CHECK OPTION
);
-->psql -d bigassign  -U postgres -tAF"," -c "select * from MyInvest_View" > myportfolio_view.csv
/*CREATE TABLE invest_date AS
	(SELECT Symbol, Date, SClose FROM Prices 
	WHERE Date::TEXT LIKE '%2016-12-30' 
	OR 
	Date::TEXT LIKE '2016-12-30%'
	ORDER BY Symbol, Date, SClose
	);
	*/
-- V Closing price is 114.02 for the year end of 2017 and begin of 2016 is 78.02
-- Annual return rt= 0.461
-- MA Closing price is 151.36 for the year end 2017 and begin of 2016 is 103.25
-- Annual return rt = 0.466
-- AMZN Closing price is 1229.14 for the year end 2017 and begin of 2016 is 749.87
-- Annual return rt= 0.390
-- NVDA Closing price is 215.40 for the year end 2017 and begin of 2016 is 106.74 
-- Annual return  rt=- 1.018
-- STT Closing price is 97.61 for the year end 2017 and begin of 2016 is 77.72
-- Annual return  rt =0.260
-- GILD Closing price is  71.64 for the year end 2017 and annual begin of 2016 is 71.61
-- Annual return  rt = 0.0004
-- NFLX Closing price is 191.96 for the year end 2017 and begin of 2016 is 123.80 
-- Annual return  rt = 0.550
-- QCOM Closing price is 64.02bfor the year end 2017 and begin of 2016 is 65.20
-- Annual return rt =-0.018
-- GPN Closing price is 100.24 for the year end 2017 and begin of 2016 is 69.41 
-- Annual return rt = 0.444
-- BSX Closing price is 24.79b for the year end 2017 and begin of 2016 is 21.63
-- Annual return rt= 0.146
	
	
-- Analyzing for any error or anormalities in the table	
COMMIT;
ANALYZE Fundamentals;
ANALYZE Securities;
ANALYZE Prices;
ANALYZE year_end_price;
ANALYZE Annual_Return;
ANALYZE top_thirty;
ANALYZE Year_end;
ANALYZE NetWorth;
ANALYZE Comp_NetInc;
ANALYZE Comp_EarnPerShare;
ANALYZE Comp_TRevenue;
ANALYZE Comp_NetWorth;
ANALYZE PE;
ANALYZE MarginGross;
ANALYZE Comp_PE;
ANALYZE Cash_ratio;
ANALYZE stock1;
ANALYZE stock2;
ANALYZE correl;
ANALYZE invest_date;
ANALYZE sectordist;
ANALYZE Row_numb;