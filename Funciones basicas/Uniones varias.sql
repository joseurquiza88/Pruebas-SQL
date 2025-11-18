-- LEFT JOIN: trae toda la primera tabla y lo coincide de la segunda

SELECT * FROM users
LEFT JOIN dni
ON users.user_id = dni.user_id;
-- RIGHT JOIN: trae toda la segunda tabla y lo coincide de la primera
SELECT * FROM users
right JOIN dni
ON users.user_id = dni.user_id;

-- FULL JOIN: Se queda con todos los datos, No existe tecnicamente!!
-- 
SELECT * FROM users
FULL JOIN dni
ON users.user_id = dni.user_id;
-- Este seria union
SELECT users.user_id AS u_user_id, dni.user_id AS d_user_id
FROM users
LEFT JOIN dni
ON users.user_id = dni.user_id
UNION ALL
SELECT users.user_id AS u_user_id, dni.user_id AS d_user_id
FROM users
RIGHT JOIN dni
ON users.user_id = dni.user_id









