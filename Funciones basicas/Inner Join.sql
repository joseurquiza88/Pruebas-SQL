-- JOINS

-- Iner join: Devuelve los registreos cuando las dos tablas coinciden
# Todas las columnas
SELECT * FROM users
INNER JOIN dni
ON users.user_id = dni.user_id;
# Solo nombres
SELECT name FROM users
INNER JOIN dni
ON users.user_id = dni.user_id;
# Ordenarlo por nombre
SELECT * FROM users
INNER JOIN dni
ON users.user_id = dni.user_id
ORDER BY name;

-- Relacion 1:N
-- Tomar tabla usurarios y unirla con compaies, unila por el ID 
SELECT * FROM users 
JOIN companies
ON users.company_id = companies.company_id;

-- Lo mismo pero al reves las tablas
 SELECT * FROM companies 
JOIN users 
ON companies.company_id = users.company_id;

-- Otra alternativa
SELECT companies.name, users.name FROM  companies
JOIN users
ON companies.company_id = users.company_id;


-- Unir 3 tablas
SELECT users.name, lenguajes.name
FROM users_lenguajes 
JOIN users ON users_lenguajes.user_id = users.user_id
JOIN lenguajes ON users_lenguajes.user_id = lenguajes.lenguajes_id












