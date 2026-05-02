-- 1 Total vehicles stolen
select count(*) as total_vehicle_stolen from stolen_vehicles ;
-- 2 Vehicles stolen per year
select  year(date_stolen) as year_, count(*) as total_vehicle_stolen from stolen_vehicles  group by year_;
-- 3 Most common vehicle type
select vehicle_type,count(*) from stolen_vehicles group by vehicle_type order by count(*) desc limit 1;
-- 4 Count vehicles by color
select color,count(*) from stolen_vehicles group by color;
-- 5 Oldest vehicles stolen
select * from stolen_vehicles where date_stolen=(select min(date_stolen) from stolen_vehicles);
-- 6 Newest vehicles stolen
select * from stolen_vehicles where date_stolen=(select max(date_stolen) from stolen_vehicles);
-- 7 Vehicles stolen per date
select date_stolen,count(*) number_of_stolen_vehicles from stolen_vehicles group by date_stolen;
-- 8 Vehicles with unknown  make_id(500)
select count(*) from stolen_vehicles where make_id=500;
-- 9 Vehicles with missing location
select count(*) from stolen_vehicles where location_id is null;
-- 10 Number of unique vehicle types
select count(distinct vehicle_type) as unique_vehicle_type from stolen_vehicles;
-- 11 Total vehicles with valid make_id
select count(*) as total_vehicles from stolen_vehicles s join make_details m on s.make_id=m.make_id;
-- 12 Vehicles stolen by make_id
select s.make_id,count(*) as stolen_Count from stolen_vehicles s join make_details m on s.make_id=m.make_id group by s.make_id;
-- 13 Vehicles stolen by location
select s.location_id,count(*) as stolen_count from stolen_vehicles s join locations l on s.location_id=l.location_id group by s.location_id;
-- 14 Most stolen vehicle make_id
select s.make_id, count(*) as stolen_count from stolen_vehicles s join make_details m on s.make_id=m.make_id group by s.make_id order by stolen_count desc limit 1;
-- 15 Most stolen vehicle region
select l.region,count(*) as stolen_count from stolen_vehicles s join locations l on s.location_id=l.location_id group by l.region order by stolen_count desc limit 1;
-- 16 Vehicles stolen per region
select l.region,count(*) as stolen_count from stolen_vehicles s join locations l on s.location_id=l.location_id group by l.region;
-- 17 Vehicles stolen per make_id and year
select year(date_stolen) as year_,s.make_id,count(*) as stolen_count from stolen_vehicles s join make_details m on s.make_id=m.make_id group by s.make_id,year_;
-- 18 Find the average model year of stolen vehicles
select round(avg(model_year),0)  as average_model_year from stolen_vehicles;
-- 19 Oldest model of stolen vehicles
select min(model_year) as oldest_model from stolen_vehicles;
-- 20 Newest model  of  stolen vehicles
select max(model_year) as latest_model from stolen_vehicles;
-- 21 count of stoeln vehicles by model_year
select model_year,count(*) as total_stolen_count from stolen_vehicles group by model_year;
-- 22 Find the newest model year stolen in each vehicle type
select vehicle_type,max(model_year) as latest_model from stolen_vehicles group by vehicle_type;
-- 23 Find vehicle types that were stolen more than 50 times
select vehicle_type,count(*) as stolen_count from stolen_vehicles group by vehicle_type having count(*) > 50;
-- 24  Find regions where stolen vehicles are from newer model years (after 2020)
select  l.region,count(*) as stolen_count from stolen_vehicles s join locations l  on s.location_id=l.location_id where s.model_year>2020 group by l.region;
-- 25  Find vehicles stolen in high-density regions ( consider density>100)
select s.vehicle_id,l.region,l.density from stolen_vehicles  s join locations l on s.location_id=l.location_id   where  l.density>100;
-- 26  Find vehicles where model year is greater than the average model year
select * from stolen_vehicles where model_year > (select avg(model_year) from stolen_vehicles);
-- 27 Find the number of different colors used for each vehicle type
select vehicle_type, count(distinct color) as unique_colors from stolen_vehicles group by vehicle_type;
-- 28   Find the number of vehicles stolen each month
select month(date_stolen) as month_,count(*)  as stolen_count from stolen_vehicles group by month_ order by month_ asc;
-- 29  Vehicles with missing make details
select * from stolen_vehicles s  left join make_details m on s.make_id=m.make_id where m.make_id is null;
-- 30 Vehicles with missing location details
select * from stolen_vehicles s left join locations l on s.location_id=l.location_id where l.location_id is null;
-- 31  Assign a row number to each stolen vehicle by date
select vehicle_id,vehicle_type,date_stolen, row_number() over(order by date_stolen) as row_num from stolen_vehicles;
-- 32 Rank vehicles within each region by theft date
select s.vehicle_id,l.region,s.date_stolen,rank() over(partition by l.region order by s.date_stolen) as rank_region from stolen_vehicles s join locations l on s.location_id=l.location_id;
-- 33 Count vehicles stolen per region using a CTE
with region_count as(
select l.region,count(*) as stolen_count from stolen_vehicles s join locations l on s.location_id=l.location_id group by l.region)
select * from region_count;
-- 34  Find regions with more than 500 stolen vehicles using CTE
with region_counts as (
select l.region,count(*) as total_count from stolen_vehicles s join locations l on s.location_id=l.location_id group by l.region
)
select * from region_counts where total_count>500;
-- 35  Find top 3 regions with highest stolen vehicles using CTE
with top_region as (
select l.region,count(*) as stolen_count from stolen_vehicles s join locations l on s.location_id=l.location_id group by l.region)
select region,stolen_count from top_region order by stolen_count desc limit 3;
-- 36 Rank vehicles by model year (newest first) using Dense_rank()
select vehicle_id,model_year,dense_rank()over (order by model_year desc)  as rnk_vehicles from stolen_vehicles;





