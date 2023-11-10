use GD2015C1

--------------
-- Punto 07 --
--------------
/*Generar una consulta que muestre para cada artículo código, detalle, mayor precio
menor precio y % de la diferencia de precios respecto del menor.
Ej.: menor precio = 10 y mayor precio = 12 => mostrar 20 %.
Mostrar solo aquellos artículos que posean stock.*/select prod_codigo, prod_detalle, max(item_precio) 'Mayor precio', min(item_precio) 'Menor precio', (max(item_precio) - min(item_precio)) / min(item_precio) * 100 '% de la diferencia'	from producto	join item_factura on item_producto = prod_codigowhere prod_codigo in (	select stoc_producto from stock)group by prod_codigo, prod_detalleorder by 5 desc