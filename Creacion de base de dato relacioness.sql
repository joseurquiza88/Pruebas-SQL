USE newSchema;
-- Relacion 1:1 
CREATE TABLE dni (
dni_id INT AUTO_INCREMENT PRIMARY KEY,
dni_number INT NOT NULL,
user_id INT,
UNIQUE(dni_id),
FOREIGN KEY (user_id) REFERENCES users (user_id)
);

-- Relacion 1:N
CREATE TABLE companies (
company_id INT AUTO_INCREMENT PRIMARY KEY,
name varchar(100) NOT NULL
);

ALTER TABLE users 
	MODIFY COLUMN company_id INT;
    
ALTER TABLE users 
ADD CONSTRAINT fk_companies
FOREIGN KEY (company_id) REFERENCES companies (company_id);

CREATE TABLE lenguajes(
lenguajes_id INT AUTO_INCREMENT PRIMARY KEY,
name  VARCHAR(100) NOT NULL
);
-- Tabla intermedia para unir N:N
CREATE TABLE users_lenguajes(
users_lenguajes_id INT AUTO_INCREMENT PRIMARY KEY,
name  VARCHAR(100) NOT NULL,
user_id INT,
lenguajes_id INT,
FOREIGN KEY (user_id) REFERENCES users (user_id),
FOREIGN KEY (lenguajes_id) REFERENCES lenguajes (lenguajes_id),
UNIQUE(user_id,lenguajes_id)
);