 SET SQL_SAFE_UPDATES = 0;
 

-- Primer fem els inserts de les tres taules principals:
-- INSERt DE RESULTS
USE F1;
DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_results $$
CREATE TRIGGER F1.trigger_results AFTER INSERT ON F1.results
FOR EACH ROW
BEGIN
	insert into F1_OLAP.RESUlTS(resultId, raceId, driverId, constructorId, number,grid, position, positionText, positionOrder , points , laps,time,milliseconds, fastestlap, rank, fastestLapTime, fastestLapSpeed, statusId)
    values (NEW.resultId, NEW.raceId, NEW.driverId, NEW.constructorId, NEW.number, NEW.grid, NEW.position, NEW.positionText, NEW.positionOrder , NEW.points , NEW.laps, NEW.time, NEW.milliseconds, NEW.fastestlap, NEW.rank, NEW.fastestLapTime, NEW.fastestLapSpeed, NEW.statusId);
    
END $$
DELIMITER ;
SELECT * FROM F1_OLAP.results;

-- INSERT RACES:

DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_races $$
CREATE TRIGGER F1.trigger_races AFTER INSERT ON F1.races
FOR EACH ROW
BEGIN
    insert into F1_OLAP.RACES (year,url,raceId,round,circuitId,name,date,time)
    values (NEW.year,NEW.url,NEW.raceId,NEW.round,NEW.circuitId,NEW.name,NEW.date,NEW.time);
END $$
DELIMITER ;	

SELECT * FROM F1_OLAP.races;

-- INSERT STANDINGS
DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_Standings $$
CREATE TRIGGER F1.trigger_Standings  AFTER INSERT ON F1.qualifying 
FOR EACH ROW
BEGIN
	INSERT INTO F1_OLAP.standings(raceId,driverId,constructorId,number,position,q1,q2,q3,qualifyId)
	VALUES(NEW.raceId,NEW.driverId,NEW.constructorId,NEW.number,NEW.position,NEW.q1,NEW.q2,NEW.q3,NEW.qualifyId);
	
END $$
DELIMITER ;
SELECT * FROM F1_OLAP.standings;


-- INSERT RESULTLAP
DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_resultlap $$
CREATE TRIGGER F1.trigger_resultlap AFTER INSERT ON F1.laptimes
FOR EACH ROW
BEGIN
	insert into F1_OLAP.resultlap(raceId, driverId, lap, position, time, milliseconds)
    values (NEW.raceId, NEW.driverId, NEW.lap, NEW.position, NEW.time, NEW.milliseconds);
    
END $$
DELIMITER ;
SELECT * FROM F1_OLAP.resultlap;

-- Fem els updates de RACES:
DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_seasons$$
CREATE TRIGGER F1.trigger_seasons AFTER INSERT ON F1.seasons
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.races
    WHERE year = NEW.year ) = 0 THEN
		insert into F1_OLAP.races(s_url, s_year)
		values (New.url, New.year);
    
	ELSE
		UPDATE F1_OLAP.races
		SET s_url = NEW.url, s_year = NEW.year
		WHERE  F1_OLAP.races.year = NEW.year;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_circuits $$
CREATE TRIGGER F1.trigger_circuits AFTER INSERT ON F1.circuits
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.races
    WHERE circuitId = NEW.circuitId ) = 0 THEN
		insert into F1_OLAP.races(c_url, c_name, c_circuitId,c_circuitRef,c_location,  c_country, c_lat, c_lng, c_alt)
		values (New.url, New.name, New.circuitId, New.circuitRef, New.location,  New.country, New.lat, New.lng, New.alt);
    
	ELSE
		UPDATE F1_OLAP.races
		SET c_url = NEW.url, c_name = NEW.name, c_circuitId = NEW.circuitId,
		c_circuitRef = NEW.circuitRef,
		c_location = NEW.location,  c_country = NEW.country, c_lat = NEW.lat,
		c_lng = NEW.lng,c_alt = NEW.alt
		WHERE F1_OLAP.races.circuitId = NEW.circuitId;
	END IF;
END $$
DELIMITER ;


SELECT * FROM F1_OLAP.races;

-- UPDATE DE RESULTS:

DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_status$$
CREATE TRIGGER F1.trigger_status AFTER INSERT ON F1.status
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.results
    WHERE StatusId = NEW.StatusId ) = 0 THEN
		insert into F1_OLAP.results(s_StatusId, s_status)
		values (NEW.StatusId,NEW.status);
    
	ELSE
		UPDATE F1_OLAP.results
		SET s_status = NEW.status, s_StatusId = NEW.statusId
		WHERE  F1_OLAP.results.statusId = New.statusId;
	END IF;

END $$
DELIMITER ;



DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_CONSTRUCTORS$$
CREATE TRIGGER F1.trigger_CONSTRUCTORS AFTER INSERT ON F1.CONSTRUCTORS
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.results
    WHERE constructorId = NEW.constructorId ) = 0 THEN
		insert into F1_OLAP.results(c_constructorId, c_constructorRef, c_name, c_nationality , c_url)
		values (NEW.constructorId, NEW.constructorRef, NEW.name, NEW.nationality, NEW.url); 
    
	ELSE
		UPDATE F1_OLAP.RESULTS
		SET c_constructorId = NEW.constructorId, c_constructorRef = NEW.constructorRef,
		c_name = NEW.name, c_nationality = NEW.nationality,  c_url = NEW.url
		WHERE  F1_OLAP.RESULTS.constructorId = NEW.constructorId;
        
	END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_DRIVERS$$
CREATE TRIGGER F1.trigger_DRIVERS AFTER INSERT ON F1.DRIVERS
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.results
    WHERE driverId = NEW.driverId ) = 0 THEN
		insert into F1_OLAP.results(d_driverId, d_driverRef, d_number, d_code, d_forename, d_surname, d_dob, d_nationality, d_url)
		values (NEW.driverId,NEW.driverRef,NEW.number, NEW.code,NEW.forename,NEW.surname,NEW.dob,NEW.nationality,NEW.url);
    
	ELSE
		UPDATE F1_OLAP.RESULTS
		SET d_driverId = NEW.driverId, d_driverRef = NEW.driverRef,
		d_number = NEW.number, d_code= NEW.code, d_forename = NEW.forename,
        d_surname = NEW.surname, d_dob= NEW.dob, d_nationality = NEW.nationality,
        d_url = NEW.url
		WHERE  F1_OLAP.RESULTS.driverId = NEW.driverId ;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_constructorResults$$
CREATE TRIGGER F1.trigger_constructorResults AFTER INSERT ON F1.CONSTRUCTORRESULTS
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.results
    WHERE constructorId = NEW.constructorId ) = 0 THEN
		INSERT INTO F1_OlAP.results(r_constructorResultsId, r_raceId, r_constructorId, r_points, r_status)
        VALUES( New.constructorResultsId, New.raceId, New.constructorId, New.points, New.status);
        
	ELSE
		UPDATE F1_OLAP.results
		SET r_constructorResultsId = NEW.constructorResultsId,
        r_raceId = new.raceId, r_constructorId = new.constructorId, 
        r_points = NEW.points,r_status =new.status
		WHERE (F1_OLAP.results.constructorId = NEW.constructorId);
	END IF;

END $$
DELIMITER ;

SELECT * FROM F1_OLAP.RESULTS;


-- Fem els updates de RESULTLAP:
DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_pitstops$$
CREATE TRIGGER F1.trigger_pitstops AFTER INSERT ON F1.pitstops
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.resultlap
    WHERE raceId = new.raceId AND driverId = NEW.driverId) = 0 THEN
		INSERT INTO F1_OlAP.resultlap(p_raceId, p_time,p_driverId, p_lap, p_stop, p_duration , p_milliseconds )
        VALUES( NEW.raceId, NEW.time,NEW.driverId, NEW.lap, NEW.stop, NEW.duration , NEW.milliseconds);
        
	ELSE
			UPDATE F1_OLAP.resultlap
			SET p_raceId = NEW.raceId, p_time = NEW.time,
			p_driverId = NEW.driverId, p_lap = NEW.lap, p_stop= NEW.stop,
			p_duration = NEW.duration, p_milliseconds = NEW.milliseconds
			WHERE  F1_OLAP.resultlap.raceId = NEW.raceId
			AND F1_OLAP.resultlap.driverId = NEW.driverId
            OR ((F1_OLAP.resultlap.driverId = NEW.driverId)
            OR  F1_OLAP.resultlap.raceId = NEW.raceId);
	END IF;
END $$
DELIMITER ;

SELECT * FROM F1_OLAP.RESULTLAP;

-- UPDATES DE STANDINGS:


DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_driverstandings $$
CREATE TRIGGER F1.trigger_driverstandings  AFTER INSERT ON F1.DRIVERSTANDINGS
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.STANDINGS
    WHERE driverId = new.driverId) = 0 THEN
    
		INSERT INTO F1_OLAP.STANDINGS(ds_driverStandingsId,ds_raceId, ds_driverId, ds_points,ds_position,ds_positionText,ds_wins)
        VALUES(NEW.driverStandingsId,NEW.raceId, NEW.driverId,NEW.points,NEW.position,NEW.positionText,NEW.wins);
	ELSE
		UPDATE F1_OLAP.STANDINGS
		SET ds_driverStandingsId = NEW.driverStandingsId,
		ds_raceId = NEW.raceId, ds_driverId = NEW.driverId, ds_points = NEW.points,
		ds_position = NEW.position, ds_positionText = NEW.positionText, ds_wins = NEW.wins WHERE
		(F1_OLAP.STANDINGS.driverId = NEW.driverId );
	END IF;
END $$
DELIMITER ;

SELECT COUNT(*) FROM F1.driverstandings;

DELIMITER $$
DROP TRIGGER IF EXISTS F1.trigger_CONSTRUCTORSTANDINGS$$
CREATE TRIGGER F1.trigger_CONSTRUCTORSTANDINGS AFTER INSERT ON F1.CONSTRUCTORSTANDINGS
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM F1_OLAP.standings
    WHERE (raceId = new.raceId )) = 0 THEN
		INSERT INTO F1_OlAP.standings(cs_constructorStandingsId, cs_raceId, cs_constructorId, cs_points,cs_position, cs_positionText,  cs_wins)
        VALUES( NEW.constructorStandingsId, NEW.raceId, NEW.constructorId, NEW.points, NEW.position, NEW.positionText,  NEW.wins);
        
	ELSE
		UPDATE F1_OLAP.standings
		SET cs_constructorStandingsId = NEW.constructorStandingsId, cs_raceId = NEW.raceId,
		cs_constructorId = NEW.constructorId, cs_points = NEW.points,
		cs_position = NEW.position, cs_positionText = NEW.positionText,  cs_wins = NEW.wins
		WHERE F1_OLAP.standings.raceId = NEW.raceId;
	END IF;
END $$
DELIMITER ;
SELECT * FROM F1_OLAP.standings;







