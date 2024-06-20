DROP DATABASE IF EXISTS inmobiliaria;
CREATE DATABASE inmobiliaria CHARACTER SET utf8mb4;
USE inmobiliaria;

CREATE TABLE Propietarios(
idPropietario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombreCompleto VARCHAR (100) NOT NULL,
direccion VARCHAR (50) UNIQUE,
telefono VARCHAR (30) UNIQUE
);

CREATE TABLE Arrendatarios (
idArrendatario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombreCompleto VARCHAR(100) NOT NULL,
correo VARCHAR (100) UNIQUE,
telefono VARCHAR (30)UNIQUE
);

CREATE TABLE Casas (
idCasa INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
direccion VARCHAR (50) UNIQUE,
estrato VARCHAR (20) NOT NULL,
numeroHabitaciones VARCHAR (200) NOT NULL,
numeroBaños VARCHAR (100) NOT NULL,
area VARCHAR (100) NOT NULL,
valorArriendo DECIMAL (10,2) NOT NULL,
idPropietario INT UNSIGNED,
FOREIGN KEY (idPropietario) REFERENCES Propietarios(idPropietario)
);

CREATE TABLE Arriendos (
idArriendo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
idCasa INT UNSIGNED,
idArrendatario int UNSIGNED,
fechaInicial_de_arriendo DATE
);


INSERT INTO Propietarios
values (null,"Jhojan Esneider Muriel","calle 11 carrera 12","312 774 0232");

insert into propietarios
values (null,"Mario José Benavides","carrera 5 casa 43","311 666 1082");

INSERT INTO propietarios
values (null,"Laura Delgado Ñañez", "calle 12 carrera 8","311 390 2807");

SELECT * FROM propietarios;


INSERT INTO Casas
values (null,"calle 11 carrera 12","cinco","diez","5","100 metros cuadrados", "600.000","1");
INSERT INTO Casas
values (null,"carrera 5 casa 43","tres","siete","8","120 metros cuadrados","700.000","2");
INSERT INTO Casas
values (null,"calle 12 carrera 8","cuatro","nueve","3","100 metros cuadrados","650.000","3");

SELECT * FROM Casas;

INSERT INTO arrendatarios
values (null,"Juan Madroñero","juan@gmail.com","311 484 8130");
insert into arrendatarios
values (null,"Fernando Cordoba ","fernando@gmail.com","321 311 3510");
insert into arrendatarios
values (null,"Stiven Salas","Salas@gmail.com","322 420 2520");

SELECT * FROM arrendatarios;

INSERT INTO arriendos
values (null,1,3,"2024-04-01");

INSERT INTO arriendos
values (null,2,1,"2024-02-15");

SELECT * FROM arriendos;


UPDATE propietarios  SET nombreCompleto="Marcos Cepeda Rico" WHERE idPropietario=1;

SELECT * FROM propietarios;

UPDATE casas SET estrato="tres" WHERE idCasa = 1 ;
UPDATE casas SET estrato="tres" WHERE idCasa = 2 ;
UPDATE casas SET estrato="tres" WHERE idCasa = 3 ;

SELECT * FROM casas;

SET SQL_SAFE_UPDATES = 0;
UPDATE Casas
SET valorArriendo = valorArriendo * 1.10;


SELECT direccion,estrato,valorArriendo 
FROM casas;

UPDATE arriendos SET fechaInicial_de_arriendo="2024-05-15" WHERE idArriendo= 2; 


SELECT * FROM arriendos WHERE fechaInicial_de_arriendo >="2024-05-1";


DELETE FROM Arriendos
WHERE fechaInicial_de_arriendo = '2024-04-01';

SELECT * FROM arriendos