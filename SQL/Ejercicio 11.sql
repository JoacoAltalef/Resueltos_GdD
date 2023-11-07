use GD2015C1

--------------
-- Punto 11 --
--------------
/*Realizar una consulta que retorne el detalle de la familia, la cantidad de cada
producto vendido y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga.
 Solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para
el año 2012. (con "una venta" se refiere a la suma de todas las ventas del 2012 de algún producto perteneciente a esa familia)*/select fami_detalle, count(distinct item_producto) 'Cantidad de productos diferentes vendidos', sum(item_precio * item_cantidad) 'Monto de ventas sin impuestos' from familiajoin producto on prod_familia = fami_id -- No es left porque solo quiero los productos vendidosjoin item_factura on prod_codigo = item_productowhere fami_id in (	select prod_familia from producto	join item_factura on prod_codigo = item_producto	join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero	where year(fact_fecha) = 2012	group by prod_familia	having sum(item_cantidad * item_precio) > 20000)group by fami_detalleorder by 2 desc