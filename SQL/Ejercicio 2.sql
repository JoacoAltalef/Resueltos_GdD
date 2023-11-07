use GD2015C1

--------------
-- Punto 02 --
--------------
/* Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
cantidad vendida. */
select prod_codigo, prod_detalle from producto
join item_factura on item_producto = prod_codigo
--join factura on fact_tipo = item_tipo and fact_sucursal = item_sucursal and fact_numero = item_numero
join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
where year(fact_fecha) = 2012
group by prod_codigo, prod_detalle
order by sum(item_cantidad)