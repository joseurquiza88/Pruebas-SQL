
-- Practicando otras consultas
-- ----------------------------------------------------------------
-- 1. Productos que nunca fueron vendidos. Obtener los productos que no aparecen en ningún pedido.

SELECT * FROM products
SELECT * FROM orders
SELECT p.product_id 
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- ----------------------------------------------------------------
-- 2. Vendedores sin ventas. Mostrar todos los vendedores que no realizaron ninguna venta.
SELECT s.seller_id
FROM sellers s
LEFT JOIN order_items oi
ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL

-- ----------------------------------------------------------------
-- 3. Clientes que realizaron al menos un pedido
SELECT c.customer_unique_id
FROM customers c
WHERE c.customer_id IN (
    SELECT o.customer_id
    FROM orders o);


-- ----------------------------------------------------------------
-- 4. Clientes y cantidad de pedidos. 
-- Mostrar cada cliente y la cantidad de pedidos que realizó, incluyendo clientes sin pedidos.
SELECT c.customer_unique_id, COUNT (o.order_id) AS cantidad_pedido
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id


-- ----------------------------------------------------------------
-- 5. Obtener los clientes que realizaron más de 3 pedidos.
SELECT  c.customer_unique_id, COUNT (o.order_id) AS cantidad_pedido
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 3;


-- ----------------------------------------------------------------
-- 6. Obtener los vendedores que generaron más de R$10.000 en ventas.

SELECT s.seller_id, SUM(op.payment_value) AS total_vendedor
FROM sellers s
JOIN order_items oi
ON s.seller_id = oi.seller_id

JOIN order_payments op
ON oi.order_id = op.order_id
GROUP BY  s.seller_id
HAVING SUM(op.payment_value) >10000;



-- ----------------------------------------------------------------
-- 7. Obtener los estados que tienen más de 100 clientes.
SELECT customer_state, COUNT(customer_unique_id) AS contador
FROM customers c
GROUP BY customer_state
HAVING COUNT(customer_unique_id) > 100

-- ----------------------------------------------------------------
-- 8. Obtener los clientes cuyo gasto total sea superior a R$5.000.
SELECT c.customer_unique_id, SUM(payment_value) AS gasto
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id

JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY c.customer_unique_id
HAVING SUM(payment_value) > 5000;


-- ----------------------------------------------------------------
-- 9. Obtener los meses en los que las ventas superaron el promedio mensual.
WITH ventas AS (
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS mes, SUM(op.payment_value) AS suma_mensual
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
),
promedio_mensual AS (
    SELECT mes, suma_mensual,
    AVG(suma_mensual) OVER () AS promedio_mensual
    FROM ventas
)
SELECT mes, suma_mensual, promedio_mensual
FROM promedio_mensual
WHERE suma_mensual > promedio_mensual;

-- ----------------------------------------------------------------
-- Practicar el WHEN
-- 10. Clasificar clientes. Clasificar a los clientes según su gasto total:
-- < 100 → Bajo
-- 100-500 → Medio
-- > 500 → Alto
WITH gastos_clientes AS (
    SELECT c.customer_unique_id, SUM (op.payment_value) AS gasto_cliente
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_payments op
    ON o.order_id = op.order_id
    GROUP BY c.customer_unique_id
)
SELECT customer_unique_id, gasto_cliente, 
CASE
    WHEN gasto_cliente < 100 THEN 'Bajo'
    WHEN gasto_cliente BETWEEN 100 AND 500 THEN 'Medio'
    WHEN gasto_cliente > 500 THEN 'Alto'
    ELSE  'S/D'
END AS tipo_cliente
FROM gastos_clientes;


-- ----------------------------------------------------------------
-- 11. Clasificar pedidos: Clasificar pedidos según su valor:
-- < 100 → Pequeño
-- 100-500 → Mediano
-- > 500 → Grande

SELECT order_id, payment_value, 
CASE 
    WHEN payment_value < 100 THEN 'Pequeño'
    WHEN payment_value BETWEEN 100 AND 500 THEN 'Mediano'
    WHEN payment_value > 500 THEN 'Grande'
    ELSE 'SD'
    END AS tipo_pedido
FROM order_payments;

-- ----------------------------------------------------------------
-- 12. Clientes nuevos vs recurrentes. Identificar si cada cliente realizó un solo pedido o si realizó compras recurrentes.
WITH cantidad_compras_cliente AS (
    SELECT c.customer_unique_id, COUNT (o.order_id) AS cantidad_pedidos
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT customer_unique_id, cantidad_pedidos,
CASE
    WHEN cantidad_pedidos = 1 THEN 'Cliente nuevo'
    WHEN cantidad_pedidos > 1 THEN 'Cliente recurrente'
    ELSE 'S/D'
    END AS tipo_cliente
FROM cantidad_compras_cliente

-- ----------------------------------------------------------------
-- 13. Estado del crecimiento mensual. Para cada mes indicar:
--  Aumentó; Disminuyó; Sin cambios
WITH gastos_mensuales AS (
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS mes, SUM(op.payment_value) AS total_actual
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
),
gastos_mensuales_anterior AS (
    SELECT mes, total_actual, 
    LAG (total_actual) OVER (
        ORDER BY mes
    ) AS total_anterior 
    FROM gastos_mensuales
)
SELECT mes, total_actual, total_anterior,
CASE
    WHEN total_actual > total_anterior THEN 'Aumentó'
    WHEN total_actual < total_anterior THEN 'Disminuyó'
    WHEN total_actual = total_anterior THEN 'Sin cambios'
    ELSE 'S/N'
    END AS tipo_crecimiento_mensual
FROM gastos_mensuales_anterior


-- ----------------------------------------------------------------
-- 14. ¿Cuántos productos fueron vendidos?
SELECT product_id, COUNT (product_id) AS cantidad_productos
FROM order_items
GROUP BY product_id

SELECT COUNT(DISTINCT product_id) AS productos_vendidos
FROM order_items;
-- ----------------------------------------------------------------
-- 15. ¿Cuántas líneas de pedido fueron realizadas?
SELECT COUNT(DISTINCT order_id)
FROM order_items;

-- ----------------------------------------------------------------
-- 16. ¿Cuántos pedidos distintos se realizaron?
SELECT COUNT(DISTINCT order_id)
FROM order_items;
-- ----------------------------------------------------------------
-- 17. ¿Cuántos clientes distintos compraron?
SELECT COUNT(DISTINCT c.customer_unique_id) AS clientes_distintos
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;


SELECT COUNT(DISTINCT c.customer_unique_id) AS clientes_distintos
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.customer_id IS NOT NULL;
-- ----------------------------------------------------------------
-- 18. Detectar clientes que aparecen asociados a más de un customer_id.
SELECT c.customer_unique_id, COUNT(DISTINCT o.customer_id) AS cantidad_ids
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.customer_id) > 1

SELECT 
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS cantidad_ids
FROM customers
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT customer_id) > 1;

-- Cuantos son
WITH id_repetidos AS (
SELECT c.customer_unique_id, COUNT(DISTINCT o.customer_id) AS cantidad_ids
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.customer_id) > 1
)
SELECT COUNT(*) AS cantidad_repetidos
FROM id_repetidos;

-- ----------------------------------------------------------------
-- 19. Detectar pedidos que tienen más de una fila en order_payments.
SELECT order_id, COUNT(order_id) AS cantidad_pagos
FROM order_payments
GROUP BY order_id
HAVING COUNT(order_id) > 1 

-- ----------------------------------------------------------------
-- 20. Detectar pedidos que tienen más de un producto.
SELECT order_id, COUNT(product_id) AS cantidad_productos
FROM order_items
GROUP BY order_id
HAVING COUNT(product_id) > 1

-- ----------------------------------------------------------------
-- 21. Ticket promedio. Calcular el ticket promedio por pedido.
WITH total_pedidos AS (
    SELECT order_id, SUM(payment_value) AS total_pedido
    FROM order_payments
    GROUP BY order_id
)

SELECT AVG(total_pedido) AS ticket_promedio
FROM total_pedidos;

-- ----------------------------------------------------------------
-- 22. Ticket promedio mensual. Para cada mes, calcular: ventas totales; cantidad de pedidos; ticket promedio
WITH total_pedidos AS (
    SELECT o.order_id, DATE_TRUNC('month', o.order_purchase_timestamp) AS mes,
        SUM(op.payment_value) AS total_pedido
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY
        o.order_id,
        DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT mes, SUM(total_pedido) AS suma, ROUND(AVG(total_pedido)) AS promedio, COUNT(total_pedido) AS cantidad
FROM total_pedidos
GROUP BY mes
ORDER BY mes;
-- ----------------------------------------------------------------
-- 23. Clientes nuevos por mes. Para cada mes, calcular cuántos clientes realizaron su primera compra.

--  Primero busco cual fue la primera compra por cliente
WITH primera_fecha_cliente AS (
    SELECT c.customer_unique_id, MIN(o.order_purchase_timestamp) AS primera_fecha
    FROM customers c 
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
--  Calcular cantidad por mes
SELECT DATE_TRUNC('month', primera_fecha) AS mes,  COUNT(customer_unique_id) AS cantidad_clientes_mes
FROM primera_fecha_cliente
GROUP BY DATE_TRUNC('month', primera_fecha)
ORDER BY mes;



-- ----------------------------------------------------------------
-- 24. Clientes recurrentes por mes. Para cada mes, calcular cuántos clientes que ya habían comprado anteriormente volvieron a comprar.
WITH compras AS (
    SELECT DATE_TRUNC ('month', o.order_purchase_timestamp) AS mes, c.customer_unique_id
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY DATE_TRUNC ('month', o.order_purchase_timestamp), c.customer_unique_id
),
clientes_recurrentes AS (
    SELECT mes, customer_unique_id, 
    MIN(mes) OVER (

        PARTITION BY customer_unique_id

    ) AS primer_mes
    FROM compras
)
SELECT
    mes,
    COUNT(customer_unique_id) AS cantidad_clientes
FROM clientes_recurrentes
WHERE mes > primer_mes
GROUP BY mes
ORDER BY mes;


-- ----------------------------------------------------------------
-- 25. Tasa de clientes recurrentes. Para cada mes, calcular el porcentaje de clientes que realizaron una compra y que ya habían comprado anteriormente.
WITH compras_clientes AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS mes, c.customer_unique_id--,

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp), c.customer_unique_id
    ORDER BY mes
) ,
primera_compra AS (
    SELECT mes, customer_unique_id,
    MIN (mes ) OVER (
        PARTITION BY customer_unique_id
    ) AS primer_mes

    FROM compras_clientes
    ORDER BY mes
),
total_clientes AS (
    SELECT 
        mes,
        COUNT(customer_unique_id) AS cantidad_clientes_total
    FROM compras_clientes
    GROUP BY mes
),
clientes_recurrentes AS (
    SELECT
        mes,
        COUNT(customer_unique_id) AS cantidad_clientes_recurrentes
    FROM primera_compra
    WHERE mes > primer_mes
    GROUP BY mes
)
SELECT t.mes, t.cantidad_clientes_total,
    COALESCE(r.cantidad_clientes_recurrentes, 0) AS cantidad_clientes_recurrentes,
    ROUND(100.0 * COALESCE(r.cantidad_clientes_recurrentes, 0) 
        / t.cantidad_clientes_total,2) AS porcentaje_recurrentes
FROM total_clientes t
LEFT JOIN clientes_recurrentes r
    ON t.mes = r.mes
ORDER BY t.mes;

-- ----------------------------------------------------------------
-- 26. Obtener los 10 productos con mayor cantidad de unidades vendidas.

-- ----------------------------------------------------------------
-- 27. Obtener los 10 productos con mayor facturación.

-- ----------------------------------------------------------------
-- 28. Para cada categoría, obtener el producto con mayor facturación.


-- ----------------------------------------------------------------
-- 29. Obtener las 3 categorías con mayor facturación.


-- ----------------------------------------------------------------
-- 30. Calcular qué porcentaje de las ventas totales representa cada estado.


-- ----------------------------------------------------------------
-- 31. Calcular qué porcentaje de las ventas totales representa cada categoría.

-- ----------------------------------------------------------------
-- 32. Obtener la cantidad de días entre la fecha de compra y la fecha de entrega estimada.


-- ----------------------------------------------------------------
-- 33. Obtener la cantidad de días entre la compra y la entrega real.


-- ----------------------------------------------------------------
-- 34. Calcular el porcentaje de pedidos entregados antes de la fecha estimada.

-- ----------------------------------------------------------------
-- 35. Para cada mes, calcular el tiempo promedio de entrega.

-- ----------------------------------------------------------------
-- 36. Identificar los pedidos que tardaron más de 10 días en ser entregados.

-- ----------------------------------------------------------------
-- 37. Obtener los clientes cuyo gasto total está por encima del gasto promedio de todos los clientes.

-- ----------------------------------------------------------------
-- 38. Obtener los productos cuyo precio es superior al precio promedio de todos los productos.

-- ----------------------------------------------------------------
-- 39. Obtener los vendedores cuyas ventas están por encima de la venta promedio de los vendedores.


-- ----------------------------------------------------------------
-- 40. La empresa quiere identificar sus clientes más valiosos. Obtener los clientes que realizaron al menos 3 pedidos
-- y cuyo gasto total está dentro del 20% superior de clientes.


-- ----------------------------------------------------------------
-- 41. Para cada mes, mostrar ventas totales, cantidad de clientes, ticket promedio y crecimiento respecto al mes anterior.

-- ----------------------------------------------------------------
-- 42. Para cada categoría, mostrar ventas totales, cantidad de pedidos, ticket promedio y posición respecto a las demás categorías.

-- ----------------------------------------------------------------
-- 43. Identificar los clientes que realizaron su primera compra, volvieron a comprar dentro de 30 días y cuánto gastaron en ambas compras.

-- ----------------------------------------------------------------
