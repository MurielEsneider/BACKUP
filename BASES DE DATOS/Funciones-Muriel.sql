use jardineria;
-- 1
DELIMITER $$

CREATE FUNCTION calcular_precio_total_pedido(codigo_pedido INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_pedido FLOAT;
    SELECT SUM(detalle_pedido.cantidad * producto.precio_venta) INTO total_pedido
    FROM detalle_pedido
    INNER JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
    WHERE detalle_pedido.codigo_pedido = codigo_pedido;
    RETURN total_pedido;
END $$

DELIMITER ;



-- 2
DELIMITER $$

CREATE FUNCTION calcular_suma_pedidos_cliente(codigo_cliente INT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_pedidos FLOAT;
    -- Calcular la suma total de pedidos para el cliente especificado
    SELECT IFNULL(SUM(calcular_precio_total_pedido(codigo_pedido)), 0) INTO total_pedidos
    FROM pedido 
    WHERE codigo_cliente = codigo_cliente;
    
    RETURN total_pedidos;
END $$

DELIMITER ;






-- 3 
DELIMITER $$

CREATE FUNCTION calcular_suma_pagos_cliente(codigo_cliente INT) 
RETURNS FLOAT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pagos FLOAT DEFAULT 0;
    SELECT SUM(p.total) INTO total_pagos
    FROM pago p
    WHERE p.codigo_cliente = codigo_cliente;

    RETURN total_pagos;
END $$

DELIMITER ;



-- 4
CREATE TABLE IF NOT EXISTS clientes_con_pagos_pendientes (
    id_cliente INTEGER PRIMARY KEY,
    suma_total_pedidos NUMERIC(15,2),
    suma_total_pagos NUMERIC(15,2),
    pendiente_de_pago NUMERIC(15,2)
);

DELIMITER $$

CREATE PROCEDURE calcular_pagos_pendientes()
BEGIN
    DECLARE cliente_id INT;
    DECLARE total_pedidos NUMERIC(15,2);
    DECLARE total_pagos NUMERIC(15,2);
    DECLARE pendiente NUMERIC(15,2);
    
    DECLARE cur_clientes CURSOR FOR
        SELECT codigo_cliente FROM cliente;
    
    DECLARE cur_pedidos CURSOR FOR
        SELECT codigo_cliente, SUM(precio_unidad * cantidad) AS total
        FROM detalle_pedido
        GROUP BY codigo_cliente;
    
    DECLARE cur_pagos CURSOR FOR
        SELECT codigo_cliente, SUM(total) AS total
        FROM pago
        GROUP BY codigo_cliente;
    
    OPEN cur_clientes;
    
    cliente_loop: LOOP
        -- Leer el cliente actual
        FETCH cur_clientes INTO cliente_id;
        -- Salir del bucle si no hay más clientes
        IF (cliente_id IS NULL) THEN
            LEAVE cliente_loop;
        END IF;
        
        SET total_pedidos = 0;
        SET total_pagos = 0;
        
        -- Calcular el total de pedidos del cliente actual
        OPEN cur_pedidos;
        pedido_loop: LOOP
            FETCH cur_pedidos INTO cliente_id, total_pedidos;
            IF (cliente_id IS NULL) THEN
                LEAVE pedido_loop;
            END IF;
        END LOOP pedido_loop;
        CLOSE cur_pedidos;
        
        -- Calcular el total de pagos del cliente actual
        OPEN cur_pagos;
        pago_loop: LOOP
            FETCH cur_pagos INTO cliente_id, total_pagos;
            IF (cliente_id IS NULL) THEN
                LEAVE pago_loop;
            END IF;
        END LOOP pago_loop;
        CLOSE cur_pagos;
        
        -- Calcular el pendiente de pago para el cliente actual
        SET pendiente = total_pedidos - total_pagos;
        
        -- Insertar los resultados en la tabla clientes_con_pagos_pendientes
        INSERT INTO clientes_con_pagos_pendientes (id_cliente, suma_total_pedidos, suma_total_pagos, pendiente_de_pago)
        VALUES (cliente_id, total_pedidos, total_pagos, pendiente);
        
    END LOOP cliente_loop;
    
    -- Cerrar el cursor de clientes
    CLOSE cur_clientes;
    
END $$
	TRUNCATE TABLE clientes_con_pagos_pedientes;
    
    INSERT INTO clientes_con_pagos_pedientes(id_cliente, suma_total_pedidos, suma_total_pagos, pediente_de_pago)
    SELECT
		p.codigo_cliente
        IFNULL(SUM(dp.cantidad * dp.precio_unidad),0) AS suma_total_pagos,
        IFNULL((SELECT SUM(total)FROM pago WHERE codigo_cliente = p.codigo_cliente),0) AS suma_total_pagos,
        IFNULL(SUM(dp.precio_unidad),0) - IFNULL((SELECT SUM(total) FROM pago WHERE codigo_cliente = p.codigo_cliente),0) AS pendiente_de_pago
	FROM pedido p
    LEFT JOIN detalle_pedido dp ON p.codigo_cliente = dp.codigo_pedido
    GROUP BY p.codigo.cliente
    HAVING pediente_de_pago
    
END $$
DELIMITER ;




-- 5
DELIMITER $$

CREATE FUNCTION cantidad_total_de_productos_vendidos(producto_codigo INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total_vendidos INT;

    SELECT SUM(cantidad) INTO total_vendidos
    FROM detalle_pedido
    WHERE codigo_producto = producto_codigo;

    RETURN total_vendidos;
END$$

DELIMITER ;

SELECT cantidad_total_de_productos_vendidos(11679);


-- 6
CREATE TABLE notificaciones (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha_hora TIMESTAMP,
    total FLOAT,
    codigo_cliente INT
);

DELIMITER $$

CREATE TRIGGER trigger_notificar_pago
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
    INSERT INTO notificaciones (fecha_hora, total, codigo_cliente)
    VALUES (NOW(), NEW.total, NEW.codigo_cliente);
END$$

DELIMITER ;

-- Insertar pago manualmente
INSERT INTO pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total)
VALUES (5, 'Efectivo', '3453434', NOW(), 90.00);
		

SELECT * FROM notificaciones;




-- 7

-- Crear la tabla productos_vendidos
CREATE TABLE productos_vendidos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    codigo_producto VARCHAR(255),
    cantidad_total INT
);

-- Crear el procedimiento almacenado estadísticas_productos_vendidos
DELIMITER $$
CREATE PROCEDURE estadísticas_productos_vendidos()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE codigo_producto_var VARCHAR(255);
    DECLARE cantidad_total_var INT;

    -- Borrar el contenido de la tabla productos_vendidos
    TRUNCATE TABLE productos_vendidos;

    -- Declarar el cursor para recorrer los productos
    DECLARE productos_cursor CURSOR FOR SELECT DISTINCT codigo_producto FROM producto;

    -- Manejar los errores
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Abrir el cursor
    OPEN productos_cursor;

    -- Loop para recorrer los productos
    productos_loop: LOOP
        FETCH productos_cursor INTO codigo_producto_var;
        IF done THEN
            LEAVE productos_loop;
        END IF;

        -- Calcular la cantidad total de productos vendidos usando la función cantidad_total_de_productos_vendidos
        SET cantidad_total_var = cantidad_total_de_productos_vendidos(codigo_producto_var);

        -- Insertar los valores en la tabla productos_vendidos
        INSERT INTO productos_vendidos (codigo_producto, cantidad_total) VALUES (codigo_producto_var, cantidad_total_var);
    END LOOP;

    -- Cerrar el cursor
    CLOSE productos_cursor;
END $$
DELIMITER ;



