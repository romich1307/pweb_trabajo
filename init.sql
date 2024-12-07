CREATE DATABASE IF NOT EXISTS pweb1;
USE pweb1;
CREATE TABLE IF NOT EXISTS Wiki (
    name VARCHAR(255) PRIMARY KEY,
    markdown TEXT
);
-- Crear la tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    userName VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);
CREATE USER IF NOT EXISTS 'alumno'@'%' IDENTIFIED BY 'pweb1';
-- Conceder privilegios a un usuario específico (asegúrate de que 'alumno' sea el usuario correcto)
GRANT ALL PRIVILEGES ON pweb1.* TO 'alumno'@'%';
FLUSH PRIVILEGES;

