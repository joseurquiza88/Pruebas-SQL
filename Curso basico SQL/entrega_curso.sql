################ ENTREGA 01 #############################
-- Temática: Base de datos del Futbol Argentino
-- Creacion del SCHEMA
CREATE SCHEMA IF NOT EXISTS futbol_argentino;

-- Usamos el schema de interes
use futbol_argentino;

-- 01 Creacion tabla CAMPEONATO
CREATE TABLE IF NOT EXISTS campeonato(
    id_campeonato INT NOT NULL,
    nombreCampeonato VARCHAR(20),
    año INT,
    fechaInicio DATETIME,
    fechaFin DATETIME,
    numFechas INT,
    categoria VARCHAR(10),
    PRIMARY KEY(id_campeonato));
   
-- 02 Creacion tabla ARBITRO
CREATE TABLE IF NOT EXISTS arbitro (
    id_arbitro INT NOT NULL,
    nombre TEXT (20),
    apellido TEXT(20),
    fechaDebut date,
    edadDebut INT,
    tarjetasAmarillas INT,
    segTarjetaAmarilla INT,
    tarjetaRoja int,
    penales INT,
    temporada INT,
    PRIMARY KEY (id_arbitro) );

-- 03 Creacion tabla EQUIPOS
CREATE TABLE IF NOT EXISTS equipos(
id_equipos INT NOT NULL,
nombreEquipo VARCHAR(50),
categoria VARCHAR (50),
ciudad text (100),
estadio TEXT (100),
capacidad varchar(20),
ligaActual TEXT (100),
PRIMARY KEY (id_equipos));


-- 04 Creacion tabla PARTIDOS
CREATE TABLE IF NOT EXISTS partidos (
id_partido INT NOT NULL,
id_campeonato INT,
id_arbitro INT,
id_equipo_local INT,
id_equipo_visitante INT,
equipoLocal TEXT(10),
equipoVisitante TEXT(10),
golesLocal INT,
golesVisitante INT,
estadio TEXT(20),
fecha varchar(30),
hora varchar (5),
partido varchar (10),

PRIMARY KEY (id_partido),
FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato)  ON DELETE CASCADE,
FOREIGN KEY (id_arbitro) REFERENCES arbitro(id_arbitro) ON DELETE CASCADE,
FOREIGN KEY (id_equipo_visitante ) REFERENCES equipos(id_equipos) ON DELETE CASCADE,
FOREIGN KEY (id_equipo_local) REFERENCES equipos(id_equipos) ON DELETE CASCADE);
drop table partidos;
-- 05 Creacion tabla JUGADORES
CREATE TABLE IF NOT EXISTS jugadores(
id_jugador INT NOT NULL,
id_equipos INT,
nombre TEXT (20),
apellido TEXT(20),
club VARCHAR (50),
partidosJugados INT,
tarjetaAmarilla INT,
goles INT,
tarjetaRoja INT,
golContra INT,
golPenal INT,
posicion varchar(3),
PRIMARY KEY (id_jugador),
FOREIGN KEY (id_equipos) REFERENCES equipos(id_equipos)  ON DELETE CASCADE);  
 
-- Visualizacion de las columas
SELECT * FROM arbitro;
SELECT * FROM campeonato;
SELECT * FROM equipos;
SELECT * FROM jugadores;
SELECT * FROM partidos;
-- Informacion sobtre el tipo de dato en cada columnas
DESCRIBE arbitro;
DESCRIBE campeonato;
DESCRIBE equipos;
DESCRIBE jugadores;
DESCRIBE partidos;
################ ENTREGA 02 #############################
-- Insercion de datos TABLA ARBITRO
insert into arbitro (id_arbitro, nombre, apellido, fechaDebut,edadDEbut, tarjetasAmarillas,segTarjetaAmarilla,tarjetaRoja,penales, temporada) 
			values 
                                    -- Temporada 2021
            (1, 'Darío', 'Herrera','2015-02-16', 29,130,2,5,8,2021),
            (2, 'Diego', 'Abal','2015-02-13', 43,100,2,3,8,2021),
            (3, 'Patricio', 'Loustau','2015-02-16', 39,98,1,3,6,2021),
			(4,'Germán','Delfino','2015-02-14', 36,100,6,8,3,2021),
            (5,'Sergio','Pezzota','2015-02-22', 47,80,3,2,4,2021),
			(6,'Fernando','Echenique','2015-02-15',94,100,1,3,5,2021),
            (7,'Nestor','Pitana','2015-02-14',39,100,2,3,2,2021),
            (8,'Silvio','Trucco','2015-02-15',36, 123,2,1,2,2021),
            (9,'Diego','Ceballos','2015-02-21',null, 110,3,2,2,2021),
            (10,'Saúl','Laverni','2015-02-14',null, 95,1,5,2,2021),
            (11,'Mauro','Vigliano','2015-02-15',null, 130,2,2,2,2021),
            (12,'Fernando','Rapallini','2015-02-16', 35,80,3,5,6,2021),
			(13,'Jorge','Baliño','2015-03-07', 35,75,2,1,2,2021),
			(14,'Juan Pablo','Pompei','2015-02-15', 46,95,2,1,0,2021),
            (15,'Federico','Beligoy','2015-02-22', 45,96,2,1,2,2021),
            (16,'Pablo','Díaz','2015-02-14', 35,120,1,3,2,2021),
			(17,'Ariel','Penel','2015-02-17', 36,100,2,5,1,2021),
            (18,'Fernando','Espinoza','2015-08-03', 31,110,1,1,0,2021),
            (19,'Luis','Alvarez','2015-02-28', 31,96,2,3,2,2021),
            (20,'Pablo','Lunati','2015-02-15', 47,69,3,2,2,2021),
            (21,'Pedro','Argañaraz','2015-02-22', 35,69,2,1,1,2021),            
                        -- Temporada 2022
            (22, 'Darío', 'Herrera','2015-02-16', 29,158,6,4,6,2022),
            (23, 'Diego', 'Abal','2015-02-13', 43,127,7,6,3,2022),
            (24, 'Patricio', 'Loustau','2015-02-16', 39,151,6,12,11,2022),
			(25,'Germán','Delfino','2015-02-14', 36,164,7,5,8,2022),
            (26,'Sergio','Pezzota','2015-02-22', 47,134,9,6,10,2022),
			(27,'Fernando','Echenique','2015-02-15',34,100,3,2,6,2022),
            (28,'Nestor','Pitana','2015-02-14',39,114,6,5,6,2022),
            (29,'Silvio','Trucco','2015-02-15',36, 123,7,4,5,2022),
            (30,'Diego','Ceballos','2015-02-21',null, 124,6,6,6,2022),
            (31,'Saúl','Laverni','2015-02-14',null, 64,1,5,5,2022),
            (32,'Mauro','Vigliano','2015-02-15',null, 99,3,1,1,2022),
            (33,'Fernando','Rapallini','2015-02-16', 36,102,2,8,10,2022),
			(34,'Jorge','Baliño','2015-03-07', 35,123,9,5,5,2022),
			(35,'Juan Pablo','Pompei','2015-02-15', 46,78,5,4,1,2022),
            (36,'Federico','Beligoy','2015-02-22', 45,78,3,3,2,2022),
            (37,'Pablo','Díaz','2015-02-14', 35,92,5,3,4,2022),
			(38,'Ariel','Penel','2015-02-17', 36,69,2,6,5,2022),
            (39,'Fernando','Espinoza','2015-08-03', 31,100,4,3,4,2022),
            (40,'Luis','Alvarez','2015-02-28', 31,63,3,0,2,2022),
            (41,'Pablo','Lunati','2015-02-15', 47,47,1,3,0,2022),
            (42,'Pedro','Argañaraz','2015-02-22', 35,36,1,3,0,2022),
            
            (43, 'Darío', 'Herrera','2015-02-16', 29,46,0,3,3,2023),
            (44,'Fernando','Espinoza','2015-08-03', 31,48,0,7,0,2023),
            (45,'Hernán','Mastrángelo','2017-03-17', NULL,39,1,3,2,2023),
            (46,'Leandro ','Rey Hilfer','2019-02-09', NULL,52,3,0,1,2023),
            (47,'Silvio','Trucco','2015-02-15', 36,26,1,0,3,2023),
            (48,'Fernando','Echenique','2015-02-15',34,31,2,4,0,2023),
            (49,'Ariel','Penel','2015-02-17', 36,33,1,3,1,2023),
            (50,'Luis','Lobo Medina','2022-06-18',NULL,35,0,1,1,2023),
            (51,'Pablo','Echavarría','2017-06-04', 35,34,0,2,4,2023),
            (52,'Yael','Falcón Pérez','2019-02-03',30,41,0,2,1,2023),
            (53,'Nicolás','Ramírez','2022-07-16', 35,40,1,1,3,2023),
            (54,'Jorge','Baliño','2015-03-07', 35,26,0,1,1,2023),
            (55,'Nazareno','Arasa','2019-09-04', NULL,30,1,1,3,2023),
            (56,'Nicolás','Lamolina','2015-05-11', 32,38,2,0,3,2023),
            (60,'Fernando','Rapallini','2015-02-16', 36,17,0,0,4,2023),
            (61,'Pablo','Dóvalo','2017-06-27', 41,23,1,1,5,2023),
            (62,'Germán','Delfino','2015-02-14', 36,18,1,1,3,2023),
            (63,'Sebastián','Zunino','2021-12-04', 33,17,0,1,0,2023),
            (64,'Sebastián','Martínez','2022-10-22', 32,15,1,1,0,2023),
            (65,'Maximiliano','Ramírez','2018-04-28', NULL,4,0,0,0,2023),
            (66,'Rodrigo ','Rivero','2022-10-20', NULL,6,0,0,1,2023),
            (67,'Franco','Acita','2022-10-24', 30,2,0,1,1,2023),
            (68,'Facundo','Tello','2015-05-10', 33,55,3,5,4,2023),
			(69,'Andrés','Merlos','2015-04-04', 33,29,1,1,0,2023);    
          
-- Insercion de datos TABLA CAMPEONATO
insert into campeonato (id_campeonato, nombreCampeonato, año, fechaInicio, fechaFIn,numFechas, categoria) 
			values     
            (1, 'Liga profesional', 2021,'2021-02-16','2022-05-20',  29,'Primera'),
			(2, 'Copa de la Liga', 2021,'2021-07-16','2021-12-13',25,'Primera'),
            (3, 'Liga profesional', 2022,'2022-02-10','2022-05-22', 28,'Primera'),
             (4, 'Copa de la Liga', 2022,'2022-06-03','2022-10-25',29,'Primera'),
            (5, 'Liga profesional', 2023,'2023-01-27','2023-07-30', 29,'Primera'),
            (6, 'Copa de la Liga', 2023,'2023-08-18','2023-12-17', 28,'Primera'),
            (7, 'Copa Libertadores', 2021,'2021-02-23','2021-11-27', 30,'Primera'),
            (8, 'Copa Libertadores', 2022,'2022-02-08', '2022-10-29',32,'Primera'),
            (9, 'Copa Libertadores', 2023,'2023-02-07','2023-10-29', 32,'Primera'),          
            (10, 'Copa Sudamericana', 2021,'2021-03-17','2021-11-20', 32,'Primera'),
            (11, 'Copa Sudamericana', 2022,'2022-03-08','2022-10-01', 32,'Primera'),
            (12, 'Copa Sudamericana', 2023,'2021-03-07','2023-10-20', 32,'Primera'),
            (13, 'Copa Argentina', 2022,'2022-02-23','2022-10-30', 62,'Todos'),
            (14, 'Copa Argentina', 2023,'2023-01-24','2021-11-20', 32,'Todos'),
            (15, 'Primera B Nacional', 2021,'2021-03-12','2021-11-20', 32,'Todos'),
            (16, 'Primera B Nacional', 2022,'2022-02-11','2022-11-19', 32,'Todos'),
            (17, 'Primera B Nacional', 2023,'2023-02-03','2023-11-22', 32,'Todos');
            
-- Insercion de datos TABLA Equipos a traves de tabla externa en formato csv
# nombre del csv = equipos.csv
SELECT * FROM equipos; 
-- Insercion de datos TABLA Partidos a traves de tabla externa en formato csv
# nombre del csv = partidos.csv
SELECT * FROM partidos; 

-- Insercion de datos TABLA Jugadores a traves de tabla externa en formato csv
# nombre del csv = jugadores.csv
SELECT * FROM jugadores; 


###############################################################################
-- DESAFIO COMPLEMENTARIO CREACION DE VISTAS
select* from partidos;
-- Creamos una vista. Lo ideal es ponerle vw adelante para decir que es una vista
-- 01. Vista de los partidos a disputar por Instituto
CREATE VIEW vw_partidos_instituto as 
	SELECT *
	from partidos
	WHERE equipoLocal = "Instituto" OR equipoVisitante = "Instituto";

-- 02. Buscamos a los jugadores con mas goles y sin trjetas rojas
CREATE VIEW vw_jugadores_goles as 
SELECT *
from jugadores
WHERE goles > 0 and tarjetaRoja = 0;

-- 03. Buscamos a los arbitros de la temporada 2023
SELECT * FROM arbitro;
CREATE VIEW vw_arbitros_2023 as 
SELECT nombre, apellido
from arbitro
WHERE temporada = 2023;

-- 05. Buscamos a los defensores 
CREATE VIEW vw_jugadores_partidos as 
SELECT nombre, apellido, club
from jugadores WHERE posicion = 'Vol';

 
#######################              ENTREGA 03      ################################################
# Creacion de funciones
-- Las funciones fueron creada a traves de la funcion de MYSQL WORKBENCH.
-- Se copia y pega la funcion 
#### --- 01. func_equipo_ganador
-- La funcion equipo_ganador permite que a traves del paso de 2 parametros, equipo local
-- y el equipo visitante devuelva el nombre del equipo ganador. Esto se realiza gracias a la diferencia
-- de goles entre ambos equipos
USE `futbol_argentino`;
DROP function IF EXISTS `func_equipo_ganador`;
USE `futbol_argentino`;
DROP function IF EXISTS `futbol_argentino`.`func_equipo_ganador`;
;
DELIMITER $$
USE `futbol_argentino`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `func_equipo_ganador`(equipo_local VARCHAR(60),equipo_visitante VARCHAR(60)) 
RETURNS varchar(60) CHARSET utf8mb4
DETERMINISTIC
BEGIN
	DECLARE visitante_goles INT;
    DECLARE local_goles INT;
    DECLARE dif_goles INT;
    SET visitante_goles = (SELECT golesVisitante  FROM partidos WHERE equipoLocal = equipo_local AND equipoVisitante = equipo_visitante);
	SET local_goles = (SELECT golesLocal  FROM partidos WHERE equipoLocal = equipo_local AND equipoVisitante = equipo_visitante);
	SET dif_goles = local_goles - visitante_goles;
    IF visitante_goles = NULL OR local_goles = NULL THEN
		RETURN 'Partido pendiente';
        END IF;
    IF dif_goles < 0 THEN
		RETURN equipo_visitante;
		ELSEIF dif_goles > 0 THEN
		RETURN equipo_local;
		ELSE
		RETURN 'EMPATE' ;
	END IF;
END$$
DELIMITER ;
;

-- Prueba de la funcion equipo_ganador
SELECT futbol_argentino.func_equipo_ganador('Boca Juniors', 'Instituto') AS equipo_ganador_1;
SELECT futbol_argentino.func_equipo_ganador('Rosario Central','Argentinos Juniors') AS equipo_ganador_2;
SELECT futbol_argentino.func_equipo_ganador('Racing Club', 'Belgrano') AS equipo_ganador_3;

#### ---- Funcion 02 proximos_partidos
-- La funcion proximos_partidos permite que a traves del paso del 2 parametros, la fecha y el equipo de interes
-- devolvera el equipo contra el que jugara en la fecha interes.
--  Tambien menciona si juega de visitante o de local
USE `futbol_argentino`;
-- DROP function IF EXISTS `proximos_partidos`;


DELIMITER $$
USE `futbol_argentino`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `proximos_partidos`(num_fecha VARCHAR(60),equipo VARCHAR(60)) RETURNS varchar(60) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
	DECLARE partidoLocal_select VARCHAR (60);
    DECLARE partidoVisitante_select VARCHAR (60);
    SET partidoLocal_select = (SELECT equipoLocal FROM partidos WHERE partido = num_fecha AND (equipoLocal = equipo OR equipoVisitante = equipo));
	SET partidoVisitante_select = (SELECT equipoVisitante FROM partidos WHERE partido = num_fecha AND (equipoLocal = equipo OR equipoVisitante = equipo));
	IF partidoLocal_select = equipo  THEN
	RETURN CONCAT(equipo,' juega de local contra ',partidoVisitante_select, ' por la ', num_fecha);
    ELSE
    RETURN CONCAT(equipo, ' juega de visitante contra ',partidoLocal_select, ' por la ', num_fecha);
	END IF;
END$$

DELIMITER ;
;

######################      ENTREGA 03 - DESAFIO COMPLEMENTARIO   ##############################
-- STORED PROCEDURE
-- En ambos casos se hicieron a traves de la aplicacion del My SQL Workbench
-- El ST sp_pos_jugadores permite ordenar permitir 
-- indicar a través de un parámetro el campo de ordenamiento de una tabla y
-- mediante un segundo parámetro, si el orden es descendente o ascendente.
-- En este caso se utiliza la tabla jugadores
USE `futbol_argentino`;
DROP procedure IF EXISTS `sp_pos_jugadores`;

DELIMITER $$
USE `futbol_argentino`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_pos_jugadores`(IN col_jugador VARCHAR(50), IN tipo_orden VARCHAR(5))
BEGIN
	SET @campo = col_jugador;
	SET @orden = tipo_orden;
	SET @clausula = CONCAT('SELECT * FROM jugadores ORDER BY ',@campo, ' ' , @orden);
	PREPARE runSQL FROM @clausula;
	EXECUTE runSQL;
	DEALLOCATE PREPARE runSQL;
END$$

DELIMITER ;
;

-- Ejemplo para ejecutar del stored procedure
CALL sp_pos_jugadores('goles','ASC');

#####
-- El ST sp_delete permite eliminar aquellos equipos que descenderan la proxima temporada
-- y no seran tenidos en cuenta. Se deben ingesar 2 parametros por un lado la tabla y por otro lado
-- el equipo de interes
USE `futbol_argentino`;
DROP procedure IF EXISTS `sp_delete`;

DELIMITER $$
USE `futbol_argentino`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete`(in pNombreTabla VARCHAR(50),in equipo_descender VARCHAR(50))
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	DELETE FROM equipos WHERE nombreEquipo = equipo_descender;
     SET SQL_SAFE_UPDATES = 1;
END$$

DELIMITER ;
;

-- Ejemplo de ejecucion y prueba del registro eliminado
CALL sp_delete('equipos','Quilmes');
SELECT * FROM equipos WHERE nombreEquipo = 'Quilmes';


######################      ENTREGA 04 - DESAFIO COMPLEMENTARIO   ##############################
--								# CREACION DE TRIGGERS
-- 01. Este trigger tiene como objetivo insertar los partidos de una nueva fecha de un torneo
-- Previo a la creacion del trigger creamos la tabla donde se muestran las actualizaciones
CREATE TABLE IF NOT EXISTS new_partido (
id_partido INT PRIMARY KEY,
equipoLocal VARCHAR (30),
equipoVisitante varchar(30),
fechaActualizacion date,
usuarioActualizacion varchar(30),
tipoOperacion VARCHAR(15)
);
-- Creamos el trigger de tipo AFTER e INSERT
CREATE TRIGGER `tr_add_new_partido`
	AFTER INSERT on `partidos`
	FOR EACH ROW
	INSERT INTO `new_partido` (id_partido,equipoLocal, equipoVisitante, fechaActualizacion,usuarioActualizacion, tipoOperacion )
	VALUES (NEW.id_partido,NEW.equipoLocal, NEW.equipoVisitante, current_date(), session_user(), 'INSERT');

-- Insertamos datos en la tabla partidos para probar si funciona el trigger
INSERT INTO partidos (id_partido, id_campeonato, id_arbitro, id_equipo_local, id_equipo_visitante, equipoLocal,equipoVisitante, golesLocal, golesVisitante, estadio, fecha, hora, partido)
	VALUES (225, 5, 63, 22, 14, 'Rosario Central', 'Defensa y Justicia', 0 , 2, 'Gigante de Arroyito', '30 de mayo', '21:45', 'Fecha 17');

-- Corroboramos la tabla partido donde inseramos el registro
SELECT * FROM partidos
	WHERE id_partido = 225;
-- Corroboramos viendo la tabla donde se nos guardan las actualizaciones
SELECT * FROM new_partido;


-- 02. Este trigger tiene como objetivo actualizar el equipo de un jugador por ejemplo cuando es vendido
# a otro equipo
-- Previo a la creacion del trigger creamos la tabla donde se muestran las actualizaciones
SELECT * FROM jugadores;

CREATE TABLE IF NOT EXISTS actualizacion_jugador (
id_jugador INT PRIMARY KEY,
nombre VARCHAR (50),
apellido VARCHAR (50),
clubActual VARCHAR (50),
clubAnterior VARCHAR (50),
fechaActualizacion date,
usuarioActualizacion varchar(30),
tipoOperacion VARCHAR(15)
);

-- Creamos el trigger de tipo BEFORE  y UPDATE
CREATE TRIGGER `tr_actualizacion_jugadores`
BEFORE UPDATE on `jugadores`
FOR EACH ROW
INSERT INTO `actualizacion_jugador` (id_jugador,nombre, apellido,clubActual,clubAnterior,fechaActualizacion,usuarioActualizacion, tipoOperacion )
VALUES (NEW.id_jugador,NEW.nombre, NEW.apellido,NEW.club,OLD.club, current_date(), session_user(), 'UPDATE');
-- Se tuvo que poner eliminar el modo seguro porque saltaba error
SET SQL_SAFE_UPDATES = 0;
-- Actualizamos datos en la tabla partidos para probar si funciona el trigger
UPDATE jugadores
SET club = 'Rosario Central'
WHERE nombre = 'Lanzillotta' AND apellido = ' Federico';

-- Corroboramos la tabla partido donde insertamos el registro
SELECT * FROM jugadores WHERE nombre = 'Lanzillotta' AND apellido = ' Federico';
-- Corroboramos viendo la tabla donde se nos guardan las actualizaciones
SELECT * FROM actualizacion_jugador;

######################      ENTREGA 05 - DESAFIO COMPLEMENTARIO   ##############################
## Implementacion de sentencias que componen el sublenguaje DCL

# Creacion de dos usuarios con una contraseña dentro del localhost
drop USER 'usuario01'@'localhost';
CREATE USER 'usuario01'@'localhost' IDENTIFIED BY 'usuario01';
CREATE USER 'usuario02'@'localhost' IDENTIFIED BY 'usuario02';

# Vemos los permisos que tienen al crearlos
SELECT * FROM USER; -- No tienen permiso de nada, se los tenemos que asignar

# Asignacion de permisos
#Usuario 01 se le asgnan permisos de solo lectura a cada una de las tablas (Solo select)
GRANT SELECT ON futbol_argentino.arbitro TO 'usuario01'@'localhost';
GRANT SELECT ON futbol_argentino.campeonato TO 'usuario01'@'localhost';
GRANT SELECT ON futbol_argentino.equipos TO 'usuario01'@'localhost';
GRANT SELECT ON futbol_argentino.jugadores TO 'usuario01'@'localhost';
GRANT SELECT ON futbol_argentino.partidos TO 'usuario01'@'localhost';
# Vemos los permisos para el usuario 01
SHOW GRANTS FOR  'usuario01'@'localhost';

# Usuario 02 permisos de lectura, insercion y modificacion de datos. 
GRANT SELECT, UPDATE, INSERT ON futbol_argentino.arbitro TO 'usuario02'@'localhost';
GRANT SELECT, UPDATE, INSERT ON futbol_argentino.campeonato TO 'usuario02'@'localhost';
GRANT SELECT, UPDATE, INSERT ON futbol_argentino.equipos TO 'usuario02'@'localhost';
GRANT SELECT, UPDATE, INSERT ON futbol_argentino.jugadores TO 'usuario02'@'localhost';
GRANT SELECT, UPDATE, INSERT ON futbol_argentino.partidos TO 'usuario02'@'localhost';
# Vemos los permisos para el usuario 02
SHOW GRANTS FOR  'usuario02'@'localhost';

######################      ENTREGA 06 - DESAFIO ENTREGABLE   ##############################
## Sentencias TCL
## Se eligen 2 tablas: partidos y jugadores
# TABLA 01
# Se realizan una serie de modificaciones en los registros controladas por transacciones
#En la primera tabla, si tiene registros, deberás eliminar algunos de ellos iniciando previamente una
#transacción. Si no tiene registros la tabla, reemplaza eliminación por inserción. Deja en una línea 
#siguiente, comentado la sentencia Rollback, y en una línea posterior, la sentencia Commit.
#Si eliminas registros importantes, deja comenzado las sentencias para re-insertarlos.

-- Eliminamos el autocommit por defecto
SET SQL_SAFE_UPDATES = 0;
SET AUTOCOMMIT = 0;
SET @@autocommit = 0;

-- Vemos que tiene la tabla partidos
SELECT * FROM partidos;
# --------  01. Ejemplo de la tabla partidos   --------
-- Comenzamos con la transaccion
START TRANSACTION;
-- Eliminamos un registro segun una condicion
DELETE FROM
partidos
WHERE 
equipoLocal = 'San Lorenzo'; 

-- Probamos si se borro o no el registro. En este caso deberian aparecer los valores como null
SELECT * FROM partidos
WHERE 
equipoLocal = 'San Lorenzo';
-- Volvemos para atras, previo al delete
ROLLBACK;
-- O lo podemos dejar de forma permanente
-- COMMMIT;
-- Revisamos que se haya generado el commit o el rollback
SELECT * FROM partidos
WHERE 
equipoLocal = 'San Lorenzo';

# --------  02. Ejemplo de la tabla partidos   --------
-- Comenzamos con la transaccion
START TRANSACTION;
-- Eliminamos un registro segun una condicion
DELETE FROM
partidos
WHERE 
id_equipo_local = 5 AND id_equipo_visitante = 8; -- partido Barracas central vs Central cordoba

-- Probamos si se borro o no el registro. En este caso deberian aparecer los valores como null
SELECT * FROM partidos
WHERE 
id_equipo_local = 5 AND id_equipo_visitante = 8;
-- Volvemos para atras, previo al delete
ROLLBACK;
-- O lo podemos dejar de forma permanente
-- COMMMIT;
-- Revisamos que se haya generado el commit o el rollback
SELECT * FROM partidos
WHERE 
id_equipo_local = 5 AND id_equipo_visitante = 8;

# TABLA 02
#En la segunda tabla, inserta ocho nuevos registros iniciando también una transacción. 
#Agrega un savepoint a posteriori de la inserción del registro #4 y otro savepoint a posteriori del 
#registro 8 Agrega en una línea comentada la sentencia de eliminación del savepoint de los primeros 4 
#registros insertados.

# Tabla equipos
SELECT * FROM equipos;
-- Comenzamos transaccion
START TRANSACTION;
-- Insertamos 4 registros
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual) 
 VALUES (66, 'Comunicaciones',	'B Metropolitana',	'Buenos Aires',	'Alfredo Ramos',	3500,	'B Metropolitana');
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual) 
VALUES (67, 'San Miguel','B Metropolitana','Los Polvorines', 'Estadio Malvinas Argentinas',	7176, 'B Metropolitana');
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual) 
VALUES (68, 'Los Andes', 'B Metropolitana', 'Lomas de Zamora',	'Eduardo Gallardón', 38000,	'B Metropolitana');
INSERT INTO equipos (id_equipos, nombreEquipo, ciudad,categoria , estadio, capacidad, ligaActual)
 VALUES (69,'Villa San Carlos','B Metropolitana', 'Berisso', 'Genacio Sálice', 4000,'B Metropolitana');
-- Generamos el primer savepoint
savepoint lote_1;
-- Insertamos 4 registros mas
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual) 
VALUES (70, 'Dock Sud'	,'B Metropolitana'	,'Dock Sud', 'Estadio de los Inmigrantes' , 9500,'B Metropolitana');
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual)
 VALUES (71, 'Sacachispas'	,'B Metropolitana',	'Villa Soldati'	,'Estadio Beto Larrosa', 10000, 'B Metropolitana');
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual) 
VALUES (72, 'Argentino de Merlo', 'B Metropolitana', 'Merlo'	,'Juan Carlos Brieva', 11000, 'B Metropolitana');
INSERT INTO equipos (id_equipos, nombreEquipo, categoria ,ciudad, estadio, capacidad, ligaActual)
 VALUES (73, 'Acassuso',	'B Metropolitana','Boulogne','La Quema',	800	,'B Metropolitana');
-- Generamos el segundo savepoint
savepoint lote_2;

-- validamos algun dato del savepoint 1
SELECT * FROM equipos WHERE id_equipos = 66;

-- validamos algun dato del savepoint 
SELECT * FROM equipos WHERE id_equipos = 73;

-- Vuelvo al primer segmento
ROLLBACK TO lote_1;

-- validamos algun dato del savepoint 1 y 2
SELECT * FROM equipos WHERE id_equipos = 66;
SELECT * FROM equipos WHERE id_equipos = 73;

-- Si esta ok hacemos permanente el cambio.
-- COMMIT;
######################      ENTREGA 07 - DESAFIO ENTREGABLE   ##############################
#Backup de la base de datos
# Consignas
#Genera un backup de la base de datos de tu proyecto, incluyendo en éste solamente las tablas. 
#El backup debe incluir sólo los datos, dejando de lado su estructura. 
#Dentro del archivo .sql generado, agrega un comentario al inicio del mismo detallando los nombres de las tablas que incluiste en este backup,
# para que podamos validar que la información contenida en todas ellas, se ha generado correctamente.

# Se realizo el back up a través de administracion => data export donde se exportaron solo los datos (dump data only) en un solo archivo con
# opcion "export to self-contained file". Ademas tambien se incluyo el esquema.
# Luego se elimino el esquema 
# Las tablas que se exportaron son: jugadores, equipos, partidos, campeonatos y arbitros.
# Pasos para importar la informacion: 1ero debemos inicializar el esquema y crear las tablas ya que solo se exportaron los datos y no la estructura

-- Creacion del SCHEMA
CREATE SCHEMA IF NOT EXISTS futbol_argentino;

-- Usamos el schema de interes
use futbol_argentino;

-- 01 Debemos crear las tablas previo a la importacion de los datos
CREATE TABLE IF NOT EXISTS campeonato(
    id_campeonato INT NOT NULL,
    nombreCampeonato VARCHAR(20),
    año INT,
    fechaInicio DATETIME,
    fechaFin DATETIME,
    numFechas INT,
    categoria VARCHAR(10),
    PRIMARY KEY(id_campeonato));
   
-- 02 Creacion tabla ARBITRO
CREATE TABLE IF NOT EXISTS arbitro (
    id_arbitro INT NOT NULL,
    nombre TEXT (20),
    apellido TEXT(20),
    fechaDebut date,
    edadDebut INT,
    tarjetasAmarillas INT,
    segTarjetaAmarilla INT,
    tarjetaRoja int,
    penales INT,
    temporada INT,
    PRIMARY KEY (id_arbitro) );

-- 03 Creacion tabla EQUIPOS
CREATE TABLE IF NOT EXISTS equipos(
id_equipos INT NOT NULL,
nombreEquipo VARCHAR(50),
categoria VARCHAR (50),
ciudad text (100),
estadio TEXT (100),
capacidad varchar(20),
ligaActual TEXT (100),
PRIMARY KEY (id_equipos));


-- 04 Creacion tabla PARTIDOS
CREATE TABLE IF NOT EXISTS partidos (
id_partido INT NOT NULL,
id_campeonato INT,
id_arbitro INT,
id_equipo_local INT,
id_equipo_visitante INT,
equipoLocal TEXT(10),
equipoVisitante TEXT(10),
golesLocal INT,
golesVisitante INT,
estadio TEXT(20),
fecha varchar(30),
hora varchar (5),
partido varchar (10),

PRIMARY KEY (id_partido),
FOREIGN KEY (id_campeonato) REFERENCES campeonato (id_campeonato)  ON DELETE CASCADE,
FOREIGN KEY (id_arbitro) REFERENCES arbitro(id_arbitro) ON DELETE CASCADE,
FOREIGN KEY (id_equipo_visitante ) REFERENCES equipos(id_equipos) ON DELETE CASCADE,
FOREIGN KEY (id_equipo_local) REFERENCES equipos(id_equipos) ON DELETE CASCADE);
drop table partidos;
-- 05 Creacion tabla JUGADORES
CREATE TABLE IF NOT EXISTS jugadores(
id_jugador INT NOT NULL,
id_equipos INT,
nombre TEXT (20),
apellido TEXT(20),
club VARCHAR (50),
partidosJugados INT,
tarjetaAmarilla INT,
goles INT,
tarjetaRoja INT,
golContra INT,
golPenal INT,
posicion varchar(3),
PRIMARY KEY (id_jugador),
FOREIGN KEY (id_equipos) REFERENCES equipos(id_equipos)  ON DELETE CASCADE);  
 
 -- Importamos datos a traves de administracion ==> data import/restore ==> import fro self-contained file ==> start import
 
-- Probamos si estan todos los datos
SELECT * FROM arbitro;
SELECT * FROM campeonato;
SELECT * FROM equipos;
SELECT * FROM jugadores;
SELECT * FROM partidos;










