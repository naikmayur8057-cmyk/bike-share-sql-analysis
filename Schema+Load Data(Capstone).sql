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


