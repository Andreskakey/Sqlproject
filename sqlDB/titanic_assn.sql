/* 
    Passengers on the Titanic:
        1,503 people died on the Titanic.
        - around 900 were passnegers, 
        - the rest were crew members.

    This is a list of what we know about the passengers.
    Some lists show 1,317 passengers, 
        some show 1,313 - so these numbers are not exact, 
        but they will be close enough that we can spot trends and correlations.

    Lets' answer some questions about the passengers' survival data: 
 */

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Create a database (if we don't already have one). */

-- CREATE DATABASE classwork;  -- (or whatever else you want to name it).

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Create the table and get data into it: */



DROP TABLE PASSENGERS;  -- for adjustments / etc - can drop and re-create.

CREATE TABLE passengers (
    id INTEGER NOT NULL,
    lname TEXT,
    title TEXT,
    class TEXT, 
    age FLOAT,
    sex TEXT,
    survived INTEGER,
    code INTEGER
);

-- NOTE:  On an exam, this would look like:
-- passengers(id, lname, title, class, age, sex, survived, code)

-- Now get the data into the database:
\COPY passengers FROM 'C:/Users/Public/Documents/titanic.csv' WITH (FORMAT csv);



-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- How many total:
select count(*) as total_passengers from passengers;

-- How many survived?
select count(*) as survived from passengers where survived=1;

-- How many died?
select count(*) as did_not_survive from passengers where survived=0;

-- How many were female? Male?
select count(*) as total_females from passengers where sex='female';
select count(*) as total_males from passengers where sex='male';

-- How many total females died?  Males?
select count(*) as no_survived_females from passengers where sex='female' and survived=0;
select count(*) as no_survived_males from passengers where sex='male' and survived=0;


-- Percentage of females of the total?
select 
    sum(case when sex='female' then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_female 
    from passengers;

-- Percentage of males of the total?
select 
    sum(case when sex='male' then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_male 
    from passengers;
	
	

	
-- Percentage survival
select 
    sum(case when  survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_Survived 
    from passengers;
	
	
-- Surviver male

select count(*) as survived_males from passengers where sex='male' and survived=1;

-- Surviver female

select count(*) as survived_females from passengers where sex='female' and survived=1;


-- Percentage male surviver

select 
    sum(case when sex='male' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_male_Survived 
    from passengers;
	
--Percentage female surviver

select 
    sum(case when sex='female' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_female_Survived 
    from passengers;
	
-- How many people total were in First class, Second class, Third, or unknown ?

select count(*) as First_class from passengers where class='1st';

select count(*) as Second_class from passengers where class='2nd';

select count(*) as third_class from passengers where class='3rd';

select count(*) as Unknown_class from passengers where class is NULL or class is null;


-- What are the survival percentages of the different classes? (3).

select 
    sum(case when class='1st' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_First_class_surviver 
    from passengers;

select 
    sum(case when class='2nd' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_Second_class_surviver 
    from passengers;

select 
    sum(case when class='3rd' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_third_class_surviver 
    from passengers;








-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Finish the rest by answering these questions  %%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%% Most are SQL - some are conceptual            %%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%   short answers are fine for conceptual.      %%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- 1.  What percent survived? (total)
	/* 
		Given the data from: 
		select count(*) will count +1 survived for each 1 then add up the total surviver which is
		450. With the percentage should be 34.2726580350343
		
		
	*/

-- 2.  Percentage of females that survived?
	/*
		 Given the case when sex='female' and survived = 1 sum up the total numbers of female surviver 
		 then divide the total percentage of passenger in the titanic.
		 The Percentage of female survived is 23.458 percentage or 23.4577303884235
	*/
-- 3.  Percentage of males that survived?
	/*
		 Given the case when sex='male' and survived = 1 or is equal to 1 sum up the total numbers of male surviver 
		 then divide the total percentage of passenger in the titanic.
		 The Percentage of male survived is 10.815 percentage or 10.8149276466108
	*/

-- 4.  How many people total were in First class, Second class, Third, or unknown ?
	/*
		select count(*) as First_class from passengers where class='1st'; 
		Similar to question 1, the count will count the numbers of string that contains "1st" in the
		titanic csv file with the passenger. First class we have  322 passenger including the female and male passengers.
	

		select count(*) as Second_class from passengers where class='2nd';
		Second class we have  279 passenger including the female and male passengers.

		select count(*) as third_class from passengers where class='3rd';
		Third class we have  710 passenger including the female and male passengers.

		select count(*) as Unknown_class from passengers where class='';
		Unknown class or empty string we have  2 passenger which are 2 male passengers in between 2nd and 3rd class.
	*/

-- 5.  What is the total number of people in First and Second class ?
	/*
		Already given the data that First class we have 322 and second class we have 279 passengers
	*/

-- 6.  What are the survival percentages of the different classes? (3).
	/*
		select 
    sum(case when class='1st' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_First_class_surviver 
    from passengers;
		Similar to question 2, sum up the total numbers string that have "1st" including the female and male passengers
		as well as the survived which is equal 1 then use the total numbers of passengers in the titanic to find the
		percentage. First class percentage of survived is 14.6991622239147

select 
    sum(case when class='2nd' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_Second_class_surviver 
    from passengers;
		Second class percentage of survived is  9.06321401370906

select 
    sum(case when class='3rd' and survived = 1 then 1.0 else 0.0 end) / 
        cast(count(*) as float)*100 as tot_pct_third_class_surviver 
    from passengers;
		Third class percentage of survived is 10.5102817974105
	
	*/



-- 7.  Can you think of other interesting questions about this dataset?
--      I.e., is there anything interesting we can learn from it?  
--      Try to come up with at least two new questions we could ask.
		
--      Example:
--      Can we calculate the odds of survival if you are a female in Second Class?
--      Could we compare this to the odds of survival if you are a Female in First Class?
--      If we can answer this question, is it meaningful?  Or just a coincidence ... ?
		/*
			Can we list the age of all the passenger in the titanic from youngest to oldest passenger?
			It's possible to modify the titanic csv file via the sql or do a join table that have different data 
			but similar situation with the titanic?
		*/


-- 8.  How would we answer those questions if we did think of some?
--      Are you able to write the query to find the answer now?  
--      Or - do we need more data to find out - is this data set sufficient?
		/*
			The data above is sufficient to understand the basic idea of Database. I were able to write the query 
			by following the class example and writing down some small note in-class. Also following some instruction 
			on how to install and use cmd in windows from piazza.
		*/
--      Do you posess the SQL knowledge now to answer these questions using the dataset?
--          If not, what else might we need to learn in order to do it?
		/*
			For now I understand the basic of SQL by using my past knowledge of linux terminal, html 
			and some jqeury to answer the dataset question. what we may need to learn is the relation of database model 
			and distribution of database system, perhaps some advance SQL.
		*/

--      If you did answer some questions about the data, 
--          how would you justify or defend your results if someone challenged them?
--          -- Did the query make sense?  Are your methods good ?
		/*
			I will give a general ideas or logic behind how I got my result. 
			The query did make sense, I guess some of my method are good.
		*/


