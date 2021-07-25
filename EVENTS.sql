Set GLOBAL event_scheduler =on;

USE F1;
DROP TABLE IF EXISTS comprovacions;
CREATE TABLE comprovacions(
	nom_taula VARCHAR(255),
    hora TIME,
    comprovacio VARCHAR(255)
);
SELECT * FROM comprovacions;

/************ EVENTS RACES*********/
DROP TABLE IF EXISTS comp;
CREATE TABLE comp(
	sum_igual INTEGER
);
SELECT * FROM comp;

INSERT INTO comp(sum_igual)
(SELECT COUNT(*) FROM F1.races AS r
JOIN  F1.circuits AS c ON c.circuitId = r.circuitId
JOIN F1.SEASONS AS s ON r.year = s.year); -- 1040

SELECT * FROM comp;
 
INSERT INTO comp(sum_igual)
SELECT COUNT(*) FROM F1.races AS r
WHERE (r.year) NOT IN(SELECT s.year FROM  F1.seasons AS s); -- 0

INSERT INTO comp(sum_igual)
SELECT COUNT(*) FROM F1.circuits AS c
WHERE (c.circuitid) NOT IN(SELECT r.circuitid FROM F1.races AS r ); -- 1

SELECT SUM(sum_igual) FROM comp;

Set GLOBAL event_scheduler =on;
-- STORED PROCEDURE RACES
-- RACES OK
DELIMITER $$
DROP PROCEDURE IF EXISTS races_ok $$
CREATE PROCEDURE races_ok() 
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('races',current_timestamp(), 'OK');
END $$
DELIMITER ;

SELECT * FROM comprovacions;
-- RACES KO
DELIMITER $$
DROP PROCEDURE IF EXISTS races_ko $$
CREATE PROCEDURE races_ko() 
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('races',current_timestamp(), 'KO');
END $$
DELIMITER ;


SELECT * FROM comprovacions;
-- EVENTS RACES
DELIMITER $$
DROP EVENT IF EXISTS comprova_RACES $$
CREATE EVENT IF NOT EXISTS comprova_RACES
 ON SCHEDULE EVERY 5 MINUTE
COMMENT 'Comprovem la importacio de F1_OLAP.RACES'
DO BEGIN
	DECLARE equals INT DEFAULT 0;
    IF (SELECT COUNT(*) FROM F1_OLAP.RACES) = (SELECT SUM(sum_igual) FROM comp) THEN
			CALL races_ok();
		ELSE 
			CALL races_ko();
	end if;
END $$
DELIMITER ;

SELECT * FROM comprovacions;
SELECT * FROM comprovacions;

/************ EVENTS STANDINGS*********/

DROP TABLE IF EXISTS comp_standings;
CREATE TABLE comp_standings(
	sum_igual INTEGER
);
SELECT * FROM comp_standings;


INSERT INTO comp_standings(sum_igual)
SELECT COUNT(*) FROM F1.QUALIFYING AS q
WHERE (q.driverId ) IN(SELECT d.driverId FROM   F1.DRIVERSTANDINGS AS d)
AND (q.raceId )IN (SELECT c.raceId FROM  F1.CONSTRUCTORSTANDINGS AS c); -- 8352 

INSERT INTO comp_standings(sum_igual)
SELECT COUNT(*) FROM  F1.DRIVERSTANDINGS AS d
WHERE (d.driverId ) NOT  IN(SELECT q.driverId FROM  F1.QUALIFYING AS q); -- 19608 

INSERT INTO comp_standings(sum_igual)
SELECT COUNT(*) FROM F1.QUALIFYING AS q
WHERE (q.driverId ) NOT IN(SELECT d.driverId FROM   F1.DRIVERSTANDINGS AS d)
AND(q.raceId )IN (SELECT d.raceId FROM   F1.DRIVERSTANDINGS AS d); -- 2 

INSERT INTO comp_standings(sum_igual)
SELECT COUNT(*) FROM  F1.CONSTRUCTORSTANDINGS AS c
WHERE (c.raceId )NOT IN (SELECT q.raceId FROM F1.QUALIFYING AS q ); -- 8119 

SELECT SUM(sum_igual) FROM comp_standings; -- 36081

SELECT COUNT(*) FROM F1_OLAP.STANDINGS; -- 36081

Set GLOBAL event_scheduler =on;
-- STORED PROCEDURE standings
-- standings OK
DELIMITER $$
DROP PROCEDURE IF EXISTS standings_ok $$
CREATE PROCEDURE standings_ok() 
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('standings',current_timestamp(), 'OK');
END $$
DELIMITER ;

SELECT * FROM comprovacions;
-- standings KO
DELIMITER $$
DROP PROCEDURE IF EXISTS standings_ko $$
CREATE PROCEDURE standings_ko() 
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('standings',current_timestamp(), 'KO');
END $$
DELIMITER ;

SELECT * FROM comprovacions;
-- EVENTS STANDINGS
DELIMITER $$
DROP EVENT IF EXISTS comprova_STANDINGS$$
CREATE EVENT IF NOT EXISTS comprova_STANDINGS
 ON SCHEDULE EVERY 5 MINUTE
COMMENT 'Comprovem la importacio de F1_OLAP.STANDINGS'
DO BEGIN
	DECLARE equals INT DEFAULT 0;
    IF (SELECT COUNT(*) FROM F1_OLAP.STANDINGS) = (SELECT SUM(sum_igual) FROM comp_standings) THEN
			CALL standings_ok();
		ELSE 
			CALL standings_ko();
	end if;
END $$
DELIMITER ;

SELECT * FROM comprovacions;


/************ EVENTS RESULTS********/
DROP TABLE IF EXISTS comp_results;
CREATE TABLE comp_results(
	sum_igual INTEGER
);
SELECT * FROM comp_results;

INSERT INTO comp_results(sum_igual)
SELECT COUNT(*) FROM F1.results AS r
WHERE (r.constructorid )IN(SELECT cr.constructorid FROM  F1.constructorresults AS cr)
AND  (r.constructorid ) IN(SELECT cr.constructorid FROM  F1.constructors AS cr)
AND (r.driverId )IN(SELECT d.driverId FROM  F1.drivers AS d)
AND (r.statusId )IN(SELECT s.statusId FROM  F1.status AS s); -- 24332

INSERT INTO comp_results(sum_igual)
SELECT COUNT(*) FROM F1.results AS r
WHERE (r.constructorid )NOT IN(SELECT cr.constructorid FROM  F1.constructorresults AS cr); -- 288

INSERT INTO comp_results(sum_igual)
SELECT COUNT(*) FROM F1.constructors AS c
WHERE (c.constructorid ) NOT IN(SELECT r.constructorid FROM  F1.results AS r); -- 1

INSERT INTO comp_results(sum_igual)
SELECT COUNT(*) FROM F1.results AS r
WHERE (r.driverId ) NOT IN(SELECT d.driverId FROM  F1.drivers AS d); -- 0

INSERT INTO comp_results(sum_igual)
SELECT COUNT(*) FROM  F1.status AS s
WHERE (s.statusId ) NOT IN(SELECT r.statusId FROM F1.results AS r); -- 2

SELECT SUM(sum_igual) FROM comp_results; -- 24623
SELECT COUNT(*) FROM F1_OLAP.results; -- 24623

Set GLOBAL event_scheduler =on;
DELIMITER $$
DROP PROCEDURE IF EXISTS results_ok $$
CREATE PROCEDURE results_ok()
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('results',current_timestamp(), 'OK');
END $$
DELIMITER ;
-- RESULTS KO
DELIMITER $$
DROP PROCEDURE IF EXISTS results_ko $$
CREATE PROCEDURE results_ko() 
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('results',current_timestamp(), 'KO');
END $$
DELIMITER ;
-- EVENTS RESULTS
DELIMITER $$
DROP EVENT IF EXISTS comprova_RESULTS $$
CREATE EVENT IF NOT EXISTS comprova_RESULTS
 ON SCHEDULE EVERY 5 MINUTE
COMMENT 'Comprovem la importacio de F1_OLAP.RESULTS'
DO BEGIN
	DECLARE equals INT DEFAULT 0;
    IF (SELECT COUNT(*) FROM F1_OLAP.results) = (SELECT SUM(sum_igual) FROM comp_results) THEN
			CALL results_ok();
		ELSE 
			CALL results_ko();
	end if;
END $$
DELIMITER ;

SELECT * FROM comprovacions;
SELECT * FROM comprovacions;

-- OLAP (la olap nos da 3 filas de mas)
SELECT COUNT(*) FROM F1_OLAP.results; -- 24623

/* en results no existeixen dos status id que si que existeixen en status,
perque son status que no pertanyen a una carrera, per tan no hi ha resultats.
*/
SELECT * FROM F1_OLAP.results;
SELECT COUNT(*) FROM F1_OLAP.results
WHERE statusid <> s_statusid; -- 2

/*Tots els driverid de results concorden amb tots els drivers,
 es a dir tots els conductors han participat en una o mes carreres.
*/
SELECT COUNT(*) FROM F1_OLAP.results
WHERE driverid <> d_driverid; -- 0

/*hi ha un constructorid que no esta en els resultsts, 
es a dir que no esta involucrat en careras */
SELECT COUNT(*) FROM F1_OLAP.results
WHERE constructorid <> c_constructorid; -- 1

SELECT COUNT(*) FROM F1_OLAP.results
WHERE (constructorid ) <> (r_constructorid ); -- 288


/************ EVENTS RESULTLAP********/
DROP TABLE IF EXISTS comp_resultLap;
CREATE TABLE comp_resultLap(
	sum_igual INTEGER
);
SELECT * FROM comp_resultLap;

INSERT INTO comp_resultLap(sum_igual)
SELECT COUNT(*) FROM F1.lapTimes AS lt
WHERE (lt.driverId ) IN(SELECT ps.driverId FROM  F1.PitStops AS ps)
AND(lt.raceId )IN (SELECT ps.raceId FROM  F1.PitStops AS ps); -- 203696

INSERT INTO comp_resultLap(sum_igual)
SELECT COUNT(*) FROM F1.lapTimes AS lt
WHERE (lt.driverId )NOT IN(SELECT ps.driverId FROM  F1.PitStops AS ps)
AND(lt.raceId )NOT IN(SELECT ps.raceId FROM  F1.PitStops AS ps);  -- 141582

INSERT INTO comp_resultLap(sum_igual)
SELECT COUNT(*) FROM F1.lapTimes AS lt
WHERE (lt.driverId )NOT IN(SELECT ps.driverId FROM  F1.PitStops AS ps)
AND(lt.raceId ) IN(SELECT ps.raceId FROM  F1.PitStops AS ps); -- 1

INSERT INTO comp_resultLap(sum_igual)
SELECT COUNT(*) FROM F1.lapTimes AS lt
WHERE (lt.driverId )IN(SELECT ps.driverId FROM  F1.PitStops AS ps)
AND(lt.raceId ) NOT IN(SELECT ps.raceId FROM  F1.PitStops AS ps); -- 127225 

SELECT SUM(sum_igual) FROM comp_resultLap; -- 472504

Set GLOBAL event_scheduler =on;
-- RESULTLAP OK
DELIMITER $$
DROP PROCEDURE IF EXISTS resultlap_ok $$
CREATE PROCEDURE resultlap_ok()
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('resultlap',current_timestamp(), 'OK');
END $$
DELIMITER ;
-- RESULTLAP KO
DELIMITER $$
DROP PROCEDURE IF EXISTS resultlap_ko $$
CREATE PROCEDURE resultlap_ko() 
BEGIN
	INSERT INTO comprovacions(nom_taula,hora,comprovacio) VALUES ('resultlap',current_timestamp(), 'KO');
END $$
DELIMITER ;
-- EVENTS RESULTLAP
DELIMITER $$
DROP EVENT IF EXISTS comprova_RESULTLAP $$
CREATE EVENT IF NOT EXISTS comprova_RESULTLAP
 ON SCHEDULE EVERY 5 MINUTE
COMMENT 'Comprovem la importacio de F1_OLAP.RESULTLAP'
DO BEGIN
	DECLARE equals INT DEFAULT 0;
    IF (SELECT COUNT(*) FROM F1_OLAP.resultlap) = (SELECT DISTINCT SUM(sum_igual) FROM comp_resultLap) THEN
			CALL resultlap_ok();
		ELSE 
			CALL resultlap_ko();
	end if;
END $$
DELIMITER ;

SELECT * FROM comprovacions;


