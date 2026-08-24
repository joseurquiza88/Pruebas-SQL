
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

WITH ventas AS (
    SELECT c.customer_unique_id, o.order_purchase_timestamp AS fecha, op.payment_value AS venta_cliente,
    LAG(op.payment_value,1) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS venta_anterior,

    LAG(op.payment_value,2) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS venta_anterior_anterior

    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_payments op
    ON o.order_id = op.order_id
)
SELECT customer_unique_id, fecha, venta_cliente, 
-- ROUND((venta_cliente + NULLIF(venta_anterior,0) + NULLIF(venta_anterior_anterior,0))/3,2) AS promedio_ventas_anteriores
ROUND(
    (venta_cliente + COALESCE(venta_anterior, 0) + COALESCE(venta_anterior_anterior, 0)) /
    (
        1
        + CASE WHEN venta_anterior IS NOT NULL THEN 1 ELSE 0 END
        + CASE WHEN venta_anterior_anterior IS NOT NULL THEN 1 ELSE 0 END
    ),    2
) AS promedio_ventas
FROM ventas
ORDER BY fecha


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
-- 18. Ventas mensuales: Obtener para cada mes el total de ventas, la cantidad de pedidos realizados
-- y la variación porcentual de las ventas respecto al mes anterior.
WITH ventas_mensuales AS (
    SELECT DATE_TRUNC ('month',o.order_purchase_timestamp) AS mes, 
    SUM(op.payment_value) AS ventas_mensual_actual,
    COUNT(DISTINCT o.order_id) AS cantidad_pedidos,
    LAG (SUM(op.payment_value)) OVER (
        -- PARTITION BY DATE_TRUNC ('month',o.order_purchase_timestamp). Esto no lo hagoporque ya se hace el group by despues
        ORDER BY DATE_TRUNC ('month',o.order_purchase_timestamp)
    ) AS venta_mensual_anterior
    FROM orders o
    JOIN order_payments op
    ON o.order_id = op.order_id
    GROUP BY DATE_TRUNC ('month',o.order_purchase_timestamp)
    ORDER BY mes
)
SELECT mes,cantidad_pedidos, ventas_mensual_actual,
 ROUND(((ventas_mensual_actual-venta_mensual_anterior)/NULLIF(venta_mensual_anterior,0))*100,2) AS variacion
FROM ventas_mensuales





-- ----------------------------------------------------------------
-- 19. Evolución mensual de las ventas: Para cada mes, mostrar el total de ventas, 
-- el total de ventas del mes anterior y la variación absoluta y porcentual respecto al mes anterior. 
-- Ordenar los resultados
WITH ventas_mensual AS (
    SELECT DATE_TRUNC ('month', order_purchase_timestamp) AS mes,
    SUM(op.payment_value) AS ventas_actual,
    LAG (SUM(op.payment_value)) OVER (
        ORDER BY DATE_TRUNC ('month', order_purchase_timestamp)
    ) AS ventas_mes_anterior
    FROM orders o
    JOIN order_payments op
    ON o.order_id = op.order_id
    GROUP BY DATE_TRUNC ('month', order_purchase_timestamp)
)
-- variación absoluta y porcentual respecto al mes anterior.
SELECT mes, ventas_actual, ventas_mes_anterior,
( ventas_actual -  ventas_mes_anterior)AS variacion_absoluta,
ROUND(((ventas_actual-ventas_mes_anterior)/NULLIF(ventas_mes_anterior,0))*100,2) AS variacion_porcentual
FROM ventas_mensual
ORDER BY mes


-- ----------------------------------------------------------------
-- 20. Ranking mensual de clientes: Para cada mes, obtener los 5 clientes con mayor monto total de compras.
-- Mostrar el mes, el cliente, el total comprado y su posición dentro del ranking mensual.
WITH ventas_total_mes_clientes AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS mes,
    c.customer_unique_id AS cliente,
    SUM (op.payment_value) AS total_compras
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_payments op
    ON o.order_id = op.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp), c.customer_unique_id
),
ranking_clientes AS (
SELECT mes, cliente, total_compras,
RANK () OVER (
    PARTITION BY mes
    ORDER BY total_compras DESC
) AS ranking
FROM ventas_total_mes_clientes
)
SELECT mes, cliente, total_compras, ranking
FROM ranking_clientes
WHERE ranking <= 5
ORDER BY mes, ranking;


-- ----------------------------------------------------------------
-- 21. Obtener los 3 pedidos más recientes de cada cliente.
WITH pedidos_clientes AS (
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp AS fecha,
    RANK () OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp DESC
    ) AS ranking
    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
    -- ORDER BY c.customer_unique_id, ranking;
)
SELECT customer_unique_id, order_id, fecha, ranking
FROM pedidos_clientes
WHERE ranking <= 3
ORDER BY customer_unique_id, ranking;



-- ----------------------------------------------------------------
-- 22. Obtener el top 3 de vendedores por estado, permitiendo empates
WITH vendedores_por_estado AS (
    SELECT s.seller_id, s.seller_state, SUM(op.payment_value) as total_ventas,
    RANK () OVER (
        PARTITION BY s.seller_state
        ORDER BY SUM(op.payment_value) DESC
    ) AS ranking_vendedores
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id = oi.seller_id

    JOIN order_payments op
    ON oi.order_id = op.order_id
     GROUP BY s.seller_id, s.seller_state
    -- ORDER BY  s.seller_state, ranking_vendedores;
)
SELECT seller_id, seller_state, total_ventas, ranking_vendedores
FROM vendedores_por_estado
WHERE ranking_vendedores <= 3
ORDER BY seller_state, ranking_vendedores;

-- ----------------------------------------------------------------
-- 23. Calcular las ventas mensuales, las ventas del mes anterior, la variación porcentual y las ventas acumuladas.
WITH ventas AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS fecha, SUM(op.payment_value) AS total_venta_actual,
    LAG (SUM(op.payment_value)) OVER (
        -- esto no va porque se hace un group by despues, ya esta agrupad, y no queremos hacer un cálculo independiente para cada mes.
        -- PARTITION BY DATE_TRUNC('month', o.order_purchase_timestamp), 
        
        ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)  
    ) AS total_venta_anterior
    FROM orders o
    JOIN order_payments op
    ON o.order_id = op.order_id
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
    ORDER BY fecha
) 
SELECT fecha, total_venta_actual, total_venta_anterior,
-- variación porcentual 
ROUND(((total_venta_actual -  total_venta_anterior) / NULLIF(total_venta_anterior,0))*100,2) AS variacion_porcentual,
-- ventas acumuladas
SUM(total_venta_actual) OVER (
    ORDER BY fecha) AS ventas_acumuladas
FROM ventas



-- ----------------------------------------------------------------
-- 24. Para cada cliente, mostrar todos sus pedidos junto con el número de pedido que representa dentro de su historial de compras. 
-- Ordenarlos cronológicamente.

SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp,
ROW_NUMBER() OVER (
    PARTITION BY c.customer_unique_id
    ORDER BY o.order_purchase_timestamp
) AS numero_pedido
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
ORDER BY c.customer_unique_id, o.order_purchase_timestamp


-- ----------------------------------------------------------------
-- 25. Clientes con su segunda compra
-- Obtener únicamente aquellos clientes que realizaron al menos dos pedidos y mostrar su segundo pedido, 
-- junto con la fecha en que lo realizaron.

WITH pedidos AS (
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp,
    ROW_NUMBER () OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS numero_pedido

    FROM orders o
    JOIN customers c
    ON o.customer_id = c.customer_id
)
SELECT *
FROM pedidos
WHERE numero_pedido = 2


-- ----------------------------------------------------------------
-- 26. Vendedores con la misma posición
-- Para cada estado, obtener los vendedores ordenados según sus ventas totales. 
-- Mostrar todos los vendedores y su posición dentro del estado. Los vendedores con el mismo monto de ventas deben 
-- compartir posición.

SELECT s.seller_state, s.seller_id,  SUM(op.payment_value) as ventas_vendedor,
RANK () OVER (
    PARTITION BY s.seller_state
    ORDER BY SUM(op.payment_value) DESC
) as ranking_monto_ventas
FROM sellers s
JOIN order_items oi
ON s.seller_id = oi.seller_id
JOIN order_payments op
ON oi.order_id = op.order_id 
GROUP BY s.seller_id, s.seller_state
ORDER BY ventas_vendedor, s.seller_state;

-- ----------------------------------------------------------------
-- 27. Top 3 vendedores, exactamente 3 por estado
-- Para cada estado, obtener exactamente los 3 vendedores con mayores ventas. 
-- En caso de empate, igualmente deben aparecer exactamente 3 vendedores.

WITH ranking_vendedores AS (
    SELECT s.seller_state, s.seller_id, SUM(op.payment_value) AS total_ventas_cliente,
    ROW_NUMBER () OVER (
        PARTITION BY s.seller_state
        ORDER BY SUM(op.payment_value) DESC
    ) AS ranking
    FROM sellers s
    JOIN order_items oi
    ON s.seller_id = oi.seller_id
    JOIN order_payments op
    ON oi.order_id = op.order_id
    GROUP BY s.seller_id, s.seller_state
    -- ORDER BY s.seller_state, ranking
)
SELECT *
FROM ranking_vendedores
WHERE ranking <=3;



-- ----------------------------------------------------------------
-- 28. Diferencia entre pedidos
-- Para cada cliente, mostrar cada pedido junto con la cantidad de días transcurridos desde su pedido anterior.

WITH fechas_pedidos AS (
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp AS fecha_actual,
    LAG (o.order_purchase_timestamp) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY  o.order_purchase_timestamp
    ) AS fecha_anterior
    FROM customers c

    JOIN orders o
    ON c.customer_id = o.customer_id
)
SELECT customer_unique_id, order_id, fecha_actual,fecha_anterior,
fecha_actual::date - fecha_anterior::date AS diferencia_dias
FROM fechas_pedidos
WHERE fecha_anterior IS NOT NULL
ORDER BY diferencia_dias DESC;



-- ----------------------------------------------------------------
-- 29. Tiempo hasta la próxima compra
-- Para cada cliente, mostrar cada pedido junto con la cantidad de días que faltaron hasta su siguiente pedido. 
-- Excluir el último pedido de cada cliente.
WITH fecha_pedidos AS (
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp AS fecha_pedido_actual,
    LEAD (o.order_purchase_timestamp) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS fecha_pedido_siguiente
    FROM customers c

    JOIN orders o
    ON c.customer_id = o.customer_id
)
SELECT customer_unique_id, order_id,  fecha_pedido_actual,

fecha_pedido_siguiente::date - fecha_pedido_actual::date AS diferencia_dias
FROM fechas_pedidos
WHERE fecha_pedido_siguiente IS NOT NULL
ORDER BY diferencia_dias DESC;



-- ----------------------------------------------------------------
-- 30. Detectar clientes que aumentaron su compra
-- Para cada cliente, mostrar cada compra, la compra anterior y una columna que indique
-- si la compra actual fue mayor, menor o igual que la anterior.

WITH compras AS (
    SELECT c.customer_unique_id, o.order_id, o.order_purchase_timestamp AS fecha, op.payment_value compra_actual,
    LAG (op.payment_value) OVER (
        PARTITION BY c.customer_unique_id
        ORDER BY o.order_purchase_timestamp
    ) AS compra_anterior
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    JOIN order_payments op
    ON o.order_id = op.order_id
)
SELECT customer_unique_id, fecha, compra_actual, compra_anterior,
CASE
    WHEN compra_anterior IS NULL THEN 'Primera compra'
    WHEN compra_actual > compra_anterior THEN 'Mayor'
    WHEN compra_actual < compra_anterior THEN 'Menor'
    WHEN compra_actual = compra_anterior THEN 'Igual'
END AS comparacion
FROM compras

-- ----------------------------------------------------------------
-- 31. Porcentaje acumulado de ventas
-- Ordenar las ventas mensuales cronológicamente y mostrar para cada mes el total vendido 
-- y qué porcentaje representan las ventas acumuladas hasta ese momento respecto del total de ventas del período.

-- ESTA MAL!!! REVISAR!!

WITH ventas_mensuales AS (
SELECT DATE_TRUNC('month', o.order_purchase_timestamp) AS mes, SUM(op.payment_value) AS total_mensual,
SUM (op.payment_value) OVER (
    ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
) AS total_acumulado
FROM orders o
JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
-- ORDER BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT order_id, mes, total_mensual, total_acumulado, 
((total_acumulado / total_mensual )* 100)  AS porcentaje_venta_total
FROM ventas_mensuales
-- ----------------------------------------------------------------
-- 32. Porcentaje acumulado dentro de cada cliente
-- Para cada cliente, mostrar sus pedidos ordenados cronológicamente,
-- el monto de cada pedido y el porcentaje que representa el gasto acumulado hasta ese pedido respecto del gasto total del cliente.




-- ----------------------------------------------------------------
-- 33. Ventas acumuladas por estado
-- Para cada estado, mostrar las ventas de cada mes y las ventas acumuladas desde el primer mes registrado para ese estado.




-- ----------------------------------------------------------------
-- 34. Clientes por encima del promedio
-- Para cada cliente, calcular el total gastado y compararlo con el promedio
--  de gasto de todos los clientes. Mostrar solamente los clientes cuyo gasto total esté por encima del promedio.




-- ----------------------------------------------------------------
-- 35. Compra por encima del promedio del cliente
-- Para cada cliente, mostrar sus pedidos, el valor de cada pedido y el promedio de sus pedidos. 
-- Indicar si el pedido estuvo por encima o por debajo del promedio del cliente.



-- ----------------------------------------------------------------
-- 36. Para cada cliente, mostrar su pedido más reciente.

-- ----------------------------------------------------------------
-- 37. Para cada cliente, mostrar su segundo pedido.

-- ----------------------------------------------------------------
-- 38. Para cada cliente, mostrar la diferencia de días entre cada compra y la anterior.

-- ----------------------------------------------------------------
-- 39. Para cada estado, mostrar el vendedor que ocupa el segundo puesto en ventas.

-- ----------------------------------------------------------------
-- 40. Para cada estado, mostrar los vendedores que están dentro de los tres primeros puestos, permitiendo empates.

-- ----------------------------------------------------------------
-- 41. Para cada cliente, mostrar cuánto lleva gastado acumulado después de cada pedido.

-- ----------------------------------------------------------------
-- 42. Para cada mes, indicar si las ventas aumentaron o disminuyeron respecto al mes anterior.

-- ----------------------------------------------------------------
-- 43. Para cada cliente, mostrar su compra y el promedio de sus compras.

-- ----------------------------------------------------------------
-- 44. Para cada mes, mostrar qué porcentaje de las ventas acumuladas representa sobre el total del período.

-- ----------------------------------------------------------------
-- 45. Para cada cliente, encontrar el pedido inmediatamente anterior al pedido más reciente.