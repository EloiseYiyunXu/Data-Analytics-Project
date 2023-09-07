create schema EV;

use EV;
select * from electric_vehicle_population_data;

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

# Manufacture and model popularity trend in indicvidual manufacture
SELECT 
    Make, 
    Model,
    RANK() Over (partition by make order by (model) desc) as popularity_rank
FROM electric_vehicle_population_data
GROUP BY make, model
ORDER BY Make;

#Clean Alternative Fuel Vehicle (CAFV) Eligibility

#There are 3 levels of clean alternative fuel vehicle (CAFV) Eligibility
SELECT DISTINCT
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`
FROM
    electric_vehicle_population_data; 

SELECT 
    `Clean Alternative Fuel Vehicle (CAFV) Eligibility`,
    Make,
    COUNT(*) AS veihicle_count_by_each_maker
FROM
    electric_vehicle_population_data
GROUP BY `Clean Alternative Fuel Vehicle (CAFV) Eligibility` , make
ORDER BY veihicle_count_by_each_maker desc, make;

#4 ranking EV counts by each county
SELECT 
    County, COUNT(*) AS EV_count
FROM
    electric_vehicle_population_data
WHERE
    State = 'WA'
GROUP BY county
ORDER BY EV_count DESC;




