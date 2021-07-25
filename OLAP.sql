
DROP DATABASE IF EXISTS F1_OLAP;
CREATE DATABASE F1_OLAP;
USE F1_OLAP;


DROP TABLE IF EXISTS RACES;
CREATE TABLE RACES (
		index1 INTEGER auto_increment,
		-- TAULA SEASONS
		s_year INTEGER not NULL DEFAULT 0, 
		s_url VARCHAR(255),
		-- TAULA CIRCUITS
		c_circuitId INTEGER not NULL DEFAULT 0, 
		c_circuitRef VARCHAR(255), 
		c_name VARCHAR(255), 
		c_location VARCHAR(255), 
		c_country VARCHAR(255), 
		c_lat FLOAT, 
		c_lng FLOAT, 
		c_alt INTEGER,
		c_url VARCHAR(255), 
		-- TAULA RACES
		raceId INTEGER not NULL DEFAULT 0, 
		year INTEGER not NULL DEFAULT 0,
		round INTEGER not NULL DEFAULT 0,
		circuitId INTEGER not NULL DEFAULT 0,
		name VARCHAR(255),
		date DATE, 
		time TIME,
		url VARCHAR(255),
		stop INTEGER not NULL DEFAULT 0,
		driverId INTEGER NOT NULL DEFAULT 0,
		PRIMARY KEY (index1)
);


DROP TABLE IF EXISTS Standings;
CREATE TABLE Standings(
	index3 INTEGER auto_increment,
    -- TABLA QUALIFYING
	qualifyId INTEGER not NULL DEFAULT 0, 
	raceId INTEGER not NULL DEFAULT 0,
	driverId INTEGER not NULL DEFAULT 0,
	constructorId INTEGER not NULL DEFAULT 0, 
	number INTEGER not NULL DEFAULT 0,
	position INTEGER not NULL DEFAULT 0,
	q1 VARCHAR(255), 
	q2 VARCHAR(255),
	q3 VARCHAR(255),
     -- TABLA DRIVERSTANDINGS
	ds_driverStandingsId INTEGER not NULL DEFAULT 0,
	ds_raceId INTEGER not NULL DEFAULT 0,
	ds_driverId INTEGER not NULL DEFAULT 0,
	ds_points FLOAT,
	ds_position INTEGER not NULL DEFAULT 0,
	ds_positionText VARCHAR(255), 
	ds_wins INTEGER not NULL DEFAULT 0,
	-- tabla constructorStandings
	cs_constructorStandingsId INTEGER not  NULL DEFAULT 0, 
	cs_raceId INTEGER NOT   NULL DEFAULT 0,
	cs_constructorId INTEGER NOT  NULL DEFAULT 0,
	cs_points FLOAT,
	cs_position INTEGER NOT NULL DEFAULT 0,
	cs_positionText VARCHAR(255),
	cs_wins INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (index3)
		
);
SELECT * FROM F1_OLAP.Standings;


DROP TABLE IF EXISTS RESULTS;
CREATE TABLE RESULTS(
	-- tabla results
	index2 SERIAL,
	resultId INTEGER NOT NULL DEFAULT 0,
	raceId INTEGER NOT NULL DEFAULT 0,
	driverId INTEGER NOT NULL DEFAULT 0,
	constructorId INTEGER NOT NULL DEFAULT 0,
	number INTEGER NOT NULL DEFAULT 0,
	grid INTEGER NOT NULL DEFAULT 0,
	position INTEGER NOT NULL DEFAULT 0,
	positionText VARCHAR(255),
	positionOrder INTEGER NOT NULL DEFAULT 0,
	points FLOAT,
	laps INTEGER NOT NULL DEFAULT 0,
	time VARCHAR(255),
	milliseconds INTEGER NOT NULL DEFAULT 0, 
	fastestlap INTEGER NOT NULL DEFAULT 0,
	rank INTEGER NOT NULL DEFAULT 0,
	fastestLapTime VARCHAR(255), -- time
	fastestLapSpeed VARCHAR(255), -- time
	statusId INTEGER NOT NULL DEFAULT 0,
	-- Table status
	s_StatusId INTEGER NOT NULL DEFAULT 0, 
	s_status VARCHAR(255), 
	-- tabla constructors 
	c_constructorId INTEGER not NULL DEFAULT 0, 
	c_constructorRef VARCHAR(255),
	c_name VARCHAR(255), 
	c_nationality VARCHAR(255), 
	c_url VARCHAR(255),
	-- TABLA DRIVERS
	d_driverId INTEGER not NULL DEFAULT 0, 
	d_driverRef VARCHAR(255), 
	d_number INTEGER not NULL DEFAULT 0,
	d_code VARCHAR(255), 
	d_forename VARCHAR(255),
	d_surname VARCHAR(255), 
	d_dob DATE , 
	d_nationality VARCHAR(255), 
	d_url VARCHAR(255), 
	-- tabla constructor results
	r_constructorResultsId INTEGER not NULL DEFAULT 0,
	r_raceId INTEGER NOT NULL DEFAULT 0, 
	r_constructorId INTEGER NOT NULL DEFAULT 0, 
	r_points FLOAT, 
	r_status VARCHAR(255), 
	-- FOREIGN  KEY (index1) REFERENCES RACES(index1),
	PRIMARY KEY (index2)
);
SELECT * FROM F1_OLAP.Results;


DROP TABLE IF EXISTS RESULTLAP;
CREATE TABLE RESULTLAP(
	index4 INTEGER auto_increment,
	-- TAULA LAPTIMES
	raceId INTEGER not NULL DEFAULT 0, 
	driverId INTEGER NOT NULL DEFAULT 0,
	lap INTEGER NOT NULL DEFAULT 0,
	position INT,
	time TIME,
	milliseconds INTEGER not NULL DEFAULT 0, 
	-- PITSTOPS
	p_raceId INTEGER not NULL DEFAULT 0, 
	p_driverId INTEGER not NULL DEFAULT 0,
	p_stop INTEGER not NULL DEFAULT 0,
	p_lap INTEGER DEFAULT 0,
	p_time TIME, 
	p_duration VARCHAR(255),
	p_milliseconds INTEGER not NULL DEFAULT 0,
	-- FOREIGN  KEY (index1) REFERENCES RACES(index1),
	PRIMARY KEY (index4)
);
SELECT * FROM f1_OLAP.resultlap;