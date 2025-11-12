-- Data Cleaning of zomato bangalore restaurants dataset

select * from restaurants;
select count(*) from restaurants;

-- checking for empties in online_order column
select online_order,count(*)
from restaurants
group by online_order;

update restaurants
set online_order = null
where online_order ='';

-- cleaning rate column

SELECT DISTINCT rate FROM restaurants;

alter table restaurants
add column rate_numeric decimal(3,1);

update restaurants
set rate_numeric = case
    when rate ='NEW' then null
    when rate = '-' then null
    when rate = 'Nan' then null
    when rate = '' then null 
    when rate like '%/%' then cast(trim(substring_index(rate,'/',1))as  decimal(3,1))
    else null
end;

-- cleaning the approx_cost_for_two_people column

select distinct approx_cost_for_two_people
from restaurants
where approx_cost_for_two_people is not null and approx_cost_for_two_people !='';

alter table restaurants
add column cost_for_two int;

update restaurants
set cost_for_two = cast(replace(approx_cost_for_two_people,',','') as unsigned)
where approx_cost_for_two_people is not null and approx_cost_for_two_people !='';

SELECT approx_cost_for_two_people, cost_for_two FROM restaurants LIMIT 20;

UPDATE restaurants SET location = NULL WHERE location = '';
UPDATE restaurants SET rest_type = NULL WHERE rest_type = '';
UPDATE restaurants SET cuisines = NULL WHERE cuisines = '';
UPDATE restaurants SET dish_liked = NULL WHERE dish_liked = '';


-- cleaning reviews_list column

select * from restaurants;
SELECT 
    reviews_list AS 'before',
    REPLACE(reviews_list, '"', '') AS 'after'
FROM 
    restaurants
WHERE 
    reviews_list LIKE '%"%'; 
    
update restaurants
set reviews_list = replace(reviews_list,'"','');

select * from restaurants;

-- fixing phone column

select distinct phone
from restaurants
where length(phone)>15
and phone not like '%,%';

update restaurants
set phone = replace(phone,'/',',')
where phone like '%/%';

update restaurants
set phone = regexp_replace(phone,'(?<=\\d)\\+',',+')
where phone regexp '[0-9]\\+[0-9]';

alter table restaurants
drop column rate,
drop column approx_cost_for_two_people;

select * from restaurants;

-- Exploratory Data Analysis

-- What is the average rating and cost for restaurants in each location?

select location,round(avg(rate_numeric),1) as avg_rating,
round(avg(cost_for_two) ,1 )as avg_cost_for_two
from restaurants 
group by location
order by avg_rating desc,avg_cost_for_two asc;

-- How many restaurants offer online_order versus those that don't? Does this affect the rating?
select * from restaurants;
select online_order,count(name),round(avg(rate_numeric),2) as avg_rating
from restaurants
group by online_order; 
-- there are 30444 restaurants accepts online orders has a slightly more average rating(3.72) than 21273(3.66 rating) restaurants who don't accept online orders
-- because there might have more number of orders comparatively

-- What is the distribution of ratings? (e.g., how many have a rating > 4.5?)

select count(name) from restaurants
where rate_numeric > 4.0; -- 9216 restaurants have ratings more than 4.0

select count(name) from restaurants
where rate_numeric between 3.0 and 4.0;-- 30192 restaurants have ratings between 3.0 to 4.0
-- and rest have rating less than 3.0

-- Which restaurant name has the most branches (most COUNT) across the city?

select `name`,count(`name`) from restaurants
group by `name`
order by count(`name`) desc; -- cafe coffee day has highest branches of 96 in total in bangalore
-- Cafe Coffee Day	    96
-- Onesta	            85
-- Just Bake	        74
-- Empire Restaurant	71
-- Five Star Chicken	70

-- What are the most common rest_type (e.g., 'Quick Bites', 'Cafe', 'Dining')?
select rest_type,
count(*) as restaurant_count
from restaurants
where rest_type is not null and rest_type !=''
group by rest_type
order by restaurant_count desc
limit 10;
-- these are top 10 restaurants types with count
-- Quick Bites	19132
-- Casual Dining	10330
-- Cafe	3732
-- Delivery	2604
-- Dessert Parlor	2263
-- Takeaway, Delivery	2037
-- Casual Dining, Bar	1154
-- Bakery	1141
-- Beverage Shop	867
-- Bar	697

