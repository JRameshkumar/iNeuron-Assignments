CREATE DATABASE UK_SAFETY_DATABASE;
USE UK_SAFETY_DATABASE;

/* -------------------------------- */
/* CREATE TABLES AND LOAD THE DATASET */

CREATE TABLE accident(
	accident_index VARCHAR(20) NOT NULL,
    accident_severity INTEGER NOT NULL
);

CREATE TABLE vehicles(
	accident_index VARCHAR(20) NOT NULL,
    vehicle_type VARCHAR(50) NOT NULL
);

CREATE TABLE vehicle_types(
	vehicle_code INTEGER NOT NULL,
    vehicle_type VARCHAR(60) NOT NULL
);


/* -------------------------------- */
/* LOAD THE DATASET */

LOAD DATA INFILE 'G:\\iNeuron Assignments\\MySQL assignments\\02.UK Road Safty Accidents 2015\\datasets\\Accidents_2015.csv'
INTO TABLE accident
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2;

SELECT * FROM accident;

LOAD DATA INFILE 'G:\\iNeuron Assignments\\MySQL assignments\\02.UK Road Safty Accidents 2015\\datasets\\Vehicles_2015.csv'
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;

SELECT * FROM vehicles;

LOAD DATA INFILE 'G:\\iNeuron Assignments\\MySQL assignments\\02.UK Road Safty Accidents 2015\\datasets\\vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM vehicle_types;

/* Task 1 Evaluate the median severity value of accidents caused by various Motorcycles */
/*Creating Table for accidents_median */

CREATE TABLE accidents_median(
vehicle_types VARCHAR(100) NOT NULL,
severity INTEGER NOT NULL);

/* Computing the Data Analysis */
/*Creating the Index on the accident index for faster computation */

CREATE INDEX accident_index
ON accident(accident_index);

CREATE INDEX accident_index
ON vehicles(accident_index);


/* Task 2 Evaluate Accident Severity and Total Accidents per Vehicle Type */
SELECT vt.vehicle_type as 'Vehicle Type', a.accident_severity as 'Severity', count(vt.vehicle_type) as 'Number of Accidents'
from accident a
inner join 
vehicles v 
on 
a.accident_index = v.accident_index
inner join 
vehicle_types vt 
on 
v.vehicle_type = vt.vehicle_code
group by 1
order by 2,3;

/*Task 3 Calculate the Average Severity by vehicle type */
SELECT vt.vehicle_type as 'Vehicle Type', avg(a.accident_severity) as 'Average Severity', count(vt.vehicle_type) as 'Number of Accidents'
from accident a
inner join vehicles v on a.accident_index = v.accident_index
inner join vehicle_types vt on v.vehicle_type = vt.vehicle_code
group by 1
order by 2,3;

/* Task 4 Calculate the Average Severity and Total Accidents by Motorcycle. */
SELECT vt.vehicle_type as 'Vehicle Type', avg(a.accident_severity) as 'Average Severity', count(vt.vehicle_type) as 'Number of Accidents'
from accident a
inner join vehicles v on a.accident_index = v.accident_index
inner join vehicle_types vt on v.vehicle_type = vt.vehicle_code
where vt.vehicle_type like '%motorcycle%'
group by 1
order by 2,3;

