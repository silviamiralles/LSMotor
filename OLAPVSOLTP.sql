SET SQL_SAFE_UPDATES = 0;
USE F1_OLAP;
-- 1) A simple query which involves only 1 table

-- OLAP
SELECT s_url
FROM F1_OLAP.RACES
where s_year =1999;

-- OLTP
SELECT url
FROM F1.RACES
where year =1999;

-- 2) A complex query which involves at least 5 tables
-- Aquesta query mostra el nom, cognom,nom del equip i tot el temps que ha fet pitstop de tots els corredors tenint en compte només les curses que han acabat.
-- OLTP

SELECT d.forename, d.surname, c.name,AVG(q.position) AS pos, ROUND(SUM(r.time)) AS time
FROM F1.Qualifying AS q, F1.Results As r, F1.Drivers AS d, F1.Status AS s, F1.Constructors AS c
WHERE  r.driverId = q.driverId AND d.driverId = q.driverId AND r.statusId = s.statusId
AND r.constructorId = c.constructorId 
AND status LIKE '%Finished%' AND r.time IS NOT NULL
GROUP BY d.driverId, d.forename, d.surname, c.name 
ORDER BY pos, c.name 
LIMIT 5;

-- OLAP
SELECT r.d_forename, r.d_surname, r.c_name,AVG(s.position) AS pos,ROUND(SUM(r.time)) AS time
FROM F1_OLAP.Results AS r,F1_OLAP.Standings AS s
WHERE r.driverId = s.driverId AND r.time IS NOT NULL AND r.s_status LIKE '%Finished%'
GROUP BY r.driverId, r.d_surname, r.d_forename, r.c_name
ORDER BY pos, r.c_name
LIMIT 5;

-- 3)An insert into 1 table.

-- OLTP
INSERT INTO F1.SEASONS(url ,year) VALUES ('https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship',2021);

-- OLAP
INSERT INTO F1_OLAP.RACES(s_year,s_url )VALUES (2021,'https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship');

-- 4) An update into 1 field.

-- OLTP
UPDATE F1.SEASONS
SET year = 2022
WHERE url = 'https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship';

-- OLAP
UPDATE F1_OLAP.RACES
SET year = 2022
WHERE url = 'https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship';

-- 5) A delete into 1 table.

-- OLTP
DELETE FROM F1.SEASONS
WHERE year = 2022  AND url = 'https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship';

-- OLAP
DELETE FROM F1_OLAP.RACES
WHERE year = 2022 AND url = 'https://en.wikipedia.org/wiki/2021_Formula_One_World_Championship';
