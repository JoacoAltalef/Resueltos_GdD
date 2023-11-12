/*
25.
Realizar una consulta SQL que para cada año muestre:
a) Año.
b) Código de la familia más vendida en ese año.
c) Cantidad de rubros que componen esa familia.
d) Cantidad de productos que componen directamente al producto más vendido de esa familia.
e) Cantidad de facturas en las cuales aparecen productos pertenecientes a esa familia.
f) Código del cliente que más productos compró de esa familia.
g) Porcentaje que representa la venta de esa familia respecto al total de venta del año.
 El resultado deberá ser ordenado por el total vendido por año y familia en forma
descendente.
*/

use GD2015C1
go

select year(fact_fecha) 'Año',
	
	(select top 1 prod_familia
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on prod_codigo = item_producto
	where year(f2.fact_fecha) = year(f1.fact_fecha)
	group by prod_familia
	order by sum(item_cantidad) desc) 'Familia más vendida',
	
	(select top 1 count(distinct prod_rubro)
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on prod_codigo = item_producto
	group by prod_familia
	order by sum(item_cantidad) desc) 'Cantidad de rubros de la familia más vendida',
	
	isnull((select top 1 count(*)
	from composicion
		join producto on prod_codigo = comp_producto
	where prod_familia = 
			(select top 1 prod_familia
			from factura f2
				join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
				join producto on prod_codigo = item_producto
			where year(f2.fact_fecha) = year(f1.fact_fecha)
			group by prod_familia
			order by sum(item_cantidad) desc)
	group by comp_producto), 0) 'Cantidad de componentes del más vendido de la familia más vendida',

	(select count(distinct item_sucursal+item_tipo+item_numero)
	from producto
		join item_factura on item_producto = prod_codigo
	where prod_familia = 
			(select top 1 prod_familia
			from factura f2
				join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
				join producto on prod_codigo = item_producto
			where year(f2.fact_fecha) = year(f1.fact_fecha)
			group by prod_familia
			order by sum(item_cantidad) desc)
	) 'Cantidad de facturas en las cuales aparecen productos pertenecientes a esa familia',

	(select top 1 fact_cliente
	from factura f2
		join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
		join producto on prod_codigo = item_producto
	group by fact_cliente
	order by count(distinct prod_codigo) desc
	) 'Cliente que más productos compró de esa familia',

	(select sum(item_cantidad * item_precio)
	from item_factura
		join producto on prod_codigo = item_producto
	where prod_familia = 
			(select top 1 prod_familia
			from factura f2
				join item_factura on item_sucursal+item_tipo+item_numero = f2.fact_sucursal+f2.fact_tipo+f2.fact_numero
				join producto on prod_codigo = item_producto
			where year(f2.fact_fecha) = year(f1.fact_fecha)
			group by prod_familia
			order by sum(item_cantidad) desc)
	) / sum(fact_total) * 100 '% de venta de esa familia respecto al total de venta del año' --Da >100% pues no aclara que la venta de esa familia tenga que ser en ese año, al igual que en los puntos anteriores.
from factura f1
group by year(fact_fecha)
order by 1, 2

/*
select prod_codigo, prod_familia
from producto
where prod_codigo in (select comp_producto from composicion)
*/