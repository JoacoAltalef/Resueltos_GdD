/*
23. Realizar una consulta SQL que para cada año muestre :
 Año
 Producto con composición más vendido para ese año.
 Cantidad de productos que componen directamente al producto más vendido. --¿¿¿Se sigue refiriendo al compuesto más vendido???
 Cantidad de facturas en las cuales aparece ese producto.
 Código de cliente que más compró ese producto.
 Porcentaje que representa la venta de ese producto respecto al total de venta del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.
*/

use GD2015C1
go

--Tarda más, pero hay más lógica ahorrada. No sé cuál de las dos es mejor. Supongo que la que tarda menos.
select year(fact_fecha) 'Año',
	item_producto,

	(select count(*) from composicion where comp_producto = i1.item_producto) 'Cantidad de componentes del compuesto más vendido',

	count(distinct fact_sucursal+fact_tipo+fact_numero) 'Cantidad de facturas en las que aparece el compuesto más vendido',

	(select top 1 fact_cliente
	from factura f3
		join item_factura i2 on i2.item_sucursal+i2.item_tipo+i2.item_numero = f3.fact_sucursal+f3.fact_tipo+f3.fact_numero
	where i2.item_producto = i1.item_producto
	group by fact_cliente
	order by sum(item_cantidad)
	) 'Cliente que más compró el compuesto más vendido',

	sum(item_cantidad * item_precio) / 	(select sum(fact_total) from factura f2 where year(f2.fact_fecha) = year(f1.fact_fecha)) * 100 '% de venta sobre venta total del año'

from factura f1
	join item_factura i1 on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
where item_producto =
		(select top 1 prod_codigo
		from factura f2
			join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
			join producto on item_producto = prod_codigo
		where year(f2.fact_fecha) = year(f1.fact_fecha) and
			prod_codigo in (select comp_producto from composicion)
		group by prod_detalle, prod_codigo
		order by sum(item_cantidad) desc) --Compuesto más vendido
group by year(fact_fecha), item_producto
order by sum(fact_total) desc



/*

select year(fact_fecha) 'Año',

	(select top 1 prod_codigo
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on item_producto = prod_codigo
	where year(f2.fact_fecha) = year(f1.fact_fecha) and
		prod_codigo in (select comp_producto from composicion)
	group by prod_detalle, prod_codigo
	order by sum(item_cantidad) desc) 'Compuesto más vendido',

	(select top 1 (select count(*) from composicion where comp_producto = prod_codigo) --No necesariamente el más vendido tiene que ser un compuesto(?
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on item_producto = prod_codigo
	where year(f2.fact_fecha) = year(f1.fact_fecha) and
		prod_codigo in (select comp_producto from composicion)
	group by prod_detalle, prod_codigo
	order by sum(item_cantidad) desc) 'Cantidad de componentes del compuesto más vendido',

	(select top 1 count(distinct f2.fact_sucursal+f2.fact_tipo+f2.fact_numero)
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on item_producto = prod_codigo
	where year(f2.fact_fecha) = year(f1.fact_fecha) and
		prod_codigo in (select comp_producto from composicion)
	group by prod_detalle, prod_codigo
	order by sum(item_cantidad) desc) 'Cantidad de facturas en las que aparece el compuesto más vendido',

	(select top 1 fact_cliente
	from factura f3
		join item_factura on item_sucursal+item_tipo+item_numero = f3.fact_sucursal+f3.fact_tipo+f3.fact_numero
	where item_producto = 
			(select top 1 prod_codigo
			from factura f2
				join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
				join producto on item_producto = prod_codigo
			where year(f2.fact_fecha) = year(f1.fact_fecha) and
				prod_codigo in (select comp_producto from composicion)
			group by prod_detalle, prod_codigo
			order by sum(item_cantidad) desc)
	group by fact_cliente
	order by sum(item_cantidad)
	) 'Cliente que más compró el compuesto más vendido',

	(select top 1 sum(item_cantidad * item_precio)
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on item_producto = prod_codigo
	where year(f2.fact_fecha) = year(f1.fact_fecha) and
		prod_codigo in (select comp_producto from composicion)
	group by prod_detalle, prod_codigo
	order by sum(item_cantidad) desc) / sum(fact_total) * 100 '% de venta sobre venta total del año'


from factura f1
group by year(fact_fecha)
order by sum(fact_total) desc


*/