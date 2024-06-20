CREATE DATABASE instituto CHARSET utf8mb4;

USE instituto;

CREATE TABLE Alumnos(
idAlumno INT NOT NULL PRIMARY KEY,
identificacion INT NOT NULL,
nombres  VARCHAR(255) NOT NULL,
apellidos  VARCHAR(255) NOT NULL,
correo VARCHAR (255) NOT NULL
);

CREATE TABLE Profesores(
idProfesor INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
identificacion INT NOT NULL,
nombres VARCHAR (255) NOT NULL,
apellidos VARCHAR (255) NOT NULL,
correo VARCHAR (255) NOT NULL,
especiliadad VARCHAR (50) NOT NULL
);
CREATE TABLE Cursos(
idCurso INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
codigo INT NOT NULL,
horas INT NOT NULL,
fechaInicio DATE NOT NULL,
idProfesor INT NOT NULL,
FOREIGN KEY Profesores (idProfesor) REFERENCES Profesores (idProfesor) 
);
describe Cursos;

CREATE TABLE MatriculasCursos(
idMatricula INT AUTO_INCREMENT PRIMARY KEY,
idCurso INT NOT NULL,
IdAlumno INT NOT NULL,
FOREIGN KEY (idCurso) REFERENCES Cursos (idCurso),
FOREIGN KEY (idAlumno) REFERENCES Alumnos (IdAlumno)
);

alter table Cursos 
add constraint fk_Cursos_Profesores
FOREIGN KEY Profesores(idProfesor) REFERENCES Profesores (idProfesor)
on delete restrict;

alter table MatriculasCursos 
add constraint fk_MatriculasCursos_Cursos
FOREIGN KEY (idCurso) REFERENCES Cursos (idCurso)
on delete restrict;

alter table MatriculasCursos 
add constraint fk_MatriculasCursos_Alumnos
FOREIGN KEY (idAlumno) REFERENCES Alumnos (idAlumno)
on delete restrict;

ALTER TABLE Alumnos
add sexo ENUM('Masculino', 'Femenino') NOT NULL;

ALTER TABLE Profesores
add telefono VARCHAR (20) NOT NULL;

ALTER TABLE Cursos
CHANGE COLUMN horas totalHoras INT;

describe Alumnos;
describe Profesores;
describe Cursos;
describe MatriculasCursos;