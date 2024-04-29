/*
Creating all of the tables nessecery to run the etl. 
for now s=source, once tables land in source table, the soure should trigger stage --> which would trigger, dimensions, and/or facts.
*/

--Following Kimballs START schema data modelling
--Below will create various tables in different schemas to store data 

---creating dates tables


--
/*

CREATE TABLE source.s_Date (
    DateKey SERIAL PRIMARY KEY,
    Date DATE NOT NULL,
    Year INT,
    Quarter INT,
    Month INT,
    Week VARCHAR(2),
    Day INT,
    DayOfWeek VARCHAR(9),
    IsWeekend BOOLEAN,
    IsHoliday BOOLEAN,
    FiscalYear INT,
    FiscalQuarter INT,
    FiscalMonth INT
);

--
*/

--creating a dimension table for the same colums in the dimensions table.

--
/*

CREATE TABLE dimension.d_dated (
    Date DATE PRIMARY KEY,--this will go into facts
    Year INT,
    Quarter INT,
    Month INT,
    Week VARCHAR(5),
    Day INT,
    DayOfWeek VARCHAR(10),
    IsWeekend BOOLEAN,--this will go into facts
    IsHoliday BOOLEAN,
    FiscalYear INT,
    FiscalQuarter INT,
    FiscalMonth INT
);


--
*/

---Customer information from ticker = yf.Ticker(symbol)

--Access the metadata attributes 
--metadata = ticker.info
--print (metadata
--

--
/*
CREATE TABLE source.s_customer (
    Address1 VARCHAR(255), 
    City VARCHAR(255),
    State VARCHAR(2),
    Zip VARCHAR(10),
    Country VARCHAR(255),
    Phone VARCHAR(20),
    Website VARCHAR(255),
    Industry VARCHAR(255),
    Sector VARCHAR(255),
    SectorKey VARCHAR(255),
	symbol VARCHAR (255),
    customer_name TEXT,
    full_time_employees INT,
    profit_margins NUMERIC(25, 2),
    earnings_growth NUMERIC(25, 2),
    revenue_growth NUMERIC(25, 2),
    market_cap NUMERIC(20, 2),
    fifty_two_week_high NUMERIC(10, 2),
    fifty_two_week_low NUMERIC(10, 2),
    currency TEXT,
    exchange TEXT
);

--
*/


--
/*


CREATE TABLE dimension.d_customer (
    Address VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(2),
    Zip VARCHAR(10),
    Country VARCHAR(255),
    Phone VARCHAR(20),
    Website VARCHAR(255),
    Industry VARCHAR(255),
    Sector VARCHAR(255),
    SectorKey VARCHAR(255),
	symbol VARCHAR (255),
    Company_name TEXT, --this will go into facts
    full_time_employees INT,
    Profit_margins NUMERIC(25, 2), --this will go into facts
    Earnings_growth NUMERIC(25, 2), --this will go into facts
    Revenue_growth NUMERIC(25, 2), --this will go into facts
    Market_cap NUMERIC(20, 2), 
	Fifty_two_week_high NUMERIC(10, 2),
    Fifty_two_week_low NUMERIC(10, 2),
    Currency TEXT,--
    Exchange TEXT--this will go into facts, 
	virtual varcar(10)--this will go into facts,
);


--
*/


--This table will hold information on companies financial data
--Creating tables for historical_stock_data
--the table source.historical_stock_data holds information loaded from yfinance. That will be transfered dimension.d_financial_info

/*

CREATE TABLE source.historical_stock_data (
        symbol TEXT,--this will go into facts
        date DATE,
        open NUMERIC(10, 2),--this will go into facts
        high NUMERIC(10, 2),--this will go into facts
        low NUMERIC(10, 2),--this will go into facts
        close NUMERIC(10, 2),--this will go into facts
        volume INT,--this will go into facts
        dividends NUMERIC(10, 2),--this will go into facts
        stock_splits NUMERIC(10, 2)--this will go into facts
    );

*/


--Creating dimension table for company financial value.

/*

Create table dimension.di_financial_info(
 		symbol TEXT,
        date DATE,
        open NUMERIC(10, 2),
        high NUMERIC(10, 2),
        low NUMERIC(10, 2),
        close NUMERIC(10, 2),
        volume INT,
        dividends NUMERIC(10, 2),
        stock_splits NUMERIC(10, 2)
);
*/
--need to update this table to have more functionality 
--ALTER TABLE dimension.d_financial_info
--ADD CONSTRAINT unique_symbol_date UNIQUE (symbol, date);

--select * from dimension.d_financial_info where symbol = 'AIGG.L' and date = '2023-12-05'



---
--Creating a facts table. Facts table holds information from each company. 
--facts table will be a big one as this will be loaded ideally on the daily bassis. 
--
/*

create table facts.daily_facts(
		Date DATE,
		IsWeekend BOOLEAN,
		symbol TEXT,
		open NUMERIC(25, 2),
        high NUMERIC(25, 2),
        low NUMERIC(25, 2),
        close NUMERIC(25, 2),
        volume INT,
		profit_margins NUMERIC(25, 2),
    	earnings_growth NUMERIC(25, 2),
    	revenue_growth NUMERIC(25, 2)	
)

--
*/



--##
-- creating the facts table 
/*
create table facts.daily_facts(
		Date DATE,
		IsWeekend BOOLEAN,
		symbol TEXT,
		open NUMERIC(25, 2),
        high NUMERIC(25, 2),
        low NUMERIC(25, 2),
        close NUMERIC(25, 2),
        volume INT,
		profit_margins NUMERIC(25, 2),
    	earnings_growth NUMERIC(25, 2),
    	revenue_growth NUMERIC(25, 2), 
		sector Text
)
*/



--adding additional coloumn to facts table 
/*
alter table facts.daily_facts 
add column Sector VARCHAR(255)
*/

--## 
-- Creating table to store symbol and date from the fact table.
-- This will aid in ensuring the data is up to date. 
/*
Create table facts.dates_of_stock_info (
Symbol text, 
lastdate date,
todays_date date);
*/


--###
--Creating stagin table to alter add calculation to stock data


--
/*


CREATE TABLE staging.finaincial_stock_data (
        symbol TEXT,--this will go into facts
        date DATE,
        open NUMERIC(10, 2),--this will go into facts
        high NUMERIC(10, 2),--this will go into facts
        low NUMERIC(10, 2),--this will go into facts
        close NUMERIC(10, 2),--this will go into facts
        volume INT,--this will go into facts
        dividends NUMERIC(10, 2),--this will go into facts
        stock_splits NUMERIC(10, 2),--this will go into facts
		previous_close_price NUMERIC(10, 2), 
		current_close_price NUMERIC(10, 2), 
		percentage_difference_in_close NUMERIC(10, 2)
    );

--*/



--helper table

/*
CREATE TABLE staging.finance_helper_table (
        symbol TEXT,--this will go into facts
        date DATE,
        low NUMERIC(25, 6),
        close NUMERIC(25, 6)
    );

*/

