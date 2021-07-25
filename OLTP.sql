DROP DATABASE IF EXISTS F1;
CREATE DATABASE F1;
USE F1;

DROP TABLE IF EXISTS STATUS;
CREATE TABLE STATUS (StatusId INTEGER not NULL DEFAULT 0, 
                status VARCHAR(255), 
                PRIMARY KEY ( StatusId )
);
SELECT * FROM status
ORDER BY status;
-- 1
DROP TABLE IF EXISTS SEASONS;
CREATE TABLE SEASONS (year INTEGER not NULL DEFAULT 0, 
				url VARCHAR(255),
				PRIMARY KEY ( year)
);
SELECT * FROM SEASONS;
-- 2
DROP TABLE IF EXISTS CIRCUITS;
 CREATE TABLE CIRCUITS (
				 circuitId INTEGER not NULL DEFAULT 0, 
                 circuitRef VARCHAR(255), 
                 name VARCHAR(255), 
                 location VARCHAR(255), 
                 country VARCHAR(255), 
                 lat FLOAT, 
                 lng FLOAT, 
                 alt INTEGER not NULL DEFAULT 0,
                 url VARCHAR(255), 
                 PRIMARY KEY ( circuitId)
);
SELECT * FROM CIRCUITS;
-- 3
DROP TABLE IF EXISTS DRIVERS;
CREATE TABLE DRIVERS 
                (driverId INTEGER not NULL DEFAULT 0, 
                driverRef VARCHAR(255), 
                number INTEGER not NULL DEFAULT 0,
                 code VARCHAR(255), 
                 forename VARCHAR(255),
                 surname VARCHAR(255), 
                 dob DATE , 
				 nationality VARCHAR(255), 
                 url VARCHAR(255), 
                 PRIMARY KEY (driverId)
);
SELECT * FROM DRIVERS;
-- 4
DROP TABLE IF EXISTS CONSTRUCTORS;
CREATE TABLE CONSTRUCTORS (constructorId INTEGER not NULL DEFAULT 0, 
                constructorRef VARCHAR(255),
                name VARCHAR(255), 
                nationality VARCHAR(255), 
                url VARCHAR(255),
				PRIMARY KEY (constructorId)
);
SELECT * FROM CONSTRUCTORS;
-- 5
DROP TABLE IF EXISTS QUALIFYING ;
CREATE TABLE QUALIFYING 
                (qualifyId INTEGER not NULL DEFAULT 0, 
                raceId INTEGER not NULL DEFAULT 0,
                driverId INTEGER not NULL DEFAULT 0,
                constructorId INTEGER not NULL DEFAULT 0, 
                number INTEGER not NULL DEFAULT 0,
                position INTEGER not NULL DEFAULT 0,
                q1 VARCHAR(255), 
                q2 VARCHAR(255),
                q3 VARCHAR(255), 
                 PRIMARY KEY (qualifyId)
);

-- 6
DROP TABLE IF EXISTS RACES;
CREATE TABLE RACES(raceId INTEGER not NULL DEFAULT 0, 
                year INTEGER not NULL DEFAULT 0,
                round INTEGER not NULL DEFAULT 0,
                circuitId INTEGER not NULL DEFAULT 0,
                name VARCHAR(255),
                date DATE, 
                time TIME,
                url VARCHAR(255),
                PRIMARY KEY (raceId)
);
-- 7
DROP TABLE IF EXISTS RESULTS;
CREATE TABLE RESULTS(resultId INTEGER not NULL DEFAULT 0,
                raceId INTEGER not NULL DEFAULT 0,
                driverId INTEGER not NULL DEFAULT 0,
                constructorId INTEGER not NULL DEFAULT 0,
                number INTEGER not NULL DEFAULT 0,
                grid INTEGER not NULL DEFAULT 0,
                position INTEGER not NULL DEFAULT 0,
                positionText VARCHAR(255),
                positionOrder INTEGER not NULL DEFAULT 0,
                points FLOAT,
                laps INTEGER not NULL DEFAULT 0,
                time VARCHAR(255),
                milliseconds INTEGER not NULL DEFAULT 0, 
                fastestlap INTEGER not NULL DEFAULT 0,
                rank INTEGER not NULL DEFAULT 0,
                fastestLapTime VARCHAR(255),
                fastestLapSpeed VARCHAR(255), 
                statusId INTEGER not NULL DEFAULT 0, 
                PRIMARY KEY (resultId)
);
SELECT * FROM RESULTS;
-- 8
DROP TABLE IF EXISTS LAPTIMES;
CREATE TABLE LAPTIMES(
				raceId INTEGER not NULL DEFAULT 0, 
                driverId INTEGER not NULL DEFAULT 0,
                lap INTEGER not NULL DEFAULT 0,
                position INTEGER not NULL DEFAULT 0,
                time TIME,
				milliseconds INTEGER not NULL DEFAULT 0, 
				PRIMARY KEY (raceId,driverId,lap)
);
SELECT * FROM LAPTIMES;

-- 9
DROP TABLE IF EXISTS PITSTOPS;
CREATE TABLE PITSTOPS(
				 raceId INTEGER not NULL DEFAULT 0, 
                 driverId INTEGER not NULL DEFAULT 0,
                 stop INTEGER not NULL DEFAULT 0,
                 lap INTEGER not NULL DEFAULT 0,
                 time TIME , 
                 duration VARCHAR(255),
                 milliseconds INTEGER not NULL DEFAULT 0,
                 PRIMARY KEY (raceId,driverId,stop)
);
SELECT * FROM PITSTOPS;
-- 10
DROP TABLE IF EXISTS CONSTRUCTORRESULTS;
CREATE TABLE CONSTRUCTORRESULTS(
				constructorResultsId INTEGER not NULL DEFAULT 0,
                raceId INTEGER not NULL DEFAULT 0, 
                constructorId INTEGER not NULL DEFAULT 0, 
                points FLOAT, 
                status VARCHAR(255), 
				PRIMARY KEY (constructorResultsId)
);
SELECT * FROM CONSTRUCTORRESULTS;
SELECT DISTINCT * FROM CONSTRUCTORRESULTS;
-- 11
DROP TABLE IF EXISTS CONSTRUCTORSTANDINGS;
CREATE TABLE CONSTRUCTORSTANDINGS(
				constructorStandingsId INTEGER not NULL DEFAULT 0, 
                raceId INTEGER not NULL DEFAULT 0,
                constructorId INTEGER not NULL DEFAULT 0,
                points FLOAT,
                position INTEGER not NULL DEFAULT 0,
                positionText VARCHAR(255),
                wins INTEGER not NULL DEFAULT 0,
				PRIMARY KEY (constructorStandingsId)
);
SELECT * FROM CONSTRUCTORSTANDINGS;
-- 12
DROP TABLE IF EXISTS DRIVERSTANDINGS;
CREATE TABLE DRIVERSTANDINGS(
				driverStandingsId INTEGER not NULL DEFAULT 0,
                raceId INTEGER not NULL DEFAULT 0,
                driverId INTEGER not NULL DEFAULT 0,
                points FLOAT,
                position INTEGER not NULL DEFAULT 0,
                positionText VARCHAR(255), 
                wins INTEGER not NULL DEFAULT 0,
                PRIMARY KEY (driverStandingsId)
);
-- 13
SELECT * FROM F1.DRIVERSTANDINGS;

