-- Sentencia INSERT
-- con 	PK 
INSERT INTO users (user_id, name, surname) VALUES (8, 'Maria', 'Lopez') ;
-- Sin PK 
INSERT INTO users (name, surname) VALUES ('Pepe', 'Lopez') ;
-- Nos salteamos PK
INSERT INTO users (user_id, name, surname) VALUES (11, 'El', 'Perez') ; 


-- Sentencia UPDATE, siempre con regla de filtrado ( con WHERE) sino cambia toda la tabla
UPDATE users SET age = 21 WHERE user_id = 11;
-- Cambiamos varios campos 
 UPDATE users SET age = 20, init_date = '2020-01-20' WHERE user_id = 11;

-- Sentencia DELETE, borrar siempre con regla de filtrado ( con WHERE) sino cambia toda la tabla (error)
DELETE FROM users WHERE user_id = 11; 

 -- 