CREATE DATABASE IF NOT EXISTS pweb1;
USE pweb1;
CREATE TABLE IF NOT EXISTS Wiki (
    name VARCHAR(255) PRIMARY KEY,
    markdown TEXT
);
CREATE USER IF NOT EXISTS 'alumno'@'%' IDENTIFIED BY 'pweb1';
-- Conceder privilegios a un usuario específico (asegúrate de que 'alumno' sea el usuario correcto)
GRANT ALL PRIVILEGES ON pweb1.* TO 'alumno'@'%';
FLUSH PRIVILEGES;

