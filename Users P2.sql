USE F1_OLAP;
DROP USER IF EXISTS 'analytic_user'@'localhost','manager_user'@'localhost','rhh_user'@'localhost';


CREATE	USER IF NOT EXISTS 'analytic_user'@'localhost' IDENTIFIED BY 'password_analytic','manager_user'@'localhost'	IDENTIFIED BY 'password_manager','rrhh_user'@'localhost' IDENTIFIED BY 'password_rrhh';

GRANT SELECT, SHOW VIEW, CREATE VIEW ON F1_OLAP.* TO 'analytic_user'@'localhost';
GRANT UPDATE ON F1_OLAP.* TO 'manager_user'@'localhost'; -- Aquest user s'encarrega de fe rupdates a les taules
GRANT UPDATE ON F1.* TO 'manager_user'@'localhost'; -- Aquest user s'encarrega de fe rupdates a les taules
GRANT CREATE USER  ON *.* TO 'rrhh_user'@'localhost'; -- POT CREAR USUARIS A QUALSEVOL BBDD