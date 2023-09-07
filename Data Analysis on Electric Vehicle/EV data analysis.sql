drop schema EV;
create schema EV;

use EV;
select * from electric_vehicle_population_data;

#Total EV registration by city
SELECT
	COUNT(*), City, State
FROM 
	electric_vehicle_population_data
GROUP BY
	City, State
ORDER BY
	COUNT(*) DESC
LIMIT 10;

#BEVs HPEVs type of EVs usage percentage by total cities
SELECT 
	BEV/total_city as percentage_of_BEV,
    1-BEV/total_city as percentage_of_HPEV
FROM
	(SELECT COUNT('Electric Vehicle Type') as BEV
	FROM 
		electric_vehicle_population_data
	WHERE
	'Electric Vehicle Type' like '%BEV%') as sub1,
    (SELECT COUNT('Electric Vehicle Type') as total_city
    FROM
		electric_vehicle_population_data) as sub2;

#Tesla popularity trend
SELECT
	Make,
    Model,
    COUNT(*),
    RANK() OVER (PARTITION BY make ORDER BY (count(*)) DESC) AS popularity_rank
FROM
	electric_vehicle_population_data
WHERE
	Make = 'Tesla'
GROUP BY
	make, model
ORDER BY 
	COUNT(*) DESC;
    
#Time Series Visualization
SELECT
    `Model Year`,
    COUNT(*) AS VehicleCount,
    LAG(COUNT(*)) OVER (ORDER BY `Model Year`) AS PreviousYearCount
FROM
    electric_vehicle_population_data
GROUP BY
    `Model Year`
ORDER BY
    `Model Year` desc;

# Manufacture and model popularity trend in individual manufacture
SELECT 
    Make, 
    Model,
    RANK() Over (partition by make order by (model) desc) as popularity_rank
FROM electric_vehicle_population_data
GROUP BY make, model
ORDER BY Make;


#Clean Alternative Fuel Vehicle (CAFV) Eligibility analysis base on the manufacture
SELECT 
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`,
    Make,
    COUNT(*) AS veihicle_count_by_each_maker
FROM
    electric_vehicle_population_data
GROUP BY `Clean Alternative Fuel Vehicle (CAFV) Eligibility` , make
ORDER BY veihicle_count_by_each_maker desc, make;

#Ranking EV counts by each county, growth percentage for each country
SELECT 
    sub_1.county,
    EV_count_2022,
    EV_count_2021,
    CONCAT(ROUND(((EV_count_2022 - EV_count_2021) / EV_count_2021) * 100, 2), '%') AS EV_growth_rate_percentage
FROM
	(SELECT
		County, COUNT(*) AS EV_count_2022
	FROM
		electric_vehicle_population_data
	WHERE
		State = 'WA' AND 'Model Year' = 2022
	GROUP BY county
    ORDER BY EV_count_2022 DESC) AS sub_1
INNER JOIN
	(SELECT
		County, COUNT(*) AS EV_count_2021
	FROM
		electric_vehicle_population_data
	WHERE
		State = 'WA' AND 'Model Year' = 2021
	GROUP BY county
    ORDER BY EV_count_2021 DESC) AS sub_2 ON sub_1.county = sub_2.county
ORDER BY EV_count_2022 DESC
LIMIT 20;

