----task
-- product_id, sum(sales),sum(profit)  = percentageprofit

select product_id,sum(sales), sum(profit), (sum(profit)/ sum(sales))*100 as percentageprofit from sales 
	where product_id = 'OFF-PA-10003656'
group by product_id

select product_id,sum(sales), sum(profit), (sum(profit)/ sum(sales))*100 as percentageprofit from sales 
	where product_id = 'OFF-LA-10000240'
group by product_id

select * from sales

create or replace function percentage_of_profit(productId varchar)
returns double precision as $$
declare 
	sum_of_profit float ;
	sum_of_sales float ;
BEGIN
select sum(profit) as sum_of_profit, sum(sales) as sum_of_sales
	into sum_of_profit,sum_of_sales from sales
		where product_id = productId;

		if sum_of_profit < 0 and sum_of_profit <0 then
			return null;
		else
			return (sum_of_profit / sum_of_sales) * 100;
	end if;
end;
$$ language plpgsql;

SELECT product_id, percentage_of_profit(product_id) AS percent_of_profit
FROM sales group by product_id ;

select percentage_of_profit('OFF-PA-10003656')
	
select percentage_of_profit('FUR-BO-10001798')

select product_id, percentage_of_profit('OFF-LA-10000240') from sales

select *, percentage_of_profit(product_id) from sales

-----------------------------------------------------------------------------------------------------

select * from sales

select * from customer

select * from product


	---calculate the profit percentage of sales data with age wise
select sum(s.profit) as "sumofprofit" ,sum(s.sales) as sumofsales,
 (sum(s.profit)/sum(s.sales))*100 as "ProfitPercentage" from sales as s    
inner join customer as c
on s.customer_id = c.customer_id
	where c.age = 40
group by c.age

	
create or replace function getprofit_percent_of_sales_by_age(age_number integer)
returns double precision as $$
declare
	sum_of_profit double precision;
	sum_of_sales double precision;
	profit_percentage double precision;
BEGIN
	select  sum(s.profit) as sum_of_profit , sum(s.sales) sum_of_sales into sum_of_profit,sum_of_sales 
	from sales as s
	inner join customer as c
	on s.customer_id = c.customer_id
	where c.age  = age_number;
	profit_percentage := (sum_of_profit/sum_of_sales)*100;
	return profit_percentage;
END;
$$ LANGUAGE plpgsql;

select distinct age,getprofit_percent_of_sales_by_age(age) from customer where age = 40;

select getprofit_percent_of_sales_by_age(40);

select getprofit_percent_of_sales(66);

select *, getprofit_percent_of_sales_by_age(age) from customer
----------------------------------------------------------------------------------------------------------------------

select * from sales

select sum(sales) as sum_of_sales, sum(quantity) as sum_of_quantity, sum(profit) as sum_of_profit, 
sum(sales) / sum(quantity) as per_qty_price
--(sum(sales)/ sum(quantity))-(sum(profit)/ sum(quantity)) as without_profit_price_per_qty,
--(sum(sales)/sum(quantity)) * sum(discount) as discount_amt_per_qty 
	from sales
where  order_date = '2016-11-08'
	group by order_date

select sales,quantity , sales / quantity as discount_amt from sales

create or replace function get_some_calculationby_order_date(OrderDate date)
returns double precision as $$
declare
	sum_of_sales double precision;
	sum_of_quantity double precision;
	sum_of_profit double precision;
	per_qty_price double precision;
begin
	select sum(sales) as sum_of_sales, 
	sum(quantity) as sum_of_quantity, 
	sum(profit) as sum_of_profit 
	into sum_of_sales,sum_of_quantity,sum_of_profit
    from sales 
	where  order_date = OrderDate;

	per_qty_price :=  sum_of_sales / sum_of_quantity;
	return per_qty_price;

end;
$$ language plpgsql;

select get_some_calculationby_order_date('2016-11-08');
	
select  sum(sales) as sum_of_sales, 
	sum(quantity) as sum_of_quantity, 
	sum(profit) as sum_of_profit , 
	 get_some_calculationby_order_date('2016-11-08') from sales


-----------------------------------------------------------------------------------------------------------
select * from customer
select * from sales
	

select c.segment, c.age,c.country, sum(s.sales) as sum_sales,
sum(s.quantity) as sum_quantity, sum(s.profit) as sum_profit ,
(sum(s.profit)/sum(s.sales)) * 100 as percent_sales
from sales as s
inner join customer as c
on s.customer_id = c.customer_id
--where c.segment = 'Consumer' and c.age = 19 and c.country = 'United States'
where c.segment = 'Home Office' and c.age = 57	and c.country = 'United States'
group by c.segment, c.age,c.country

--"Consumer"	19	"United States"	26046.348999999995	380	4606.444399999996	17.685566602827894
--"Home Office"	57	"United States"	11675.990000000002	144	2729.668600000001	23.378476685917
	
create or replace function get_perc_customer_age_seg_country(c_segment varchar,c_age int,c_country varchar)
returns double precision as $$
declare 
	sum_sales double precision;
	sum_quantity double precision;
	sum_profit double precision;
	perc_customer double precision;
begin
select  sum(s.sales) as sum_sales,
sum(s.quantity) as sum_quantity, sum(s.profit) as sum_profit into sum_sales,sum_quantity,sum_profit
from sales as s
inner join customer as c
on s.customer_id = c.customer_id
where c.segment = c_segment and c.age = c_age and c.country = c_country;

perc_customer = (sum_profit/sum_sales)*100;
return perc_customer;

end;
$$ language plpgsql

SELECT get_perc_customer_age_seg_country('Consumer', 19, 'United States') AS perc_profit;

select get_perc_customer_age_seg_country('Home Office', 57, 'United States') as perc_profit;

select *,get_perc_customer_age_seg_country('Consumer', 19, 'United States') from sales;

select s.*, get_perc_customer_age_seg_country('Home Office', 57, 'United States') from sales  as s;












