--------------
-- Punto 17 --
--------------
/*
Escriba una consulta que retorne una estad�stica de ventas por a�o y mes para cada
producto.
La consulta debe retornar:
- PERIODO: a�o y mes de la estad�stica con el formato YYYYMM.
- PROD: c�digo de producto.
- DETALLE: cetalle del producto.
- CANTIDAD_VENDIDA: cantidad vendida del producto en el periodo.
- VENTAS_A�O_ANT: cantidad vendida del producto en el mismo mes del periodo
pero del a�o anterior.
- CANT_FACTURAS: cantidad de facturas en las que se vendi� el producto en el
per�odo.
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y c�digo de producto.
*/

use GD2015C1

--convert(char(4), year(fact_fecha))+convert(char(2), month(fact_fecha))
select year(fact_fecha) 'A�o',
	month(fact_fecha) 'Mes',
	prod_codigo,
	prod_detalle,
	sum(item_cantidad) 'Cantidad vendida',
	(select isnull(sum(item_cantidad), 0)
	from factura f2
		join item_factura i2 on i2.item_tipo+i2.item_sucursal+i2.item_numero = f2.fact_tipo+f2.fact_sucursal+f2.fact_numero
	where i2.item_producto = prod_codigo and
		year(f2.fact_fecha) = year(f1.fact_fecha) - 1 and
		month(f2.fact_fecha) = month(f1.fact_fecha)
	) 'Ventas a�o anterior',
	count(distinct fact_tipo+fact_sucursal+fact_numero) 'Facturas en las que se vendi� el producto'
from producto
	join item_factura on item_producto = prod_codigo -- No se muestran los art�uclos que no fueron vendidos
	join factura f1 on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
group by year(fact_fecha), month(fact_fecha), prod_codigo, prod_detalle
order by 1 desc, 2 desc, 3 --, 6 desc, 7 desc

