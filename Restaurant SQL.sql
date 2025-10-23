# 2022 11,12 지역별 매출 (o)
# 2022 11,12 지역별 인기 많은 상품 (o)
# 2022 11,12 매출 증감률 (o)




show tables;

select * 
from restaurant
limit 0,1000;
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET SQL_SAFE_UPDATES = 0;
UPDATE restaurant
SET Date = DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m-%d');
SET SQL_SAFE_UPDATES = 1;
# --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# product : Beverages, Burgers, Chicken Sandwiches, Fries, Sides & Other
# City : Berlin, Lisbon, London, Madrid, Paris
select distinct city
from restaurant
order by 1;

#------------2022.11, 12 Purchase amount for each city------------------------------------------------------------------------------
select distinct city, round(sum(Price * Quantity),2) as Purchase_Amount, date_format(date, '%Y-%m') as PurchaseMonth
from restaurant
where year(date) = 2022 and month(date) = 11 
group by city, date_format(date, '%Y-%m')
order by date_format(date, '%Y-%m') asc;

select distinct city, round(sum(Price * Quantity),2) as Purchase_Amount, date_format(date, '%Y-%m') as PurchaseMonth
from restaurant
where year(date) = 2022 and month(date) = 12
group by city, date_format(date, '%Y-%m')
order by date_format(date, '%Y-%m') asc;

#-----------city-wise product purchase amount for November and December----------------------------------------------------------
SELECT 
    Date_format(`Date`, '%Y%-%m') AS `Date`,
    City,
    Product,
    ROUND(SUM(Price * Quantity),2) AS TotalSales
  FROM restaurant
  WHERE YEAR(`Date`) = 2022 
    AND MONTH(`Date`) = 11 or 12#12 <- December
  GROUP BY City, Product, `Date`
order by `Date` asc;

#------2022.11,12 most favorite products for each city----------------------------------------------------------------------------------------------------------

WITH CityProductSales AS (
  SELECT 
    City,
    Product,
    SUM(Price * Quantity) AS TotalSales
  FROM restaurant
  WHERE YEAR(Date) = 2022 
    AND MONTH(Date) = 11 #12 <- December
  GROUP BY City, Product
),
MaxByCity AS (
  SELECT 
    City, 
    MAX(TotalSales) AS MaxSales
  FROM CityProductSales
  GROUP BY City
)
SELECT 
  cps.City,
  cps.Product,
  ROUND(cps.TotalSales, 2) AS TotalSales
FROM CityProductSales AS cps
JOIN MaxByCity AS m
  ON m.City = cps.City
 AND m.MaxSales = cps.TotalSales
ORDER BY cps.City, cps.Product;


WITH CityProductSales AS (
  SELECT 
    City,
    Product,
    SUM(Price * Quantity) AS TotalSales
  FROM restaurant
  WHERE YEAR(Date) = 2022 
    AND MONTH(Date) = 12
  GROUP BY City, Product
),
MaxByCity AS (
  SELECT 
    City, 
    MAX(TotalSales) AS MaxSales
  FROM CityProductSales
  GROUP BY City
)
SELECT 
  cps.City,
  cps.Product,
  ROUND(cps.TotalSales, 2) AS TotalSales
FROM CityProductSales AS cps
JOIN MaxByCity AS m
  ON m.City = cps.City
 AND m.MaxSales = cps.TotalSales
ORDER BY cps.City, cps.Product;
#------2022.11,12 매출 증감률 -> 월별 상품 매출 그리고 증감률------------------------------------------------------------------------------------------------------------------------------
WITH NOVEMBER AS (
             SELECT Product, round(sum(Price*Quantity),2) as NovSales
             FROM restaurant
             WHERE YEAR(Date) = 2022 and MONTH(Date) = 11
             GROUP BY Product),
 
     DECEMBER AS (
			  SELECT Product, round(sum(Price*Quantity),2) as DecSales
              FROM restaurant
              WHERE YEAR(Date) = 2022 and MONTH(Date) = 12
              GROUP BY Product)

SELECT NOV.Product, NOV.NovSales, DECM.DecSales, 
       CONCAT(ROUND(((COALESCE(DECM.DecSales, 0) - NOV.NovSales) / NULLIF(NOV.NovSales, 0)) * 100, 2 ),'%') AS INCREMENT_RATE
FROM NOVEMBER NOV 
LEFT JOIN DECEMBER DECM ON NOV.Product = DECM.Product
ORDER BY NOV.Product;
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

























