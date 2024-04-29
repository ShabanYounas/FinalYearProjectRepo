/*
This sheet is an adhoc sheet.
It has lots of testing to just ensure that data is upto date, row counts consistent, and related infromation exists.
eg the last update on financial data.
*/

---
/*

SELECT symbol, MAX(date) AS max_date, MIN(date) AS min_date, count(date)
FROM source.historical_stock_data
GROUP BY symbol
ORDER BY symbol DESC;

---
*/

--select * from source.historical_stock_data where symbol = 'ADA.L' limit 100


---select count(*) from source.historical_stock_data

--ccl ccps
--select * from source.historical_stock_data where symbol = 'CCL.L'

--select * from source.s_date

---select * from source.s_customer where address1 is null and symbol is not null;

--select * from source.s_customer


--select * from source.historical_stock_data where dividends != 0;

-- Copy all data from source_table to new_table
--INSERT INTO new_table
--SELECT * FROM source_table;
--truncate table staging.stg_historical_stock_data


--
--## Testing to see if if there are symbols that show have no stock data listed. 
--select distinct symbol from facts.daily_facts where open is null and close is null
--The above statement shows 13 symbols where the stock information is missiong.
--Now that the code has run the source database has been populated. 


--select * from source.historical_stock_data
--'HKLB.L'
/*where 
symbol = 'AAPL'--'HKLB.L' 
or symbol ='APPL.L',
or symbol ='IEBB.L', 
or symbol ='LTHP.L' ,
or symbol ='ICOV.L', 
or symbol ='IESP.L', 
or symbol ='MCON.L' ,
or symbol ='EURO.L' ,
or symbol ='FEUD.L' ,
or symbol ='GAID.L' ,
or symbol ='IEX5.L' ,
or symbol ='PUIG.L' ,
or symbol ='TFGS.L'

--
*/




--## Inserting the record into s_customer information 

/*
select max(date) as max_date, symbol from source.historical_stock_data 
group by symbol 
order by max_date desc
*/

--from dimension.d_customer where symbol = 'AAPl.'
-- order by symbol ASC
select  max(date) from source.historical_stock_data


