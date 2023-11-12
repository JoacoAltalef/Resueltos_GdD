use GD2015C1
go

select top 5 rtrim(prod_codigo) + ' - ' + rtrim(prod_detalle) 'Codigo y detalle del producto',
	
	(select top 1 empl_nombre
	from empleado
		join factura on fact_vendedor = empl_codigo
		join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
	where item_producto = prod_codigo
	group by empl_nombre
	order by sum(item_cantidad) --Capaz se refiere a item_factura distintos cuando dice "veces que vendió"
	) 'Vendedor que más vendió el producto',

	(select count(*)
	from stock
	where stoc_producto = prod_codigo and
		stoc_cantidad > 0) 'Cantidad de depósitos donde hay stock del producto',

	(select top 1 fact_cliente
	from factura
		join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
	where item_producto = prod_codigo
	group by fact_cliente
	order by sum(item_cantidad) desc) 'Cliente que más veces compró ese producto',

	(select sum(fact_total)
	from factura
	where fact_cliente = 
			(select top 1 fact_cliente
			from factura
				join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
			where item_producto = prod_codigo
			group by fact_cliente
			order by sum(item_cantidad) desc)
	) 'Monto total facturado al cliente que más compró ese producto'

from producto
	join item_factura on item_producto = prod_codigo
group by prod_codigo, prod_detalle
order by sum(item_cantidad) desc
--order by (select sum(item_cantidad) from item_factura where item_producto = prod_codigo) desc --Es más lento

/*
union

select top 10 rtrim(prod_codigo) + '-' + rtrim(prod_detalle),
from producto
order by  asc
*/
