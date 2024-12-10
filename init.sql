-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS pweb1;

-- Seleccionar la base de datos
USE pweb1;

-- Crear tabla 'Users' si no existe
CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    username VARCHAR(100) NOT NULL UNIQUE, -- Aseguramos que sea UNIQUE para usar como referencia
    firstName VARCHAR(100) NOT NULL,      -- Primer nombre del usuario
    lastName VARCHAR(100) NOT NULL        -- Apellidos del usuario
);

-- Crear tabla 'Articles' si no existe
CREATE TABLE IF NOT EXISTS Articles (
    title VARCHAR(255) NOT NULL,      -- Título del artículo
    owner VARCHAR(100) NOT NULL,     -- Debe coincidir con el tipo y longitud de 'username' en 'Users'
    text TEXT NOT NULL,              -- Contenido en formato Markdown
    PRIMARY KEY (title, owner),      -- Clave primaria compuesta
    FOREIGN KEY (owner) REFERENCES Users(username) -- Relación con la tabla Users
);

-- Crear usuario de base de datos
CREATE USER IF NOT EXISTS 'alumno'@'%' IDENTIFIED BY 'pweb1';

-- Conceder privilegios al usuario
GRANT ALL PRIVILEGES ON pweb1.* TO 'alumno'@'%';
FLUSH PRIVILEGES;
