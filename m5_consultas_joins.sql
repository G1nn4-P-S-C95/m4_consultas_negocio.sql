--M5 CONSULTAS CON JOIN--
--Base de datos: Ventas_Tech_DB--

--Consulta 1: Vista base del proyecto--
USE Ventas_Tech_DB;
GO

SELECT
v.fecha_venta AS fecha,
c.id_cliente AS identification_cliente,
c.nombre AS nombre_cliente,
c.ciudad AS ciudad_cliente,
p.nombre_producto AS producto,
cat.nombre_categoria AS categoria,
v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;

--Consulta 2: Clientes sin ventas--
SELECT
c.nombre,
c.email,
c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

--Consulta 3: Productos sin ventas--
SELECT 
p.nombre_producto,
cat.nombre_categoria AS categoria,
p.precio
FROM productos AS p
INNER JOIN categorias AS cat
ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

--Consulta 4: Consolidado por canal--
SELECT
canal,
SUM(total) AS total_ventas
FROM
(
SELECT
v.fecha_venta AS fecha,
v.cantidad * v.precio_unitario AS total,
'Online' AS canal
FROM ventas AS v
WHERE v.fecha_venta <= '20240320'

UNION ALL

SELECT
v.fecha_venta AS fecha,
v.cantidad * v.precio_unitario AS total,
'Presencial'  AS canal
FROM ventas AS v
WHERE v.fecha_venta > '20240310'
) AS ventas_por_canal
GROUP BY canal
ORDER BY canal;
