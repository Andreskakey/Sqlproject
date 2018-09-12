
-- Hide row count at bottom of results - just adds clutter.
\pset footer off
drop table if exists transactions;
drop table if exists customers;
drop table if exists vehicles;

create table vehicles(
    vin integer unique,
    descr text,
    year integer,
    vehic_type text,
    cost integer,
    days_in_inventory integer
);

create table customers(
    cust_id integer unique,
    lname text,
    fname text,
    city text,
    state text
);

create table transactions(
    trans_id integer,
      -- A foreign key:  What does this do?  
      -- cust_id integer references customers(cust_id),
    cust_id integer,
    time text,  -- Woule be of TIME type - this is just an example
      -- Another foreign key:  
      -- What if I choos 123456789 here?  Is that a valid vehicle in our table?
      -- vehicle integer references vehicles(vin),
    vehicle integer,
    sale_price integer,
    pmt_method text
);


insert into vehicles values 
(1111, 'Mustang', 2018, 'Sport', 14000, 32),
(1112, 'F150', 2017, 'Truck', 11000, 76),
(1231, 'F150', 2018, 'Truck', 10500, 38),
(1313, 'Explorer', 2018, 'SUV', 16000, 12),
(1314, 'Escort', 2018, 'Economy', 8000, 19),
(1532, 'Fiesta', 2017, 'Economy', 6000, 22),
(1617, 'F250', 2016, 'Truck', 14000, 346),
(1718, 'F350', 2017, 'Truck', 16000, 87);

insert into customers values 
(321,'Doe','James','Darien','CT'),
(322,'Allen','Jim','Fort Lee','NJ'),
(323,'Smith','Fred','Stony Brook','NY'),
(324,'Jones','Joe','Boston','MA'),
(325,'Johnson','John','Hartford','CT'),
(326,'Harold','Ronald','Newark','NJ');

insert into transactions values 
(1121,323,'12:07pm 3/1/17',1112,15000,'Cash'),
(1122,325,'12:08pm 3/1/17',1111,18000,'Loan'),
(1123,321,'02:00pm 3/3/17',1313,22000,'Loan'),
(1124,326,'03:12pm 3/4/17',1718,19000,'Cash');




select * from vehicles;
select * from customers;
select * from transactions;

-- Join and see how it works (two ways - what is the difference?  (identical column names)):
select * from customers inner join transactions on customers.cust_id = transactions.cust_id;

-- \echo '\n\nSimple two-way join: customers-transactions join.\n'
select * from customers inner join transactions using(cust_id);


-- Join ALL THE THINGS !!    (three-way join):
\echo '\nAll info on all transactions: customer-transaction-vehicle join.\n'
select *
    from transactions 
        inner join customers
        using(cust_id)
        inner join vehicles
        on vehicles.vin = transactions.vehicle;  -- Cannot use "using()" here - not same name.
-- QUESTION:  Why isn't this table bigger - how long can it be?



\echo '\nTransactions only with customers who live in NY and NJ:\n'
select * 
    from transactions a 
        inner join customers b
        on a.cust_id = b.cust_id
        where b.state in ('NY', 'NJ');


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Other types of joins:
-- Which customers haven't purchased anything.
-- Which cars have not been sold?
select * from vehicles left outer join transactions on vehicles.vin = transactions.vehicle;
select * from vehicles left outer join transactions on vehicles.vin = transactions.vehicle where transactions.vehicle is null;



select * from customers left outer join transactions on customers.cust_id = transactions.cust_id;
select * from customers left outer join transactions on customers.cust_id = transactions.cust_id where transactions.cust_id is null;
-- Will this work?
select * from transactions left outer join customers on transactions.cust_id = customers.cust_id where transactions.cust_id is null;
-- How bout this?
select * from transactions right outer join customers on transactions.cust_id = customers.cust_id where transactions.cust_id is null;



-- Question:  Can we make a query that will return ALL DATA?
-- Yes, can join.  Will it mean anything?  (really, no - can join anything to anything else indiscriminately.
select * 
    from customers 
    left outer join transactions 
        on customers.cust_id = transactions.cust_id
--    full outer join vehicles 
--        on transactions.vehicle = vehicles.vin;
    ;

-- EVERYTHING !!
select * 
    from customers 
    full outer join transactions 
        on customers.cust_id = transactions.cust_id
    full outer join vehicles 
        on transactions.vehicle = vehicles.vin;
