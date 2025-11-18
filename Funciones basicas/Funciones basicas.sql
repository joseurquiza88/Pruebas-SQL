 -- FUNCIONES BASICAS DE CONSULTA DE SQL
 -- Se crea el esquema
CREATE DATABASE newSchema; 
-- Eliminar base de datos
DROP DATABASE newSchema; 
-- Usar la base de datos
USE newSchema;

--  Sentencia SELECT para seleccionar disintas columnas
SELECT * FROM users;
SELECT name FROM users;
SELECT name, user_id FROM users;
--  Muestra todos los registros únicos de la tabla users.
SELECT DISTINCT * FROM users;
SELECT DISTINCT age FROM users;

-- Sentencia WHERE
SELECT * FROM users WHERE age = 15;
SELECT DISTINCT age FROM users WHERE age = 15;

-- Sentencia ORDER BY ASC/DESC
SELECT * FROM users ORDER BY age DESC;

-- Combinando varias sentencias
SELECT * FROM users WHERE email = 'sara@gmail.com' ORDER BY age DESC;

-- Sentencia LIKE: devuelve todos los registros que contengan/se parezcan a '%a@gmail.com'
SELECT * FROM users WHERE email LIKE '%a@gmail.com';

#Sentencia NOT:
SELECT * FROM users WHERE NOT email = 'sara@gmail.com';

-- Sentencia AND/OR
SELECT * FROM users WHERE NOT email = 'sara@gmail.com' AND age = 36; -- 1 resultado
SELECT * FROM users WHERE NOT email = 'sara@gmail.com' OR age = 36; -- 2 resultados

-- Sentencia LIMIT para limitar la visualizacion de la info que nos devuelve la sentencia
SELECT * FROM users LIMIT 3;

-- Sentencia de tipo null
SELECT * FROM users WHERE email IS NULL;
SELECT * FROM users WHERE email IS NOT NULL;
SELECT * FROM users WHERE email IS NOT NULL AND age = 15;
-- Cuando es nulo lo cambio y le pongo un valor
SELECT *, IFNULL(age, 0) as ageCambiado FROM users;


-- Sentencia MIN MAX, el dato solo
SELECT MAX(age) FROM users; 
SELECT MIN(age) FROM users;

-- Sentencia COUNT, SUM, AVERAGE
SELECT COUNT(age) FROM users;
SELECT COUNT(email) FROM users; 
SELECT SUM(age) FROM users; 
SELECT AVG(age) FROM users; 

-- Sentencia INN, tenemos que estar seguros que coincida exactamente sino usar LIKE
SELECT * FROM users WHERE name IN ('Brais', 'sara');
SELECT * FROM users WHERE name IN ('Brais', 'sara');

-- Sentencia BETEWEEN muestra rangos de valores
SELECT * FROM users WHERE age BETWEEN 20 AND 30;

-- Setear alias a las variables con AS
 SELECT name, init_date AS 'Fecha de inicio en programacion' FROM users WHERE age BETWEEN 20 AND 30;
 
 -- Sentencia CONCAT, unir dos campos
 SELECT CONCAT(name, ' ' ,surname) AS name_surname FROM users WHERE name OR surname IS NOT NULL;
 
 --  Sentencia GROUP BY
 SELECT MAX(age) FROM users GROUP by age;
SELECT COUNT(age), age FROM users GROUP by age;
SELECT COUNT(age) AS cantidad, age FROM users GROUP by age ORDER BY cantidad DESC;
SELECT COUNT(age) AS cantidad, age FROM users WHERE age >15 GROUP by age ORDER BY cantidad DESC;

-- Sentencia HAVING
-- Montrame el  COUNT(age)  solo si el COUNT(age) es mas de 4, en este caso son 5 asique no lo va mostrar
SELECT COUNT(age) FROM users HAVING COUNT(age) > 5; 

-- Sentencia CASE, logica concreta en funcion de una condicion
--  Cuando age sea mayor a 17 en la columna agetext poner Mayor de edad sino Menor de edad
SELECT *, 
    CASE 
     WHEN age > 17 THEN 'Es mayor de edad' 
     ELSE 'Es menor de edad'
     END AS agetext
     FROM users;
     
SELECT *, 
    CASE 
     WHEN age > 17 THEN TRUE
     ELSE FALSE
     END AS 'Es mayor de edad?'
     FROM users;
     
-- Con dos WHEN  pero no funciona porque ya la primera es TRUE    
SELECT *, 
    CASE 
    --  WHEN age > 17 THEN 'Es mayor de edad' 
     WHEN age > 18 THEN 'Es mayor de edad' 
     WHEN age = 18 THEN 'Primer año mayoria de edad'
     ELSE 'Es menor de edad'
     END AS agetext
     FROM users;
     
