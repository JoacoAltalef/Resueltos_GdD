--------------
-- Punto 16 --
--------------
/*
Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas compras
son inferiores a 1/3 del monto de ventas del producto que más se vendió en el 2012.
Además mostrar:
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 para ese cliente (en caso de 
existir más de 1, mostrar solamente el de menor código).
*/
use GD2015C1

-- Duda: puede ser que un cliente no tenga factura, por lo que no me traería todos los clientes. ¿Es válido esto? ¿Le tengo que dar importancia?
-- Duda: ¿puede ser que falte el where year(fact_fecha) = 2012? Si se usa ese where, ahí sí se perderían clientes, ¿no?
select fact_cliente,
	sum(item_cantidad) 'Unidades totales vendidas en 2012',
	(select top 1 item_producto 
	from factura f2
		join item_factura on f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = item_tipo+item_sucursal+item_numero
	where year(f2.fact_fecha) = 2012 and f2.fact_cliente = f1.fact_cliente 
	group by item_producto 
	order by sum(item_precio * item_cantidad) desc, item_producto) 'Producto más vendido en 2012'
from factura f1
	join item_factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
group by fact_cliente
having sum(item_cantidad * item_precio) < 1/3 * (
	select top 1 sum(item_cantidad * item_precio)
	from factura
		join item_factura on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
	where year(fact_fecha) = 2012
	group by item_producto
	order by 1 desc
)

/*
Esta forma para el having al parecer es mejor, pero por muy poco, es tan sutil la diferencia que no baja ni un punto en el parcial.
Supuestamente es pq el otro hace un group by, entonces vuelve a iterar, pero al ponerlo en práctica me da que el de arriba es más eficiente.
Yo me imagino que es porque hay un subselect, y esa iteración extra es peor, aunque, según lo que me explicaron, es estática y no debería
afectar mucho. Es decir, debería iterar una sola vez. Además, dijeron varias veces que el subselect tiene que ser el útlimo recurso, pero bueno.
*/
/*
having sum(item_cantidad * item_precio) < 1/3 * (
		select sum(item_cantidad * item_precio)
		from factura
			join item_factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
		where year(fact_fecha) = 2012 and
			item_producto = (
				select top 1 item_producto
				from item_factura
				where year(fact_fecha) = 2012
				group by item_producto
				order by sum(item_cantidad * item_precio) desc
			)
	)
*/
