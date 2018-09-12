--Kakey Fon 
--CISC 3810 
--Assignment #3
--1. We want to spend some advertising money - where should we spend it?
 --I.e., What is our best referral source of buyers?
	-- The best source of buyers are boutjournal and google. 
	--SELECT * 
		--FROM buyers 
			--INNER JOIN transactions 
				--ON buyers.cust_id = transactions.cust_id 
				--ORDER BY price 
				--DESC;
		
--2. Who of our customers has not bought a boat?
	--Jame, Juan, Ronald, Alan, Elaine, Margarita, and James are the one who didn't buys a boats.
	--SELECT * 
		--FROM buyers 
			--LEFT OUTER JOIN transactions 
				--ON buyers.cust_id = transactions.cust_id 
				--WHERE transactions.cust_id 
				--IS NULL;

--3. Which boats have not sold?
	--The Criss Craft sporty boat didn't have any customer according to the data. 
	--SELECT * 
		--FROM boats 
			--LEFT OUTER JOIN transactions 
				--ON boats.prod_id = transactions.prod_id 
				--WHERE transaction.prod_id 
				--IS NULL;
			 
--4. What boat did Alan Weston buy?
-- Alan Weston bought a Carver.
--SELECT buyers.fname, buyers.lname, boats.brand 
	--FROM transactions 
		--FULL OUTER JOIN buyers 
		--ON buyers.cust_id = transactions.cust_id 
			--FULL OUTER JOIN boats 
			--ON transactions.prod_id = boats.prod_id 
				--WHERE buyers.fname  IN ('Alan') 
				--AND 
				--buyers.lname IN ('Weston');

--5. Who are our VIP customers?
   -- I.e., Has anyone bought more than one boat?

   -- Hint:  Think 'WITH' clause, subquery, or UNION.
      -- It's probably adviseable to do a subquery first, to get customer id's that
      --  appear in the 'transactions' table more than once. 
      --  Then, after we have those, we can join them with the 'buyers' table 
      --  to get the first and last names.
	--SELECT buyers.fname, buyers.lname 
		--FROM buyers 
			--LEFT OUTER JOIN 
				--(SELECT transactions.cust_id FROM transactions GROUP BY transactions.cust_id HAVING COUNT (*)= 10 )
					--AS Vip  
						--ON Vip.cust_id = Vip.cust_id;
-- Our top VIP customs are: 
/*
   fname   |  lname
-----------+----------
 Jane      | Doe
 Fred      | Smith
 John      | Jones
 Alan      | Weston
 James     | Smith
 Adam      | East
 Mary      | Jones
 Tonya     | James
 Elaine    | Edwards
 Alan      | Easton
 James     | John
 Ronald    | Jones
 Freida    | Alan
 Thelma    | James
 Louise    | John
 Brad      | Johnson
 Thomas    | Jameson
 Robert    | Newbury
 Edward    | Oldbury
 Juan      | Reyes
 Alberto   | Delacruz
 Margarita | Jones
 Penelope  | Smith
*/
		
BEGIN;

DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS boats CASCADE;
DROP TABLE IF EXISTS buyers CASCADE;

CREATE TABLE transactions (
	trans_id integer NOT NULL,
    cust_id integer NOT NULL ,
    prod_id integer NOT NULL ,
    qty integer,
    price real
);
INSERT INTO transactions (trans_id,cust_id,prod_id,qty,price) VALUES 
 (1124, 3121, 3017, 1, 126000.0),
 (1127, 1221, 1617, 1, 69300.0),
 (1130, 1821, 1317, 1, 83750.0),
 (1133, 1321, 1117, 1, 45100.0),
 (1136, 2521, 1717, 1, 61200.0),
 (1139, 2721, 1317, 1, 83750.0),
 (1142, 2621, 1417, 1, 55200.0),
 (1145, 1121, 1917, 1, 22100.0),
 (1148, 1821, 1817, 1, 40260.0),
 (1151, 2821, 3017, 1, 126000.0),
 (1154, 1621, 1917, 1, 22100.0),
 (1157, 3121, 1717, 1, 61200.0),
 (1160, 2321, 1517, 1, 62500.0),
 (1163, 3321, 1317, 1, 83750.0),
 (1166, 1721, 1917, 1, 22100.0),
 (1169, 2421, 1817, 1, 40260.0),
 (1172, 2921, 1417, 1, 55200.0),
 (1175, 2321, 3017, 1, 126000.0),
 (1178, 1221, 1317, 1, 83750.0),
 (1181, 1121, 1817, 1, 40260.0),
 (1184, 1321, 3017, 1, 126000.0),
 (1187, 1421, 1517, 1, 62500.0),
 (1190, 3321, 1517, 1, 62500.0);
 
 
CREATE TABLE boats (
    prod_id integer NOT NULL ,
    brand TEXT ,
    category TEXT,
	cost integer,
    price float
	
);

  INSERT INTO boats (prod_id,brand,category,cost,price) VALUES 
 (1217,'Criss Craft','sporty',20000,25000.0),
 (1117,'Bayliner','runabout',41000,45100.0),
 (1317,'Mastercraft','ski',67000,83750.0),
 (1417,'Boston Whaler','fishing',48000,55200.0),
 (1517,'Carver','cabin cruser',50000,62500.0),
 (1617,'Bayliner','runabout',33000,69300.0),
 (1717,'Kawasaki','sporty',51000,61200.0),
 (1817,'Kawasaki','runabout',33000,40260.0),
 (1917,'Zodiac','inflatable',17000,22100.0),
 (3017,'Egg Harbor','',60000,126000.0);
 
CREATE TABLE buyers (
	cust_id integer NOT NULL ,
    fname TEXT ,
    lname TEXT ,
    city TEXT ,
	states TEXT,
    referrer TEXT
);
 
 INSERT INTO buyers (cust_id,fname,lname,city,states,referrer) VALUES 
 (1121,'Jane','Doe','Boston','MA','craigslist'),
 (1221,'Fred','Smith','Hartford','CT','facebook'),
 (1321,'John','Jones','New Haven','CT','google'),
 (1421,'Alan','Weston','Stony Brook','NY','craigslist'),
 (1521,'James','Smith','Darien','CT','boatjournal'),
 (1621,'Adam','East','Fort Lee','NJ','mariner'),
 (1721,'Mary','Jones','New Haven','CT','facebook'),
 (1821,'Tonya','James','Stamford','CT','boatbuyer'),
 (1921,'Elaine','Edwards','New Rochelle','NY','boatbuyer'),
 (2021,'Alan','Easton','White Plains','NY','craigslist'),
 (2121,'James','John','Ringwood','NJ','google'),
 (2221,'Ronald','Jones','Hackensack','NJ','craigslist'),
 (2321,'Freida','Alan','Stratford','CT','boatbuyer'),
 (2421,'Thelma','James','Paterson','NJ','facebook'),
 (2521,'Louise','John','Paramus','NJ','boatbuyer'),
 (2621,'Brad','Johnson','Fort Lee','NJ','google'),
 (2721,'Thomas','Jameson','Fairfield','CT','craigslist'),
 (2821,'Robert','Newbury','Astoria','NY','boatjournal'),
 (2921,'Edward','Oldbury','Brooklyn','NY','mariner'),
 (3021,'Juan','Reyes','Brooklyn','NY','facebook'),
 (3121,'Alberto','Delacruz','New York','NY','google'),
 (3221,'Margarita','Jones','White Plains','NY','boatbuyer'),
 (3321,'Penelope','Smith','Maspeth','NY','facebook');

COMMIT;
ANALYZE transactions;
ANALYZE boats;
ANALYZE buyers;



		