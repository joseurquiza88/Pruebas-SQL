-- Consultas de SQL nivel intermedio-avanzado

-- ---------------------------------------------------------------------------------------
-- Subconsultas (8 ejercicios)

-- ###################################################################
-- Mostrar los pedidos cuyo monto total sea mayor que el promedio de todos los pedidos.

-- ###################################################################
-- Mostrar los clientes que realizaron más pedidos que el promedio de pedidos por cliente.

-- ###################################################################
-- Mostrar las categorías cuyo precio promedio sea mayor que el precio promedio de todas las categorías.

-- ###################################################################
-- ¿Cuántos clientes realizaron más compras que el promedio? (Acá aparece una subconsulta en el FROM.)

-- ###################################################################
-- Mostrar los vendedores cuyo ingreso total sea superior al ingreso promedio de todos los vendedores.

-- ###################################################################
-- Mostrar los pedidos cuyo tiempo de entrega fue mayor al promedio de días de entrega.

-- ###################################################################
-- Mostrar los productos cuyo precio promedio es mayor que el promedio del precio de todos los productos vendidos.

-- ###################################################################
-- Mostrar los estados donde la cantidad de pedidos supera el promedio de pedidos por estado.

-- ---------------------------------------------------------------------------------------
--  CTE (6 ejercicios)

-- ###################################################################
-- Usando una CTE, calcular el total gastado por cliente y mostrar los 10 clientes con mayor gasto.
SELECT * FROM order_payments;
SELECT * FROM orders;
WITH gasto_clientes AS (
    SELECT 
        o.customer_id,
        SUM(op.payment_value) AS gasto_total
    FROM orders o
    JOIN order_payments op
        ON o.order_id = op.order_id
    GROUP BY o.customer_id
)

SELECT 
    customer_id,
    gasto_total
FROM gasto_clientes
ORDER BY gasto_total DESC
LIMIT 10;


-- ###################################################################
-- Usando una CTE, calcular la cantidad de pedidos por mes y mostrar el mes con más pedidos.

SELECT * FROM orders;

WITH pedidos_por_mes AS (
    SELECT 
        DATE_TRUNC('month', order_purchase_timestamp) AS mes,
        COUNT(order_id) AS cantidad_pedidos
    FROM orders
    GROUP BY DATE_TRUNC('month', order_purchase_timestamp)
)

SELECT 
    mes,
    cantidad_pedidos
FROM pedidos_por_mes
ORDER BY cantidad_pedidos DESC
LIMIT 1;

-- ###################################################################
-- Usando una CTE, calcular el promedio de entrega por vendedor.

-- ###################################################################
-- Usando una CTE, calcular el total vendido por categoría y mostrar solo las categorías cuyo total supera el promedio.

-- ###################################################################
-- Usando una CTE, calcular la cantidad de productos vendidos por vendedor y mostrar el Top 5.

-- ###################################################################
-- Usando dos CTE, calcular los pedidos por mes y luego el crecimiento respecto al mes anterior (sin usar LAG, solo para entender cómo dividir el problema).

-- ---------------------------------------------------------------------------------------
-- Módulo 3 - EXISTS / NOT EXISTS (5 ejercicios)

-- Acá la pregunta mental cambia a: "¿Existe o no existe?"

-- ###################################################################
-- Mostrar los clientes que realizaron al menos un pedido.

-- ###################################################################
-- Mostrar los clientes que nunca realizaron pedidos.

-- ###################################################################
-- Mostrar los productos que fueron vendidos al menos una vez.

-- ###################################################################
-- Mostrar los productos que nunca fueron vendidos.

-- ###################################################################
--  Mostrar los vendedores que nunca participaron en un pedido entregado.

-- ---------------------------------------------------------------------------------------
-- Módulo 4 - Window Functions (6 ejercicios) Acá recién aparecen las funciones de ventana.

-- ###################################################################
-- Mostrar cada pedido junto con la fecha del pedido anterior (LAG).

-- ###################################################################
-- Mostrar la cantidad de pedidos por mes y la cantidad del mes anterior (LAG).

-- ###################################################################
-- Calcular la diferencia de pedidos respecto al mes anterior.

-- ###################################################################
-- Calcular el porcentaje de variación respecto al mes anterior.

-- ###################################################################
-- Numerar todos los pedidos de cada cliente según la fecha (ROW_NUMBER).

-- ###################################################################
-- Mostrar el primer pedido realizado por cada cliente (ROW_NUMBER + CTE).