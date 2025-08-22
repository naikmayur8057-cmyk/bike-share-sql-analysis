# bike-share-sql-analysis

Problem Statement
The raw dataset, downloaded from Kaggle, contains 12 months of bike trip records with missing values, duplicates, and inconsistent formats. These issues make it difficult to analyze customer behavior and service usage effectively.
The goal of this project is to clean the dataset, analyze usage patterns, and provide insights and recommendations to improve service efficiency and customer satisfaction.

Dataset
Source: Kaggle - Divvy Bike Trips Data
Size: 12 CSV files (one per month)
Columns: ride_id, started_at, ended_at, rideable_type, member_casual, start_station, end_station, etc.

Data Cleaning Approach
Steps performed in SQL:
Imported 12 months of trip data into MySQL.
Created master table trips_cleaned.
Handled NULLs – removed rows with missing ride IDs or station names.
Removed duplicates using ROW_NUMBER().
Fixed date/time format for consistency.
Created new columns (ride_length, day_of_week).

Analysis Performed
Average ride length by member type.
Usage trends across weekdays vs weekends.
Peak riding hours.
Popular starting & ending stations.
Monthly/seasonal variations in trips.

Key Insights
Casual riders take longer rides than members.
Weekends show higher casual usage, and weekdays show higher member usage.
Summer months see a significant spike in trips.
Specific stations are highly popular for both starting and ending rides.

Recommendations
Introduce weekend packages to convert casuals into members.
Optimize bike availability in peak hours and popular stations.
Seasonal campaigns during summer to increase engagement.
Improve station infrastructure in high-demand areas.

