-- Vemos la tablas
USE newschema_03;
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products_tiny;
-- Hay que revisar cuando las consultas puedan tener un empate con HAVING

-- ¿Qué producto tiene el precio más alto? Devuelva una sola fila
SELECT product_name, price
FROM products_tiny
WHERE price = (SELECT MAX(price) FROM products_tiny);


-- ¿Qué cliente ha realizado más pedidos?
SELECT customers.customer_id, customers.first_name, customers.last_name, COUNT(DISTINCT orders.order_id) AS cantidad_pedidos
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY 
    customers.customer_id, 
    customers.first_name, 
    customers.last_name
ORDER BY cantidad_pedidos DESC
LIMIT 1;


-- ¿Cuál es el ingreso total por producto?
SELECT products_tiny.product_name, products_tiny.product_id, SUM(order_items.quantity * products_tiny.price) AS precio_total
FROM order_items
INNER JOIN products_tiny
ON order_items.product_id = products_tiny.product_id
GROUP BY 
    products_tiny.product_name,
    products_tiny.product_id
ORDER BY precio_total DESC;

-- Encuentra el día con mayores ingresos
DESCRIBE orders; -- Corroboramos que esten en formato date
SELECT orders.order_date, SUM(order_items.quantity * products_tiny.price) AS ingresos_dia
FROM orders
JOIN order_items
    ON orders.order_id = order_items.order_id
JOIN products_tiny
    ON order_items.product_id = products_tiny.product_id
GROUP BY orders.order_date
ORDER BY ingresos_dia DESC
LIMIT 1;


-- Encuentre el primer pedido (por fecha) para cada cliente
SELECT orders.customer_id, customers.first_name, customers.last_name, MIN(orders.order_date) AS primera_fecha
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
GROUP BY orders.customer_id, customers.first_name, customers.last_name
;

-- Encuentre los 3 principales clientes que han pedido la mayor cantidad de productos distintos
SELECT * FROM customers;
SELECT * FROM order_items;
SELECT * FROM orders;
SELECT * FROM products_tiny;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT oi.product_id) AS productos_distintos
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name
ORDER BY productos_distintos DESC
LIMIT 3;

-- ¿Qué producto se ha comprado menos en cantidad?
SELECT products_tiny.product_id, products_tiny.product_name, SUM(order_items.quantity) AS cantidad_productos
FROM products_tiny
INNER JOIN order_items
ON products_tiny.product_id = order_items.product_id
GROUP BY products_tiny.product_id, products_tiny.product_name
ORDER BY cantidad_productos ASC
LIMIT 1
;
-- Hay mas de 1?
SELECT products_tiny.product_id, products_tiny.product_name, SUM(order_items.quantity) AS cantidad_productos
FROM products_tiny
INNER JOIN order_items
ON products_tiny.product_id = order_items.product_id
GROUP BY products_tiny.product_id, products_tiny.product_name
HAVING SUM(order_items.quantity) = (
    SELECT SUM(order_items.quantity) 
    FROM order_items
    GROUP BY order_items.product_id
    ORDER BY SUM(order_items.quantity) ASC
    LIMIT 1);

-- ¿Cuál es la mediana del pedido total?
SELECT * FROM customers;--
SELECT * FROM order_items;-- cantidad
SELECT * FROM orders;
SELECT * FROM products_tiny;
-- en mysql no 
WITH totales AS (
    SELECT 
        order_items.order_id,
        SUM(order_items.quantity * products_tiny.price) AS total_pedido
    FROM order_items
    JOIN products_tiny
    ON order_items.product_id = products_tiny.product_id
    GROUP BY order_items.order_id
),
ordenados AS (
    SELECT 
        total_pedido,
        ROW_NUMBER() OVER (ORDER BY total_pedido) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM totales
)
SELECT AVG(total_pedido) AS mediana_total_pedido
FROM ordenados
WHERE rn IN (
    FLOOR((total_rows + 1) / 2),
    CEIL((total_rows + 1) / 2)
);




-- Para cada pedido, determine si fue "Caro" (en total más de 300), "Asequible" (en total más de 100) o "Barato"
SELECT 
    order_items.order_id,
    SUM(order_items.quantity * products_tiny.price) AS total_pedido,
    CASE
        WHEN SUM(order_items.quantity * products_tiny.price) > 300 THEN 'Caro'
        WHEN SUM(order_items.quantity * products_tiny.price) > 100 THEN 'Asequible'
        ELSE 'Barato'
    END AS categoria
FROM order_items
JOIN products_tiny
    ON order_items.product_id = products_tiny.product_id
GROUP BY order_items.order_id;

-- Encuentre clientes que hayan pedido el producto con el precio más alto

SELECT DISTINCT 
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    products_tiny.product_name,
    products_tiny.price
FROM customers
JOIN orders 
    ON customers.customer_id = orders.customer_id
JOIN order_items 
    ON orders.order_id = order_items.order_id
JOIN products_tiny 
    ON order_items.product_id = products_tiny.product_id
WHERE products_tiny.price = (
    SELECT MAX(price)
    FROM products_tiny
);
