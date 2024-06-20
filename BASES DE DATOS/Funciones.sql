USE tienda;

DELIMITER $$
CREATE FUNCTION contar_productos(
fabricante VARCHAR(20))
	returns int
    reads sql data
    begin
		declare cantidad int;
        set cantidad = (select count(producto.id) from 
        producto inner join fabricante
        on producto.id_fabricante= fabricante.id
        where fabricante.nombre = fabricante);
        
        return cantidad;
    end
    $$

DELIMITER $$
DROP PROCEDURE IF EXISTS ejemplo_bucle_loop$$
CREATE PROCEDURE ejemplo_bucle_loop(IN tope INT, OUT suma INT)
BEGIN
  DECLARE contador INT;
    
  SET contador = 1;
  SET suma = 0;
    
  bucle: LOOP
    IF contador > tope THEN
      LEAVE bucle;
    END IF;

    SET suma = suma + contador;
    SET contador = contador + 1;
  END LOOP;
END
$$

DELIMITER ;
CALL ejemplo_bucle_loop(10, @resultado);
SELECT @resultado;







DROP DATABASE IF EXISTS test;
CREATE DATABASE test;
USE test;

CREATE TABLE t1 (
  id INT UNSIGNED PRIMARY KEY,
    data VARCHAR(16)
);

CREATE TABLE t2 (
  i INT UNSIGNED
);

CREATE TABLE t3 (
  data VARCHAR(16),
    i INT UNSIGNED
);

INSERT INTO t1 VALUES (1, 'A');
INSERT INTO t1 VALUES (2, 'B');

INSERT INTO t2 VALUES (10);
INSERT INTO t2 VALUES (20);

SELECT * FROM t1;
SELECT * FROM t2;







DELIMITER $$
DROP PROCEDURE IF EXISTS curdemo$$
CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE a CHAR(16);
  DECLARE b, c INT;
  DECLARE cur1 CURSOR FOR SELECT id,data FROM test.t1;
  DECLARE cur2 CURSOR FOR SELECT i FROM test.t2;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;
  OPEN cur2;

  read_loop: LOOP
    FETCH cur1 INTO b, a;
    FETCH cur2 INTO c;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF b < c THEN
      INSERT INTO test.t3 VALUES (a,b);
    ELSE
      INSERT INTO test.t3 VALUES (a,c);
    END IF;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END




DELIMITER ;
CALL curdemo();

SELECT * FROM t3;




CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50), 
    nota FLOAT
);




DELIMITER $$
DROP TRIGGER IF EXISTS trigger_check_nota_before_insert$$
CREATE TRIGGER trigger_check_nota_before_insert
BEFORE INSERT
ON alumnos FOR EACH ROW
BEGIN
  IF NEW.nota < 0 THEN
    set NEW.nota = 0;
  ELSEIF NEW.nota > 10 THEN
    set NEW.nota = 10;
  END IF;
END

DELIMITER ;

insert into alumnos 
values(null, "Pedro","Rojas","Salas",15);

insert into alumnos 
values(null, "Manuel","Ordoñez","Molina",-5);

SELECT * FROM alumnos





DELIMITER $$
DROP TRIGGER IF EXISTS trigger_check_nota_before_update$$
CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE
ON alumnos FOR EACH ROW
BEGIN
  IF NEW.nota < 0 THEN
    set NEW.nota = 0;
  ELSEIF NEW.nota > 10 THEN
    set NEW.nota = 10;
  END IF;
END

DELIMITER ;

INSERT INTO alumnos VALUES (null, 'María', 'Sánchez', 'Sánchez', 11);
INSERT INTO alumnos VALUES (null, 'Juan', 'Pérez', 'Pérez', 8.5);

SELECT * FROM alumnos;

UPDATE alumnos SET nota = -4 WHERE id = 3;















-- SIN SENTENCIAS SQL EJERCICIO 1-2-3








DELIMITER $$
CREATE PROCEDURE mostrar_hola_mundo()
BEGIN
	SELECT "HOLA MUNDO";
END
$$


CALL mostrar_hola_mundo;


DELIMITER ;


DELIMITER $$
CREATE PROCEDURE positivo_negativo_cero(in numero DOUBLE)
BEGIN
	IF(numero<0) THEN 
		select "El número negativo";
	ELSEIF(numero>0) THEN
		SELECT "El número es positivo";
	ELSE 
		SELECT "El número es Cero";
	END IF;
END
$$


DELIMITER ;

CALL positivo_negativo_cero(-34);



DELIMITER $$
CREATE PROCEDURE positivo_negativo_cero_mensaje(in numero DOUBLE, OUT mensaje VARCHAR(24))
BEGIN
	IF(numero<0) THEN 
		SET mensaje= "El número negativo";
	ELSEIF(numero>0) THEN
		SET mensaje= "El número es positivo";
	ELSE 
		SET mensaje= "El número es Cero";
	END IF;
END
$$


DELIMITER ;
CALL positivo_negativo_cero_mensaje(-34, @mensaje);
SELECT @mensaje




DELIMITER $$
CREATE FUNCTION dia_semana(dia int)
RETURNS VARCHAR(20)
NO SQL
BEGIN
	declare textoDia VARCHAR(20);
	CASE dia 
		WHEN 1 THEN 
			SET textoDia = "lunes";
		WHEN 2 THEN 
			SET textoDia = "martes";
		WHEN 3 THEN
			SET textoDia = "miécoles";
		WHEN 4 THEN 
			SET textoDia = "jueves";
		WHEN 5 THEN 
			SET textoDia = "viernes";
		WHEN 6 THEN
			SET textoDia = "sábado";
		WHEN 6 THEN
			SET textoDia = "domingo";
		ELSE 
			SET textoDia = "Dato invalido";
    END CASE;
    return textoDia;
END
$$

DELIMITER ;

SELECT dia_semana(8);

SELECT 




-- FUNCIONES CON SENTENCIAS SQL 
-- EJERCICIO 4

DELIMITER $$
CREATE FUNCTION precio_minimo_fabricante(fabricante VARCHAR(20))
RETURNS DOUBLE
READS SQL DATA
BEGIN
	DECLARE precioMinimo DOUBLE;
	SET precioMinimo = (SELECT min(producto.precio) 
    FROM producto INNER JOIN fabricante
    ON producto.id_fabricante = fabricante.id
    WHERE fabricante.nombre=fabricante);
    RETURN precioMinimo;
END
$$


DELIMITER ;
SELECT precio_minimo_fabricante('Asus');










-- CURSORES

USE test;

CREATE TABLE alumnos (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50),
    fechaNacimiento date
);


INSERT INTO alumnos 
values(null, "Pedro","Rojas","Salas","2000-05-15"),
	(null, "Erika","Galindo","Rojas","2002-01-01"),
	(null, "Monica","Galindo","Rojas","2002-01-01"),
	(null, "Maria","Galindo","Rojas","2002-01-01");

ALTER TABLE alumnos ADD edad int null;


SELECT * FROM alumnos;


DELIMITER $$
CREATE FUNCTION calcular_edad(fechaNacimiento date)
	returns int
    NO SQL
    BEGIN
		DECLARE years INT;
        SET years = (select datediff(NOW(), fechaNacimiento))/365;
        RETURN years;
    END
    $$

DELIMITER ;

SELECT DATEDIFF(NOW(), "2022-05-01") / 365;



DELIMITER $$
CREATE PROCEDURE actualizar_columna_edad()
NO SQL
BEGIN
	UPDATE alumnos SET edad=calcular_edad(fechaNacimiento);
END
$$

DELIMITER ;
CALL actualizar_columna_edad();


SELECT * FROM alumnos;
















-- 1.8.8
-- EJERCICIO2

CREATE TABLE alumnos2(
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR (50) NOT NULL,
    email VARCHAR (100) NULL
);

DELIMITER $$
CREATE PROCEDURE create_email(
	in nombre VARCHAR(50),
	in apellido1 VARCHAR(50),
	in apellido2 VARCHAR (50),
	in dominio VARCHAR (50),
	OUT email VARCHAR(50))

BEGIN
	SET email = concat(substring(nombre,1,1), substring(apellido1,1,3),
				substring(apellido1,1,3), '@', dominio);
END
$$

DELIMITER ;
CALL create_email("Maria","Salas","Avila","@GMAIL.COM", @email);
SELECT @email;



DELIMITER $$
CREATE FUNCTION eliminar_acentos(texto varchar(20))
returns varchar(20)
NO SQL
BEGIN
	DECLARE textoSinTildes VARCHAR(20);
    SET textoSinTildes = lower(texto);
    SET textoSinTildes = (select replace (textoSinTildes,"á","a"));
	SET textoSinTildes = (select replace (textoSinTildes,"é","e"));
	SET textoSinTildes = (select replace (textoSinTildes,"í","i"));
    SET textoSinTildes = (select replace (textoSinTildes,"ó","o"));
    SET textoSinTildes = (select replace (textoSinTildes,"ú","u"));
    return textoSinTildes; 
END 
$$

DELIMITER ;
SELECT eliminar_acentos("La canción de María");



