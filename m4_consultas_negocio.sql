----M4 - Consultas de negocio----
--Base de datos: Ventas_Tech_DB--

--Consulta 1: Resumen ejecutivo mensual--
SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS Cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas 
GROUP BY MONTH(fecha_venta) 
ORDER BY mes;

--Consulta 2: Ranking de productos--
SELECT top 5
id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--Consulta 3: Clientes recurrentes--
SELECT id_cliente,
COUNT (*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT (*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

--Consulta 4: Meses por encima/por debajo del promedio--
WITH facturacion_mensual AS (
SELECT MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY MONTH (fecha_venta)
)
SELECT mes,
total_facturado,
CASE WHEN total_facturado > (
SELECT AVG(total_facturado)
FROM facturacion_mensual
)
THEN 'por encima'
ELSE 'por debajo'
END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;

--HALLAZGOS--
--Hallazgo 1: El producto 1 fue el que generó mayor facturación, con un total de $3600--
--Hallazgo 2: Marzo 2024 registró una facturación total de $6444 en 10 pedidos, con un ticked promedio de $644.40--
--Hallazgo 3: Los 5 clientes realizaron más de 1 pedido, por lo que todos son considerados clientes regulares--


