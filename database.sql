-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS userdb;

-- Seleccionar la base de datos
USE userdb;

-- Crear tabla 'users' si no existe
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL  -- Almacena contraseñas hasheadas
);
