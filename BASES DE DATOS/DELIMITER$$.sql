USE tienda;
delimiter $$

CREATE PROCEDURE caluclarAreaCirculo(IN radio DOUBLE, OUT area DOUBLE)  
BEGIN
	SET area = PI() * POW(radio,2);
END
$$



delimiter ;
CALL caluclarAreaCirculo(5,@area);
SELECT @area;









USE tienda;
delimiter $$
CREATE PROCEDURE contarProductosFabricante(in fabricante VARCHAR (50),
out cantidad int)
BEGIN
	SET cantidad  =(select count(producto.id) from producto 
    inner join fabricante
    on producto.id_fabricante=fabricante.id
    WHERE fabricante.nombre =fabricante);
end
$$
SELECT * FROM fabricante;
delimiter ;
set @cantidad=0;
call contarProductosFabricante('Lenovo', @cantidad);
select @cantidad;


delimiter $$
CREATE PROCEDURE CalcularMaxMinMedia(IN fabricante VARCHAR(15),
OUT maximo decimal(15,2),
OUT minimo decimal(15,2),
OUT promedio decimal(15,2))
begin
	set maximo = (select max(producto.precio)
    FROM producto INNER JOIN fabricante
    ON producto.id_fabricante = fabricante.id
    WHERE fabricante.nombre = fabricante);
    
    SET minimo = (select min(producto.precio)
    from producto inner join fabricante
    on producto.id_fabricante = fabricante.id
    where fabricante.nombre = fabricante);
    
    set promedio = (select avg(producto.precio)
    from producto inner join fabricante
    on producto.id_fabricante = fabricante.id
    where fabricante.nombre = fabricante);

end
$$
set @maximo=0;
set @minimo=0;
set @promedio=0;

call CalcularMaxMinMedia("Lenovo", @maximo, @minimo, @promedio);
	SELECT @minimo, @maximo, @promedio;

