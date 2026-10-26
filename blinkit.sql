use master;
go

if EXISTS (select 1 from sys.databases where name ='BLINKIT') 
Begin 
	Alter database BLINKIT set single_user with Rollback Immediate;
	Drop Database BLINKIT
End

create database BLINKIT;
go
use BLINKIT;
go
create schema blinkit;
go 
IF OBJECT_ID('blinkit.BlinkITGroceryData','U') is not null
	drop table blinkit.blinkit_grocery_data;
go
CREATE TABLE blinkit.blinkit_grocery_data (
    item_fat_content VARCHAR(50),
    item_identifier VARCHAR(20),
    item_type VARCHAR(100),
    outlet_establishment_year INT,
    outlet_identifier VARCHAR(20),
    outlet_location_type VARCHAR(50),
    outlet_size VARCHAR(20),
    outlet_type VARCHAR(50),
    item_visibility float,
    item_weight float,
    total_sales float,
    rating float
);
go
BULK INSERT blinkit.blinkit_grocery_data
		FROM 'C:\Users\bhavy\Downloads\drive-download-20250823T093924Z-1-001\SQL Data and Doc (Use for SQL Analysis)\BlinkIT Grocery Data.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
go
IF OBJECT_ID('blinkit.BlinkITGroceryData_cleaned','U') is not null
	drop table blinkit.blinkit_grocery_data_cleaned;
go
CREATE TABLE blinkit.blinkit_grocery_data_cleaned (
    item_fat_content VARCHAR(50),
    item_identifier VARCHAR(20),
    item_type VARCHAR(100),
    outlet_establishment_year INT,
    outlet_identifier VARCHAR(20),
    outlet_location_type VARCHAR(50),
    outlet_size VARCHAR(20),
    outlet_type VARCHAR(50),
    item_visibility float,
    item_weight float,
    total_sales float,
    rating float
    );
  
go

  insert into blinkit.blinkit_grocery_data_cleaned (item_fat_content,item_identifier,item_type,outlet_establishment_year,outlet_identifier,outlet_location_type,outlet_size,outlet_type,item_visibility,item_weight,total_sales,rating) 
  select 
    CASE 
		WHEN (item_fat_content) in ('LF','low fat') THEN 'Low Fat'
        when (item_fat_content) = 'reg' then 'Regular'
		ELSE item_fat_content
	END AS item_fat_content,
    item_identifier,item_type,outlet_establishment_year,outlet_identifier,outlet_location_type,outlet_size,outlet_type,item_visibility,item_weight,total_sales,rating from blinkit.blinkit_grocery_data

go

select * from blinkit.blinkit_grocery_data_cleaned

go