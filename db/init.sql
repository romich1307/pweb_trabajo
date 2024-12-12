CREATE DATABASE IF NOT EXISTS pweb1;
USE pweb1;

CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    firstName VARCHAR(255) NOT NULL,
    lastName VARCHAR(255) NOT NULL,
    UNIQUE KEY unique_user (username)
);

CREATE TABLE IF NOT EXISTS Articles (
    title VARCHAR(255) NOT NULL,      
    owner VARCHAR(100) NOT NULL,     
    text TEXT NOT NULL,              
    PRIMARY KEY (title, owner),      
    FOREIGN KEY (owner) REFERENCES Users(username) 
);


CREATE USER IF NOT EXISTS 'alumno'@'%' IDENTIFIED BY 'pweb1';
GRANT ALL PRIVILEGES ON pweb1.* TO 'alumno'@'%';
FLUSH PRIVILEGES;
