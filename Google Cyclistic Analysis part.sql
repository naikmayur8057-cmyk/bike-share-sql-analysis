CREATE DATABASE cyclistic;
USE cyclistic;

CREATE TABLE trips (
    ride_id VARCHAR(50) PRIMARY KEY,
    rideable_type VARCHAR(20),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(255),
    end_station_id VARCHAR(50),
    start_lat DECIMAL(10,7),
    start_lng DECIMAL(10,7),
    end_lat DECIMAL(10,7),
    end_lng DECIMAL(10,7),
    member_casual VARCHAR(20)
);

SELECT * FROM trips;

SELECT COUNT(*) AS total_rows FROM trips;

SELECT DATE_FORMAT(started_at,'%Y-%m') AS month, COUNT(*) AS rides
FROM trips
GROUP BY month
ORDER BY month;

SELECT 
  SUM(start_station_name IS NULL)                              AS null_start_station,
  SUM(end_station_name   IS NULL)                              AS null_end_station,
  SUM(TRIM(COALESCE(start_station_name,'')) = '')              AS blank_start_station,
  SUM(TRIM(COALESCE(end_station_name,''))   = '')              AS blank_end_station
FROM trips;

UPDATE trips 
SET start_station_name = NULL 
WHERE TRIM(COALESCE(start_station_name,'')) = '';

UPDATE trips 
SET end_station_name   = NULL 
WHERE TRIM(COALESCE(end_station_name,''))   = '';


UPDATE trips
SET start_station_id = NULL
WHERE start_station_id = '';


UPDATE trips
SET end_station_id = NULL
WHERE end_station_id = '';

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE trips ADD COLUMN ride_length INT NULL;
UPDATE trips
SET ride_length = TIMESTAMPDIFF(MINUTE, started_at, ended_at)
WHERE ride_length IS NULL;

SET SQL_SAFE_UPDATES = 1;

ALTER TABLE trips ADD COLUMN day_of_week VARCHAR(20) NULL;

UPDATE trips
SET day_of_week = DAYNAME(started_at)
WHERE day_of_week IS NULL;

SELECT MIN(ride_length) AS min_mins, AVG(ride_length) AS avg_mins, MAX(ride_length) AS max_mins
FROM trips;

SELECT *
FROM trips
WHERE ride_length < 0;

SELECT *
FROM trips
WHERE ride_length > 1440; 

SELECT *
FROM trips
WHERE ride_length BETWEEN 1 AND 1440;

CREATE TABLE trips_cleaned AS
SELECT *
FROM trips
WHERE ride_length BETWEEN 1 AND 1440;

SELECT * FROM trips_cleaned;

SELECT MIN(ride_length) AS min_mins, AVG(ride_length) AS avg_mins, MAX(ride_length) AS max_mins
FROM trips_cleaned;

ALTER TABLE trips_cleaned
ADD COLUMN ride_length_gen INT 
  AS (TIMESTAMPDIFF(MINUTE, started_at, ended_at)) STORED;

SELECT COUNT(*) AS total_rows
FROM trips_cleaned;

SELECT COUNT(*) AS bad_rows FROM trips_cleaned WHERE ride_length_gen <= 0 OR ended_at <= started_at;

SELECT ride_id, COUNT(*) AS c
FROM trips
GROUP BY ride_id
HAVING c > 1
LIMIT 10;

WITH ranked AS (
  SELECT 
    ride_id, started_at, ended_at,
    ROW_NUMBER() OVER (PARTITION BY ride_id ORDER BY started_at) AS rn
  FROM trips
)
SELECT * 
FROM ranked
WHERE rn > 1;

SELECT member_casual,
       COUNT(*) AS rides,
       ROUND(100*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct_of_total
FROM trips_cleaned
GROUP BY member_casual;

SELECT member_casual,
AVG(ride_length) avg_min 
FROM trips_cleaned 
GROUP BY member_casual;

SELECT member_casual,
       SUM(CASE WHEN DAYOFWEEK(started_at) BETWEEN 2 AND 6 THEN 1 ELSE 0 END) AS weekday_rides,
       SUM(CASE WHEN DAYOFWEEK(started_at) IN (1,7) THEN 1 ELSE 0 END) AS weekend_rides
FROM trips_cleaned
GROUP BY member_casual;

SELECT start_station_id, start_station_name,
       SUM(CASE WHEN member_casual='casual' THEN 1 ELSE 0 END) AS casual_rides,
       SUM(CASE WHEN member_casual='member' THEN 1 ELSE 0 END) AS member_rides
FROM trips_cleaned
GROUP BY start_station_id, start_station_name
ORDER BY casual_rides DESC;

SELECT 
    rideable_type,
    COUNT(*) AS total_rides,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM trips), 2) AS percentage_of_total
FROM trips_cleaned
GROUP BY rideable_type
ORDER BY percentage_of_total DESC;

SELECT start_station_id, start_station_name,
       SUM(member_casual='casual') AS casual_rides,
       SUM(member_casual='member') AS member_rides,
       ROUND(100 * SUM(member_casual='casual')/COUNT(*),2) AS pct_casual
FROM trips_cleaned
GROUP BY start_station_id, start_station_name
ORDER BY pct_casual DESC
LIMIT 20;