CREATE DATABASE IF NOT EXISTS pweb1;
USE pweb1;
CREATE TABLE IF NOT EXISTS Articles (
    title VARCHAR(255) NOT NULL,      -- Título del artículo
    owner VARCHAR(50) NOT NULL,       -- userName del creador del artículo
    text TEXT NOT NULL,               -- Contenido en formato Markdown
    PRIMARY KEY (title, owner),       -- Clave primaria compuesta
    FOREIGN KEY (owner) REFERENCES Users(userName) -- Relación con la tabla Users
);
CREATE USER IF NOT EXISTS 'alumno'@'%' IDENTIFIED BY 'pweb1';

GRANT ALL PRIVILEGES ON pweb1.* TO 'alumno'@'%';
FLUSH PRIVILEGES;

