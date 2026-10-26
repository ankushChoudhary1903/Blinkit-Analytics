use BLINKIT

-- Aggregate total sales and calculate KPIs grouped by item fat content
SELECT SUM(total_sales) AS Total_Sales
FROM blinkit.blinkit_grocery_data_cleaned;-- Total revenue for each fat content category
go

SELECT AVG(total_sales) AS Average_Sales
FROM blinkit.blinkit_grocery_data_cleaned; -- Average revenue per sale for each fat content category
go
-- Number of distinct items in each fat content category
SELECT COUNT(DISTINCT item_identifier) AS Number_of_Items
FROM blinkit.blinkit_grocery_data_cleaned;
go
SELECT AVG(rating) AS Average_Rating-- Average customer rating for items in each fat content category
FROM blinkit.blinkit_grocery_data_cleaned;
go 
-- Aggregate total sales and calculate KPIs grouped by fat content
SELECT 
    item_fat_content,
    cast(SUM(total_sales) as decimal(10,2)) AS Total_Sales,
    cast(AVG(total_sales) as decimal(10,2)) AS Average_Sales,
    COUNT(DISTINCT item_identifier) AS Number_of_Items,
    cast(AVG(rating) as decimal(10,2)) AS Average_Rating
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY item_fat_content;
go
SELECT 
    item_type,
    SUM(total_sales) AS Total_Sales,
    AVG(total_sales) AS Average_Sales,
    COUNT(DISTINCT item_identifier) AS Number_of_Items,
    AVG(rating) AS Average_Rating
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY item_type
order by Total_Sales desc;
go
SELECT 
    outlet_location_type,
    item_fat_content,
    SUM(total_sales) AS Total_Sales,
    AVG(total_sales) AS Average_Sales,
    COUNT(DISTINCT item_identifier) AS Number_of_Items,
    AVG(rating) AS Average_Rating
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY outlet_location_type, item_fat_content
order by Total_sales ;

go
SELECT 
    Outlet_Location_Type,
    ISNULL([Low Fat], 0) AS Low_Fat,
    ISNULL([Regular], 0) AS Regular
FROM (
    SELECT 
        Outlet_Location_Type, 
        Item_Fat_Content, 
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit.blinkit_grocery_data_cleaned
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT (
    SUM(Total_Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type
;
go
SELECT 
    outlet_establishment_year,
    SUM(total_sales) AS Total_Sales,
    AVG(total_sales) AS Average_Sales,
    COUNT(DISTINCT item_identifier) AS Number_of_Items,
    AVG(rating) AS Average_Rating
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY outlet_establishment_year
order by outlet_establishment_year;

go
WITH TotalSales AS (
    SELECT SUM(total_sales) AS OverallSales
    FROM blinkit.blinkit_grocery_data_cleaned
)
SELECT 
    outlet_size,
    cast(SUM(total_sales) as decimal(10,0)) AS  Sales_By_Outlet_Size,
    (SUM(total_sales) * 100.0) / (SELECT OverallSales FROM TotalSales) AS Percentage_Of_Sales
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY outlet_size;
go
SELECT 
    outlet_location_type,
    SUM(total_sales) AS Total_Sales,
    cast((sum(Total_sales)* 100.0/sum(sum(total_sales)) over()) as decimal(10,2)) as sales_percentage  ,
    COUNT(DISTINCT item_identifier) AS Number_of_Items,
    AVG(rating) AS Average_Rating
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY outlet_location_type
order by total_sales desc;
go
SELECT 
    outlet_type,
    cast(SUM(total_sales) as decimal(10,2)) AS Total_Sales,
    cast(AVG(total_sales) as decimal(10,2)) AS Average_Sales,
    cast((sum(Total_sales)* 100.0/sum(sum(total_sales)) over()) as decimal(10,2)) as sales_percentage , 
    COUNT(*) AS Number_of_Items,
    cast(AVG(rating) as decimal(10,2)) AS Average_Rating
FROM blinkit.blinkit_grocery_data_cleaned
GROUP BY outlet_type
order by total_sales desc;
