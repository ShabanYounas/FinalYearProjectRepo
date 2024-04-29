/*
This sql sheet transforms the data and adds it onto dimension table. 
It will also generate different tables that will be then needed/must be joined to validate data for dimensions table
TRANSFORMATION
*/



--###
--Transforming from source.s_date to dimension.d_dated
--
/*
adding s_date to dated dimension from source.s_date to dimension.d_dated
--
*/

--
/*
INSERT INTO dimension.d_dated (Date, Year, Quarter, Month, Week, Day, DayOfWeek, IsWeekend, IsHoliday, FiscalYear, FiscalQuarter, FiscalMonth)
SELECT Date, Year, Quarter, Month, Week, Day, DayOfWeek, IsWeekend, IsHoliday, FiscalYear, FiscalQuarter, FiscalMonth 
FROM source.s_date;

--
*/


/*
Testing to see if data has been copied into d_dated
*/
--select * from dimension.d_dated
--select max(date) from dimension.d_dated


/*

Transforming s_customer table
and re-writing it to new table d_customer. 
Transformation will only be applied, if and if data needs to be transformed else it will be added.
For example in customer dimension some of the customer name is mission and this will be populated using ticker_and_symbol table from source dimension
--*/
--select * from source.s_customer ORDER BY country DESC;

--the below sql gets all the the customers ticker and their names. 

--####
--test to see and read table
--select symbol,customer_name  from source.s_customer ORDER BY customer_name ASC


--###
--finding overall count of customer with no customer name. based on symbols. 
/*
select count(*) as symbols_woithout_name
from source.s_customer 
where customer_name is null
--- this should return 928 customers with no names
*/


--###
--now that I have the count of customers, I want to get a list of symbols that has missing customer name 
--
/*
select symbol, customer_name
from source.s_customer 
where customer_name is null

--
*/

--## 
--Now that we know the number of customers i want to put that information into a table, that then can be reference easier. 
--I will insert that mission data into a new table names, missing_customer_names that will be in stage. 
/*
create table source.missing_customer_names (symbol VARCHAR(255),customer_name TEXT);
*/

--##
--inserting records into the table missing_customer_names from s_customer 
--
/*
insert into source.missing_customer_names (symbol, customer_name)
select symbol, customer_name
from source.s_customer 
where customer_name is null;

*/

--##
--Testing to see if recordes have been added. After running this query the records are inserted into the newley created table

--
/*
select * from source.missing_customer_names
--
*/

--##
--Joining missing_customer_names to ticker_and_symbols table to obtain their name. 

/*
select * from 
source.missing_customer_names as ab
join source.ticker_and_name as xy
on xy.symbol = ab.symbol
*/							

--##
--for the purpose of keeping table backups i will be creating a table transfered the data over and and continue to work with joining the information
/*
--create table source.mission_customer_names_backup (name TEXT, symbol Text)
insert into source.mission_customer_names_backup(name, symbol) 
select customer_name, symbol 
from source.missing_customer_names;

*/


--##
--once backup table created I will now continue to tranform data
--I now need to use case statment and update the table. 
--I will not join the table with source.missing_customer_names with source.ticker_and_name instead
--I will use case statment to move the information from the source.ticker_and_name into source.missing_customer_names and update the table. 

--
/*
UPDATE source.missing_customer_names AS ab
SET customer_name = (
    SELECT 
        CASE 
            WHEN ab.customer_name IS NULL THEN xy.description
            ELSE 'nothing'
        END AS customer_name
    FROM 
        source.ticker_and_name AS xy
    WHERE 
        xy.symbol = ab.symbol
);

--
*/

--##
--testing out the table to see if the names have been update.

--
/*
select * from source.missing_customer_names


--
*/


--##
--adding source.missing_customer_names to s_customer table. 
--this case statment will work just fine, it will match symbols, and then see if the name
--is null then it will take the name from missing_customer_names.

--
/*

update source.s_customer as x 
set
	customer_name = case 
						when x.customer_name is null then y.customer_name
						else x.customer_name 
					end
from 
source.missing_customer_names as y
where
x.symbol= y.symbol

--
*/

--##
--Checking if the recolds now jve names is them. 

--
/*

select symbol, customer_name
from source.s_customer 
where customer_name is null;


--
*/

--##
--Inserting data from s_customer into d_customer

--
/*
INSERT INTO dimension.d_customer (
    Address,
    City,
    State,
    Zip,
    Country,
    Phone,
    Website,
    Industry,
    Sector,
    SectorKey,
    symbol,
    Company_name,
    full_time_employees,
    Profit_margins,
    Earnings_growth,
    Revenue_growth,
    Market_cap,
    Fifty_two_week_high,
    Fifty_two_week_low,
    Currency,
    Exchange
)
SELECT
    Address1,
    City,
    State,
    Zip,
    Country,
    Phone ,
    Website ,
    Industry ,
    Sector ,
    SectorKey ,
	symbol,
    customer_name,
    full_time_employees,
    profit_margins,
    earnings_growth ,
    revenue_growth ,
    market_cap ,
    fifty_two_week_high ,
    fifty_two_week_low ,
    currency,
    exchange 
FROM
    source.s_customer
--where symbol = 'AAPL'

--
*/

--
--Testing if it has d_customer table has been updated.

--
/*
select count(*) from dimension.d_customer where company_name is not null

--
*/


--##
--Addint historical data to d_financial_info
--The data contained inside of the historical data hold the stock info.
--25022024SY Added in the leftover stock data into dimension.


--
/*
--THIS SQL WILL NEED TO GO INTO PYTHON CODE


INSERT INTO dimension.d_financial_info (
    symbol, 
    date,
    open,
    high,
    low,
    close,
    volume,
    dividends,
    stock_splits
)
SELECT 
    symbol, 
    date,
    open,
    high,
    low,
    close,
    volume,
    dividends,
    stock_splits
FROM 
    source.historical_stock_data AS s
WHERE NOT EXISTS (
    SELECT 1 
    FROM dimension.d_financial_info AS d 
    WHERE 
        d.symbol = s.symbol 
        AND d.date = s.date
);


--
*/
--select max (date) from dimension.d_financial_info--source.historical_stock_data
--*/


--##
--Testing to see if the data has been populated from dimension.d_financial_info


--select * from dimension.d_financial_info where symbol = '0JHR.L'


--staging metrics for finance data

/*
--THIS SQL WILL NEED TO GO INTO PYTHON CODE
INSERT INTO staging.finaincial_stock_data (
    symbol, 
    date,
    open,
    high,
    low,
    close,
    volume,
    dividends,
    stock_splits
)
SELECT 
    symbol, 
    date,
    open,
    high,
    low,
    close,
    volume,
    dividends,
    stock_splits
FROM 
   -- source.historical_stock_data;
--this needs more checks
--as duplicate recodes mught be added so need to go through this./ 

*/


--This is the helper table
--THIS SQL WILL NEED TO GO INTO PYTHON CODE

/*
insert INTO staging.finance_helper_table 
(
	date, 
	symbol, 
	close
)
select 
date, 
symbol, 
close 
from staging.finaincial_stock_data
*/




 --iserting previus close into the staging table.
--/*
UPDATE staging.finaincial_stock_data  fsd
SET previous_close_price = fht.close
FROM staging.finance_helper_table fht
WHERE fsd.symbol = fht.symbol
AND fsd.date = fht.date - INTERVAL '1 day';



--*/
--select * from staging.finaincial_stock_data
