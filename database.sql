-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS pweb1;

-- Seleccionar la base de datos
USE pweb1;

-- Crear tabla 'Users' si no existe
CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE -- Aseguramos que sea UNIQUE para usar como referencia
);