
CREATE DATABASE Biblioteca CHARACTER SET utf8mb4;
USE Biblioteca;

CREATE TABLE Autor(
idAutor INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
nombres VARCHAR(100) NOT NULL,
apellidos VARCHAR (100) NOT NULL, 
nacionalidad VARCHAR(100) NOT NULL
);

CREATE TABLE Editorial(
idEditorial INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Libro(
idLibro INT AUTO_INCREMENT PRIMARY KEY,
titulo VARCHAR (100) NOT NULL,
categoria VARCHAR (100) NOT NULL,
fechaPublicacion DATE NOT NULL,
idioma VARCHAR(100) NOT NULL, 
idAutor INT NOT NULL,
idEditorial INT NOT NULL,
FOREIGN KEY (idAutor) REFERENCES Autor(idAutor),
FOREIGN KEY (idEditorial) REFERENCES Editorial(idEditorial)
);

INSERT INTO Editorial 
VALUES(NULL,"Norma"),
(NULL, "Aguilar"),
(NULL, "Alfaguairaonsu");

 SELECT * FROM Editorial;
 
 INSERT INTO Autor
 VALUES(null, "Jeison", "Jiménez", "Colombiano"),
	(null, "Geoanny", "Ayala", "Colombiano"),
    (null, "Manuel", "Acosta", "Peruano"),
    (null, "Pepe", "Alva", "Peruano"),
    (null, "Leonardo","Sanchez","Mexicano");

SELECT * FROM Autor;
 
INSERT INTO Libro 
VALUES(null, "Guaro", "Popular", "16-07-2021", "Español"),
	(null, "Mi Venganza", "Popular", "22-07-2022", "Español"),
    (null, "Madre", "Musica Criolla", "12-03-2004", "Español"),
    (null, "Matarina","POP", "09-04-2007", "Español"),
    (null, "Millón de primaveras", "Regional Mexinaca", "25-07-2007", "Español");