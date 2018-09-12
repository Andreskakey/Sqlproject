-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%% Demo:  un-comment lines (or blocks) to run: %%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- COMMENTS:  "--" this a line comment, 

/* This is
   a block
   comment 
*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DROP TABLE IF EXISTS cars CASCADE;

/*
Enter psql:
To start:
    psql -U <user>
    psql -U postgres

Normally:
    psql -d <database> -U <user>

Scripts:  (the way to go)
    psql -d <database> -U <user> -f <file>.sql
    psql -d classwork -U postgres -f cars_demo.sql
    (may want to time with Linux 'time' utility:)

    time psql -d classwork -U postgres -f cars_demo.sql


psql command line flags:
    -d dbase
    -U user
    -f script file to read
    -tAF <delimiter>   export <delimiter> delimited results.

    Example:  .csv export - in order, no spaces ...  (nice for excel consumers)
    psql -tAF ',' -U postgres -d classwork -f cars_demo.sql


psql shell commands 
    \?          help
    \! clear    clear the screen
    \l          list databases
    \l+         list databases with extra info - size, etc.
    \dt         list tables
    \d+         list tables with extra info

    \q          quit


Capitalization and clarity - why?

Utilites included:
    initdb
    createdb
    pg_dump
    pg_restore

*/

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* Example schema: */
-- Car;MPG;Cylinders;Displacement;Horsepower;Weight;Acceleration;Model;Origin
-- STRING;DOUBLE;INT;DOUBLE;DOUBLE;DOUBLE;DOUBLE;INT;CAT

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 --Create the table:

CREATE TABLE cars (
    model TEXT,
    mpg FLOAT,
    cylinders INTEGER,
    displacement FLOAT,
    horsepower FLOAT,
    weight FLOAT,
    accel FLOAT,
    year INTEGER,
    origin TEXT
);


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Get the data into the table: */
--\COPY cars FROM 'C:/Users/Public/Documents/class/cars.csv' WITH (FORMAT csv);
\COPY cars  FROM 'C:/Users/Public/Documents/class/cars.csv' DELIMITER ';' CSV;
--\COPY cars ( mpg) FROM 'C:/Users/Public/Documents/class/cars.csv' DELIMITER ',' CSV HEADER;

/* Results: */

-- "select * from cars limit 1;"

--          model           | mpg | cylinders | displacement | horsepower | weight | accel | year | origin 
----------------------------+-----+-----------+--------------+------------+--------+-------+------+--------
--Chevrolet Chevelle Malibu |  18 |         8 |          307 |        130 |   3504 |    12 |   70 | US


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 
   Warm-up Questions:
   Which car has highest mpg? horsepower? accel?  Which is the heaviest?
   Let's list the top 5 and bottom 5 for each of the above.
*/
 select * from cars order by horsepower desc limit 5;
 select * from cars order by mpg desc limit 5;
-- select * from cars order by mpg asc limit 5;
-- Default is Ascending - does not need to be specified (still a good idea, though).
-- select * from cars order by mpg limit 5;  


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Tougher: */
/*  Which car has the best horsepower to weight ratio? */

-- select horsepower / weight as ratio from cars;
-- select model, horsepower / weight as ratio from cars;
--  select *, horsepower / weight as ratio from cars;
-- select model, mpg, displacement, horsepower, weight,  horsepower / weight as hp_ratio from cars order by horsepower / weight desc limit 10 ;
-- select model, mpg, displacement, horsepower, weight,  horsepower / weight as hp_ratio from cars where horsepower <> 0 order by horsepower / weight asc limit 10 ;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* MPG/Horsepower */
-- select model, mpg, displacement, horsepower, weight, mpg / horsepower as mpg_ratio from cars where horsepower <> 0 and mpg <> 0 order by mpg / horsepower desc limit 10 ;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*  Whose design is most efficient?  power/displacement   */
-- select *, horsepower / displacement as efficiency_ratio from cars where displacement <> 0 order by horsepower / displacement desc limit 20;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Average mpg & hp: */
--select avg(mpg) from cars;
--select avg(horsepower) from cars;
--select stddev(horsepower) from cars;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- More powerful than 95% of cars:
-- select * from cars where horsepower > (avg(horsepower) + 2*stddev(horsepower));

/*
with threshold as (
    select avg(horsepower) + 2*stddev(horsepower) as threshold from cars
)

select model, horsepower from cars group by model, horsepower having horsepower > (select threshold from threshold) order by horsepower desc;
*/


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Fuzzy string matching: */
-- select * from cars where model like 'Chev%';
-- select * from cars where model like 'Ford%';

-- select * from cars where model like 'Ford%' and horsepower > 180;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 'between' */
-- select * from cars where horsepower between 80 and 85;
-- select * from cars where year between 79 and 80;
-- select * from cars where year between 79 and 80 and horsepower between 100 and 130;

/* 'in' */
-- select * from cars where year in (72, 82);
-- select * from cars where year in (72, 82) and horsepower between 190 and 210;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* 'or' - logical operators */
-- select * from cars where model like 'Ford%' or model like 'Chevy%';

-- select * from cars where mpg > 15 or horsepower > 200;
-- select * from cars where mpg > 15 and horsepower > 200;  -- Whaaaa?  We got a hit?!

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* Correlation: */
-- select corr(horsepower, mpg) as power_mpg_correlation from cars;
-- select corr(displacement, horsepower) displ_power_correlation from cars;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/* pg_dump: Backup your databases (in SQL or text or whatever) */
-- pg_dump -d classwork -t cars -U postgres > cars_backup.sql

/* gpg encrypt (foobar) */
-- gpg --output cars_backup.sql.gpg --symmetric cars_backup.sql 

/* gpg decrypt (foobar) */
-- gpg --output cars_backup.sql --decrypt cars_backup.sql.gpg

ANALYZE cars;

