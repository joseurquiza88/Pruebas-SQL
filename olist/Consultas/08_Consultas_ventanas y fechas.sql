
-- Ejercicios para practicar funciones de ventanas y fechas
-- ROW_NUMBER () OVER (
--     ORDER BY
-- )

-- LAG(columna_interes) OVER (
--     ORDER BY fecha
-- )


-- ----------------------------------------------------------------
-- 1. Asignar un número consecutivo a cada pedido ordenándolos desde el más antiguo al más reciente.
SELECT order_id, order_purchase_timestamp,
ROW_NUMBER () OVER (
    ORDER BY order_purchase_timestamp
) AS numero_pedido
 FROM orders;

-- ----------------------------------------------------------------
-- 2. Enumerar los pedidos dentro de cada cliente, comenzando nuevamente desde 1 para cada cliente.
SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp,
ROW_NUMBER () OVER (
    PARTITION BY c.customer_unique_id 
    ORDER BY o.order_purchase_timestamp
) AS numero_pedido_cliente
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
-- ORDER BY c.customer_unique_id, o.order_purchase_timestamp;



-- ----------------------------------------------------------------
-- 3. Obtener solamente el pedido más reciente de cada cliente.
WITH pedidos_enumerados AS (
    SELECT o.order_id, c.customer_unique_id, o.order_purchase_timestamp,
    ROW_NUMBER () OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp DESC
    ) AS pedido
    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
)
SELECT order_id, customer_unique_id, order_purchase_timestamp
FROM pedidos_enumerados
WHERE pedido = 1

-- ----------------------------------------------------------------
-- 4. Crear un ranking de vendedores según sus ventas.
SELECT * FROM sellers
SELECT * FROM order_items
WITH ventas_por_vendedor AS (
    SELECT s.seller_id, SUM(oi.price) AS total_ventas
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id = oi.seller_id
    GROUP  BY s.seller_id
)
SELECT seller_id, total_ventas,
RANK() OVER (
    ORDER BY total_ventas DESC
) AS ranking
FROM ventas_por_vendedor;

-- ----------------------------------------------------------------
-- 5. Sin el join, porque ya tengo la info necesaria en order_items
WITH total_ventas_vendedores AS (
    SELECT seller_id, SUM(price) AS total_ventas
    FROM order_items
    GROUP BY seller_id
)
SELECT seller_id, total_ventas,
RANK () OVER (
    ORDER BY total_ventas DESC
) as ranking
FROM total_ventas_vendedores

-- ----------------------------------------------------------------
-- 6. Crear un ranking de vendedores según la cantidad de pedidos que realizaron, utilizando DENSE_RANK().
WITH cantidad_pedidos_vendedor AS(
    SELECT seller_id, COUNT(DISTINCT order_id) AS cantidad_pedidos
    FROM order_items
    GROUP BY seller_id
)
SELECT seller_id, cantidad_pedidos,
DENSE_RANK () OVER (
    ORDER BY cantidad_pedidos DESC
) AS ranking
FROM cantidad_pedidos_vendedor

-- ----------------------------------------------------------------
-- 7. Queremos obtener el vendedor con mayores ventas dentro de cada estado.
WITH total_ventas_vendedor AS (
    SELECT s.seller_id, s.seller_state, SUM(oi.price) AS total_ventas
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id = oi.seller_id
    GROUP BY s.seller_id, s.seller_state
),
ranking_vendedores AS(
SELECT seller_id, seller_state, total_ventas,
RANK () OVER (
    PARTITION BY seller_state
    ORDER BY total_ventas DESC
) AS ranking
FROM total_ventas_vendedor
)
SELECT seller_id, seller_state, total_ventas, ranking
FROM ranking_vendedores
WHERE ranking = 1

-- ----------------------------------------------------------------
-- LAG()
-- 7. Mostrar las ventas del mes anterior.
-- ojo price vs payment_value

SELECT  DATE_TRUNC('month', o.order_purchase_timestamp) AS MES, SUM(oi.price) total_ventas_actual,
LAG (SUM(oi.price)) OVER (
    ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp) 
) AS total_ventas_mes_anterior
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp) 
ORDER BY mes


-- ----------------------------------------------------------------
-- 8. Calcular la variación absoluta (columna price) respecto al mes anterior.
WITH resumen_ventas_mensuales AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS mes, SUM(oi.price) AS total_ventas_actual,
    LAG(SUM(oi.price)) OVER (
        ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp) 
    ) AS total_ventas_mes_anterior
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp)
)
SELECT mes, total_ventas_actual,total_ventas_mes_anterior, 
ROUND((total_ventas_actual / NULLIF(total_ventas_mes_anterior, 0)*100),2) AS variacion_absoluta

FROM resumen_ventas_mensuales 
ORDER BY variacion_absoluta DESC

-- ----------------------------------------------------------------
-- 9. Calcular el crecimiento porcentual mensual.
WITH variacion_ventas AS (
    SELECT DATE_TRUNC('month',o.order_purchase_timestamp) AS mes, SUM(oi.price) total_ventas_actual,
    LAG(SUM(oi.price)) OVER (
        ORDER BY DATE_TRUNC('month',o.order_purchase_timestamp)
    ) AS total_ventas_mes_anterior
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month',o.order_purchase_timestamp) 
    
)
SELECT mes, total_ventas_actual, total_ventas_mes_anterior,
ROUND(((total_ventas_actual-total_ventas_mes_anterior)/NULLIF(total_ventas_mes_anterior,0))*100,2)
AS crecimiento_porcentual_mensual
FROM variacion_ventas
ORDER BY mes


-- ----------------------------------------------------------------
-- LEAD()
-- 10. Mostrar el siguiente pedido de cada cliente.

SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp,
LEAD(o.order_id) OVER (
    PARTITION BY c.customer_unique_id
    ORDER BY o.order_purchase_timestamp
    
) AS pedido_siguiente
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
ORDER BY c.customer_unique_id, o.order_purchase_timestamp;


-- ----------------------------------------------------------------
-- 11. Calcular cuántos días pasan hasta el siguiente pedido de cada cliente
WITH fecha_pedidos AS(
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp AS fecha_actual,
    LEAD(o.order_purchase_timestamp) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS fecha_posterior

    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
)
SELECT customer_unique_id, fecha_actual, fecha_posterior, 
-- fecha_posterior - fecha_actual AS diferencia_dias
-- EXTRACT(DAY FROM (fecha_posterior - fecha_actual)) AS diferencia_dias
(fecha_posterior::date - fecha_actual::date) AS diferencia_dias
FROM fecha_pedidos
-- Se pone para visualizar cuales son los clientes que hicieron 2 pedidos
WHERE (fecha_posterior::date - fecha_actual::date)  > 0 
ORDER BY diferencia_dias ASC


-- ----------------------------------------------------------------
-- 11. Encontrar clientes que volvieron a comprar dentro de los 30 días.
WITH fecha_pedidos AS(
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp AS fecha_actual,
    LEAD(o.order_purchase_timestamp) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS fecha_posterior

    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
)
SELECT customer_unique_id, fecha_actual, fecha_posterior, 
(fecha_posterior::date - fecha_actual::date) AS diferencia_dias
FROM fecha_pedidos
WHERE (fecha_posterior::date - fecha_actual::date) BETWEEN 1 AND 30


-- ----------------------------------------------------------------
-- 12. Calcular las ventas totales de cada cliente sin perder las ventas individuales.

SELECT c.customer_unique_id, o.order_id, oi.price AS venta_individual,
    SUM(oi.price) OVER (
        PARTITION BY c.customer_unique_id
    ) AS ventas_totales_cliente
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id

JOIN customers c
ON o.customer_id = c.customer_id;

-- ----------------------------------------------------------------
-- 13. Calcular las ventas acumuladas por fecha.
-- SELECT * FROM orders;
WITH ventas_diarias AS (
    SELECT o.order_purchase_timestamp::date AS fecha, SUM(oi.price) AS ventas_por_dia
    FROM orders o
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY o.order_purchase_timestamp::date
)
SELECT fecha, ventas_por_dia, 
SUM(ventas_por_dia) OVER (
    ORDER BY fecha
    ) AS ventas_acumuladas
FROM ventas_diarias
ORDER BY fecha;


-- ----------------------------------------------------------------
-- 14. Para cada cliente, mostrar cuánto lleva gastado en total hasta cada
-- uno de sus pedidos, siguiendo el orden de compra en el tiempo.
-- Ventas acumuladas → importa el orden.
WITH ventas_por_pedido AS (
    SELECT
        o.order_id, c.customer_unique_id, o.order_purchase_timestamp, SUM(oi.price) AS venta_pedido
    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
    JOIN order_items oi
    ON o.order_id = oi.order_id
    GROUP BY o.order_id, c.customer_unique_id, o.order_purchase_timestamp
)
SELECT
    customer_unique_id, order_id, order_purchase_timestamp, venta_pedido,
    SUM(venta_pedido) OVER (
        PARTITION BY customer_unique_id
        ORDER BY order_purchase_timestamp
    ) AS venta_acumulada

FROM ventas_por_pedido;




-- ----------------------------------------------------------------
-- 15. Mostrar cada venta junto con el promedio de ventas del cliente.
-- No importa el orden pero tengo un grupo
SELECT c.customer_unique_id, oi.price,
ROUND(AVG (oi.price) OVER (
    PARTITION BY c.customer_unique_id
),2) AS promedio_venta_cliente
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id



-- ----------------------------------------------------------------
-- 16. Para cada cliente, mostrar cada una de sus ventas junto con el promedio de esa venta y las 2 ventas anteriores,
 -- ordenadas por fecha.




-- ----------------------------------------------------------------
-- 17. Calcular el promedio mensual de ventas y compararlo con el promedio general.
WITH datos AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS mes,
        oi.price
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
),

promedio_general AS (
    SELECT AVG(price) AS promedio_general
    FROM datos
)

SELECT
    d.mes,
    AVG(d.price) AS promedio_mensual,
    pg.promedio_general
FROM datos d
CROSS JOIN promedio_general pg
GROUP BY d.mes, pg.promedio_general;


-- ----------------------------------------------------------------
-- 18. Ventas mensuales: Obtener las ventas totales de cada mes.



-- ----------------------------------------------------------------
-- 19. Ventas mensuales + mes anterior



-- ----------------------------------------------------------------
-- 20. Calcular las ventas mensuales y el crecimiento porcentual respecto al mes anterior.






-- ----------------------------------------------------------------
-- 21. Obtener los 3 pedidos más recientes de cada cliente.





-- ----------------------------------------------------------------
-- 22. Obtener el top 3 de vendedores por estado, permitiendo empates



-- ----------------------------------------------------------------
-- 23. Calcular las ventas mensuales, las ventas del mes anterior, la variación porcentual y las ventas acumuladas.



-- ----------------------------------------------------------------
-- 




-- ----------------------------------------------------------------
-- 