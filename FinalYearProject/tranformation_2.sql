---
--This is transformation 2 
--This is where fatcs table will be added and final manipulation will be made 
--The focus in transformation 2 is to work on finalising the fact table and ensure that it is working.
--This is the table structure.
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

--alter table facts.daily_facts add virtual_index TEXT

--##
--Populating the facts table. 
-- Every single row will be uniques in the table and information populated in here will come from dimensions table. 
--drop table facts.daily_facts
--
/*

--THIS SQL WILL NEED TO GO INTO PYTHON CODE
--Begin; 

truncate facts.daily_facts;

insert into facts.daily_facts(
	Date, IsWeekend, symbol,  
	open, high, low, close, volume, 
	profit_margins, earnings_growth, revenue_growth, virtual_index
) 

select 
dd.date as date, 
dd.isweekend as isweekend,
df.symbol AS symbol,
df.open AS open,
df.high AS high,
df.low AS low,
df.close AS close,
df.volume AS volume, 
dc.profit_margins AS profit_margins,
dc.earnings_growth AS earnings_growth,
dc.revenue_growth AS revenue_growth,
dc.virtual AS virtual_index

from 
	dimension.d_financial_info as df 
JOIN
    dimension.d_dated AS dd ON df.date = dd.Date
JOIN
    dimension.d_customer AS dc ON df.symbol = dc.symbol;

Commit;

--
*/	

--testing to see the result of creating the 
--select * from facts.daily_facts where virtual_index = 'Yes'



--## had to add a new column to fats table thus need to update that column 
--
/*
UPDATE facts.daily_facts AS f
SET sector = dc.sector
FROM dimension.d_customer AS dc
WHERE f.symbol = dc.symbol;

*/

--select MAX(date) from facts.daily_facts where symbol='AAPL'



--## 
--In order to make the process repeatable i need to transform more data and generate a table that will be used later. 
--The reson for that is, If a sample is performed at a facts level, the DATE of some stock is different. This could be due to market data delay.
--And the logic does not work to fill the data that is missing, for example. 
--Lets take "0NVL.L" symbol, the last stock lisetd date is 2024-01-26 which is well over a month ago. This means that i need to run the code to pull new stocl info
--Because this will impact the analysis
--Therefor, it is very important to ensure the stock data is up to date for all the symbols.
--The I will use this table to make api call based on the days and will use the last date as a reference point. 
--This by far will be most technical yet.
--Plan here is to produce a table with distinct symbols, and the maximum date of them and the currenct date and save the result to table that will 
--Be then used to automate the etl. 
 
--
/*
--THIS SQL WILL NEED TO GO INTO PYTHON CODE

Begin;

truncate facts.dates_of_stock_info;

insert into facts.dates_of_stock_info (symbol, lastdate, todays_date)
select symbol, max(date), current_date as Todays_date from source.historical_stock_data group by symbol;

COMMIT;

--
*/
--select symbol, lastdate from facts.dates_of_stock_info order by symbol ASC


