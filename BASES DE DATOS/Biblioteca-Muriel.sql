DROP DATABASE biblioteca;
CREATE DATABASE Biblioteca CHARACTER SET utf8mb4;
USE Biblioteca;

CREATE TABLE Autor(
idAutor INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
nombre VARCHAR(100) NOT NULL,
apellido VARCHAR (100) NOT NULL, 
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
    (null, "Leonardo","Piña","Mexicano");

SELECT * FROM Autor;
 
INSERT INTO Libro 
VALUES(null, "Guaro", "Popular", "2021-07-16", "Español",1,1),
	(null, "Mi Venganza", "Popular", "2022-07-22", "Español",2,2),
    (null, "Madre", "Musica Criolla", "2004-03-12", "Español",3,3),
    (null, "Matarina","POP", "2007-04-09", "Español",4,1),
    (null, "Millón de primaveras", "Regional Mexinaca", "2007-07-25", "Español",5,1);
 
SELECT * FROM Libro;

SELECT * FROM Libro
JOIN Autor ON Libro.idAutor = Autor.idAutor;


UPDATE Editorial SET
nombre = "Alfaguara"
WHERE idEditorial = 3;

SELECT * FROM Editorial;


UPDATE Autor SET
nombre = "Vicente",
apellido = "Fernández"
WHERE nacionalidad = "Mexicano" and nombre = "Leonardo" and apellido = "Piña";

SELECT *
FROM Autor
WHERE nacionalidad = "Mexicano";


SELECT *
FROM Libro
JOIN Autor ON Libro.idAutor
WHERE Autor.nacionalidad = "Mexicano";

UPDATE Libro SET 
idioma = "MANDARIN"
WHERE idAutor = 5;

SELECT * FROM libro;


DELETE FROM libro WHERE idlibro= 1;

SELECT * FROM libro;


DELETE FROM libro WHERE idlibro= 5;

SELECT * FROM libro;


