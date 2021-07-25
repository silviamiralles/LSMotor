USE F1_OLAP;


-- QUERYS:
/* 1 Cerqueu els status que mai no van passar a la història de la F1. 
Feu-ho sense fer servir subquestes.*/

SELECT DISTINCT s_statusid,s_status FROM F1_OLAP.Results
WHERE s_statusid <> statusid;
-- Entenem que si mai va passar a la historia es perque mai va participar a cap carrera,
-- llavors no hi ha cap resultat pertinent a aquell estatus.


/* 2 Busqueu la nacionalitat i el temps mitjà d'aquells conductors els equips 
dels quals tinguin el temps mitjà de parada més baix. */


SELECT r.d_nationality, AVG(r.milliseconds) AS temps_milliseconds
FROM F1_OLAP.Results AS r, F1_OLAP.RESULTLAP AS rl
WHERE r.constructorId = (	SELECT r2.constructorId
							FROM F1_OLAP.RESULTLAP AS rl2 ,F1_OLAP.Results AS r2
                            WHERE rl2.driverId = r2.driverId
                            GROUP BY (r2.constructorId)
                            ORDER BY AVG(rl2.p_milliseconds) ASC LIMIT 1)
GROUP BY r.d_driverid, r.d_nationality HAVING AVG(r.milliseconds) > 0 ; -- SELECCIONEM EL EQUIP AMB MENYS TEMPS MIG DE PIT STOP



/* 3 Busqueu els pilots (nom complet) que hagin superat el seu propi 
temps de qualificació per a cada ronda successiva, és a dir, 
millorant el seu temps a cada fase de classificació i que el seu temps
 de volta més ràpid a la cursa fos més ràpid que qualsevol de la qualificació.
 temps de qualsevol altre pilot per a aquesta cursa. A més, comproveu que aquest 
 assoliment el va aterrar al podi després de la cursa (qualsevol de les tres primeres posicions)*/

 
SELECT DISTINCT r.d_forename, r.d_surname
FROM F1_OLAP.results AS r, F1_OLAP.standings AS s
WHERE s.raceid = r.raceid 
AND (s.position = '1' OR s.position = '2' OR s.position = '3') AND s.q1 > s.q2 AND s.q2 > s.q3 
AND (r.fastestLapTime ) IN(SELECT r1.fastestLapTime 
	FROM F1_OLAP.results AS r1
	WHERE r.raceid = r1.raceid AND r1.d_driverId <> r.d_driverId 
    GROUP BY r1.driverId, r1.raceid, r1.fastestLapTime  HAVING r1.fastestLapTime >  r.fastestLapTime OR  r1.fastestLapTime =  r.fastestLapTime  ) ;

 
 /* 4Busqueu els controladors (nom complet), la velocitat i el temps de tornada més ràpids
 i el nom del circuit on els conductors hagin registrat la volta més ràpida a la cursa,
 però no la velocitat més alta o al revés.
Consell: no comproveu el temps més ràpid amb la columna quickLapTime a la taula de resultats, utilitzeu una altra informació.*/


SELECT DISTINCT r.d_forename, r.d_surname, r.fastestLapSpeed, r.fastestlap, ra.c_name
FROM F1_OLAP.Results AS r, F1_OLAP.RACES AS ra
WHERE ra.raceId = r.raceId AND
r.d_driverId in (SELECT d_driverId FROM Results WHERE (r.fastestlap <> 0)  AND r.raceId <> raceId GROUP BY raceId  HAVING MAX(r.fastestLapSpeed))
AND r.d_driverId not in(SELECT d_driverId FROM Results  WHERE (fastestLapSpeed IS NOT NULL) AND r.raceId <> raceId GROUP BY raceId HAVING MIN(fastestLapSpeed))
AND (r. fastestLapSpeed IS NOT NULL) AND (r.fastestlap <> 0)
UNION
SELECT DISTINCT r.d_forename, r.d_surname, r.fastestLapSpeed, r.fastestlap, ra.c_name
FROM F1_OLAP.Results AS r, F1_OLAP.RACES AS ra
WHERE ra.raceId = r.raceId AND
r.d_driverId not in (SELECT d_driverId FROM Results WHERE (r.fastestlap <> 0)  AND r.raceId <> raceId GROUP BY raceId  HAVING MAX(r.fastestLapSpeed))
AND r.d_driverId in(SELECT d_driverId FROM Results  WHERE (fastestLapSpeed IS NOT NULL) AND r.raceId <> raceId GROUP BY raceId HAVING MIN(fastestLapSpeed))
AND (r. fastestLapSpeed IS NOT NULL) AND (r.fastestlap <> 0);



/* 5 Comproveu la superació més gran (especificant el nom complet del conductor, circuit, any i posicions de superació) de la història de la F1,
 durant tota la cursa (no tingueu en compte la primera volta) i en un període de volta.*/


     
-- PART 1 -> lastposition (correcte)

USE F1_OLAP;

DROP TABLE IF EXISTS last_lap;
CREATE TABLE last_lap(
	driverId INTEGER,
    raceId INTEGER,
    lastLapposition INTEGER
);
SELECT * FROM last_lap;

INSERT INTO last_lap(driverId, raceId,lastLapposition )
(Select r.driverId, r.raceId, rl.position AS lastLapposition 
        From F1_OLAP.Results AS r join F1_OLAP.Resultlap AS rl inner join(
			Select r.driverId, r.raceId, max(rl.lap) AS numlaps
            from F1_OLAP.Results AS r, F1_OLAP.Resultlap AS rl
            WHERE r.driverId = rl.driverId AND r.raceId = rl.raceId
		GROUP BY r.driverId, r.raceId ) AS q ON r.driverId = q.driverId 
		AND r.raceId = q.raceId AND r.driverId = rl.driverId AND r.raceId = rl.raceId
	Where rl.lap = q.numlaps
	group by r.driverId, r.raceId, rl.position);
    
    SELECT * FROM last_lap;
    
-- PART 2 -> firstposition (correcte)

DROP TABLE IF EXISTS first_lap;
CREATE TABLE first_lap(
	driverId INTEGER,
    raceId INTEGER,
    firstLapposition INTEGER
);
SELECT * FROM first_lap;

INSERT INTO first_lap(driverId, raceId, firstLapposition)
SELECT r.driverId, r.raceId, rl.position AS firstLapposition 
From F1_OLAP.Results AS r, F1_OLAP.Resultlap AS rl 
WHERE (r.driverId = rl.driverId AND r.raceId = rl.raceId)
AND rl.lap = 2
GROUP BY r.driverId, r.raceId, rl.position;

SELECT * FROM first_lap;

	
-- FORMA FINAL 
USE F1_OLAP;
(SELECT r.d_forename, r.d_surname, c.c_name, c.year, q.overtaking
FROM F1_OLAP.races AS c JOIN F1_OLAP.results AS r ON r.raceId = c.raceId JOIN F1_OLAP.resultlap as rl ON rl.raceId = r.raceId
JOIN 
(SELECT distinct r1.driverId, r1.raceId, (query2.firstlapposition - query1.lastlapposition) AS overtaking
from F1_OLAP.Results AS r1, F1_OLAP.Resultlap AS rl1, last_lap AS query1, first_lap AS query2
WHERE r1.driverId = query1.driverId AND r1.raceId = query1.raceId 
AND query1.driverId = rl1.driverId AND query1.raceId = rl1.raceId
AND  r1.driverId = query2.driverId AND r1.raceId = query2.raceId
AND query2.driverId = rl1.driverId AND query2.raceId = rl1.raceId
ORDER BY overtaking desc limit 1) AS q ON r.driverId = q.driverId AND r.raceId = q.raceId)
UNION      
(SELECT r.d_forename, r.d_surname, c.c_name, c.year, MAX(rl.position - p2.position) AS overtaking_positions
FROM F1_OLAP.races AS c JOIN F1_OLAP.results AS r ON r.raceId = c.raceId JOIN F1_OLAP.resultlap as rl ON rl.raceId = r.raceId
JOIN (Select r.driverId, r.raceId, rl.lap, rl.position 
From F1_OLAP.Results AS r, F1_OLAP.Resultlap AS rl
WHERE (r.driverId = rl.driverId AND r.raceId = rl.raceId) AND  rl.lap <> 1 
GROUP BY r.driverId, r.raceId, rl.lap, rl.position) as p2 ON rl.driverId = p2.driverId AND rl.raceId = p2.raceId 
WHERE rl.lap <> 1 AND  (rl.lap = p2.lap - 1)
GROUP BY r.d_forename, r.d_surname, c.c_name, c.year);




	

 