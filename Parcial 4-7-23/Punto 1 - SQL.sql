use GD2015C1
go


select zona_detalle,
	count(*) 'Cantidad de depósitos por zona',

	(select count(*)
	from deposito
		join stock on stoc_deposito = depo_codigo
		join producto on prod_codigo = stoc_producto
		join composicion on comp_producto = prod_codigo
	where depo_zona = zona_codigo) 'Cantidad de compuestos en sus depósitos',

	(select top 1 item_producto
	from factura
		join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
	where item_producto in (
		select stoc_producto
		from deposito
			join stock on stoc_deposito = depo_codigo
		where depo_zona = zona_codigo and
			stoc_cantidad > 0 and
			year(fact_fecha) = 2012
	)
	group by item_producto
	order by sum(item_cantidad) desc) 'Producto más vendido en 2012 que tenga stock en alguno de sus depósitos',

	(select top 1 depo_encargado
	from deposito
	where depo_zona = zona_codigo
	order by (select sum(fact_total) from factura where fact_vendedor = depo_encargado) desc) 'Mejor encargado de la zona',

	(select top 1 depo_encargado
	from deposito
		join factura on fact_vendedor = depo_encargado
	where depo_zona = zona_codigo
	group by depo_encargado
	order by sum(fact_total) desc) 'Mejor encargado de la zona'
from zona
	join deposito on depo_zona = zona_codigo
group by zona_codigo, zona_detalle
having count(*) >= 3
order by 
	(select top 1 sum(fact_total)
	from deposito
		join factura on fact_vendedor = depo_encargado
	where depo_zona = zona_codigo
	group by depo_encargado
	order by sum(fact_total) desc)