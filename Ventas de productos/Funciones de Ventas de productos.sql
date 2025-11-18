-- Basic SQL:
-- Ver que datos tienen las tablas:
SELECT * FROM ventas;
SELECT * FROM producto_detalle;
SELECT * FROM producto_precio;

-- ¿Cuál fue la cantidad total vendida de todos los productos?
SELECT SUM(qty) AS cantidad_productos
FROM ventas;

-- ¿Cuál fue la cantidad total vendida de cada uno de los productos?
SELECT ventas.id_producto, producto_detalle.nombre_producto, COUNT(*) AS cantidad_ventas
FROM ventas 
INNER JOIN producto_detalle
ON ventas.id_producto = producto_detalle.id_producto
GROUP BY ventas.id_producto, producto_detalle.nombre_producto
ORDER BY cantidad_ventas DESC;

-- ¿Cuál es el ingreso total generado por todos los productos antes de los descuentos?
SELECT SUM(precio * qty) AS total
FROM ventas;

-- ¿Cuál es el ingreso promedio generado por todos los productos antes de los descuentos?
SELECT AVG(precio * qty) AS total_promedio
FROM ventas;

--  ¿Cuál es el ingreso total generado por cada producto antes de los descuentos? Mostrar el nombre del producto y el ingreso, ordenar de mayor a menor por ingreso total

SELECT ventas.id_producto, producto_detalle.nombre_producto, SUM(ventas.precio * ventas.qty) AS total 
FROM ventas
INNER JOIN producto_detalle
ON ventas.id_producto = producto_detalle.id_producto
GROUP BY ventas.id_producto, producto_detalle.nombre_producto
ORDER BY total DESC;

-- ¿Cuál es el porcentaje total de descuento (sobre el ingreso total) para todos los productos?
SELECT ((SUM(descuento) /SUM(precio * qty))*100) AS porcentaje_descuento
FROM ventas;

-- ¿Cuál es el porcentaje total de descuento (sobre el ingreso total) por cada producto?
SELECT ventas.id_producto, producto_detalle.nombre_producto, ((SUM(descuento)/ SUM(ventas.precio * ventas.qty) *100)) AS porcentaje_descuento_total 
FROM ventas
INNER JOIN producto_detalle
ON ventas.id_producto = producto_detalle.id_producto
GROUP BY ventas.id_producto, producto_detalle.nombre_producto
ORDER BY porcentaje_descuento_total DESC;

-- ¿Cuántas transacciones únicas hubo?
SELECT COUNT(DISTINCT id_txn) AS transacciones_unicas
FROM ventas;

-- ¿Cuáles son las ventas totales brutas de cada transacción? (Ventas brutas: sin el descuento)
SELECT id_txn, SUM(precio * qty) AS total_transaccion
FROM ventas
GROUP BY id_txn 
ORDER BY total_transaccion DESC;


-- ¿Qué cantidad de productos totales se compran en cada transacción?
SELECT * FROM ventas;

SELECT id_txn, SUM(qty) AS cantidad_por_transaccion
FROM ventas
GROUP BY id_txn 
ORDER BY cantidad_por_transaccion DESC;

-- ¿Cuál es el valor de descuento promedio por transacción?

SELECT id_txn, AVG(descuento) AS descuento_por_transaccion 
FROM ventas
GROUP BY id_txn;

-- ¿Cuál es el ingreso promedio neto por transacción para miembros “t”? 
-- Ventas netas: se les resta el valor de la columna descuento. 
SELECT id_txn, AVG((qty*precio)-descuento) AS ingreso_promedio 
FROM ventas 
WHERE miembro = 't'
GROUP BY id_txn;

-- ¿Cuáles son los 3 productos mas vendidos en función a los ingresos totales?

SELECT ventas.id_producto, producto_detalle.nombre_producto, (SUM(ventas.qty * ventas.precio)) AS ingresos_productos
FROM ventas
INNER JOIN producto_detalle
ON ventas.id_producto = producto_detalle.id_producto
GROUP BY producto_detalle.nombre_producto, ventas.id_producto
ORDER BY ingresos_productos DESC 
LIMIT 3;


-- ¿Cuál es la cantidad total vendida, los ingresos brutos y el descuento de cada segmento de producto?

SELECT producto_detalle.nombre_segmento, 
SUM(ventas.qty) AS cantidad, 
(SUM(ventas.qty * ventas.precio)) AS ingresos_brutos,
(SUM(ventas.descuento)) AS descuento 
FROM ventas
INNER JOIN producto_detalle
ON ventas.id_producto = producto_detalle.id_producto
GROUP BY producto_detalle.nombre_segmento;


-- Intermediate SQL -- 
-- ¿Cuál es el producto más vendido de cada categoría?
SELECT nombre_categoria, nombre_producto, cantidad
FROM (
    SELECT 
        producto_detalle.nombre_categoria,
        producto_detalle.nombre_producto,
        SUM(ventas.qty) AS cantidad,
        ROW_NUMBER() OVER (
            PARTITION BY producto_detalle.nombre_categoria
            ORDER BY SUM(ventas.qty) DESC
        ) AS rn
    FROM ventas
    INNER JOIN producto_detalle
        ON ventas.id_producto = producto_detalle.id_producto
    GROUP BY producto_detalle.nombre_categoria, producto_detalle.nombre_producto
) AS t
WHERE rn = 1;


-- ¿Cuál es el producto más vendido para cada segmento?
SELECT nombre_segmento, nombre_producto, cantidad
FROM (
    SELECT 
        producto_detalle.nombre_segmento,
        producto_detalle.nombre_producto,
        SUM(ventas.qty) AS cantidad,
        ROW_NUMBER() OVER (
            PARTITION BY producto_detalle.nombre_segmento
            ORDER BY SUM(ventas.qty) DESC
        ) AS rn
    FROM ventas
    INNER JOIN producto_detalle
        ON ventas.id_producto = producto_detalle.id_producto
    GROUP BY producto_detalle.nombre_segmento, producto_detalle.nombre_producto
) AS t
WHERE rn = 1;



