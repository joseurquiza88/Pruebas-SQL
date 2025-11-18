-- ------ CONCEPTOS AVANZADOS --------
-- Triggers 
-- Intrucciones que se disparan cuando ocurre algo en una tabla concreta pasa algo
-- CREATE TRIGGER tg_email
-- BEFORE/AFTER INSERT/UPDATE/DELETE
-- ON users
DELIMITER //
CREATE TRIGGER tg_email
AFTER UPDATE ON users
FOR EACH ROW
BEGIN
    IF OLD.email <> NEW.email THEN
        INSERT INTO email_history (user_id, email)
        VALUES (OLD.user_id, OLD.email);
    END IF;
END //
DELIMITER ;
-- Probando el trigger
UPDATE users SET email = "mouredevvvv@gmail.com" WHERE user_id =1;
-- Se guardo la info 
SELECT * FROM email_history;
-- Eliminar trigger
DROP TRIGGER tg_email;


-- VIEWS
-- Representacion visual de una tabla, son para simplificar consultas complejas
 CREATE VIEW v_adult_ages AS
 SELECT name, age
 FROM users
 WHERE age >=18;
 
SELECT * FROM v_adult_ages;
SELECT * FROM users;
-- Pero si actualizamos las edades la vista se actualiza
-- Hay que pensar si realmente vale la pena la vista o dejarla como tabla 
UPDATE `newschema`.`users` SET `age` = '15' WHERE (`user_id` = '3');
SELECT * FROM v_adult_ages;
SELECT * FROM users;

-- Eliminar trigger
DROP VIEW v_adult_ages;


-- Procedimiento almacenado
-- Almacenamos una query para volver a usar despues
DELIMITER //
CREATE PROCEDURE p_all_users (IN age int)
BEGIN
	SELECT * FROM users WHERE age = age;
END //
DELIMITER ;

CALL p_all_users(30);
DROP PROCEDURE p_all_users;

-- Transaccion





















