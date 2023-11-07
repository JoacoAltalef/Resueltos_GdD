--------------
-- Punto 16 --
--------------
/*
Con el fin de lanzar una nueva campa�a comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas compras
son inferiores a 1/3 del monto de ventas del producto que m�s se vendi� en el 2012.
Adem�s mostrar:
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. C�digo de producto que mayor venta tuvo en el 2012 para ese cliente (en caso de 
existir m�s de 1, mostrar solamente el de menor c�digo).
*/
use GD2015C1

-- Duda: puede ser que un cliente no tenga factura, por lo que no me traer�a todos los clientes. �Es v�lido esto? �Le tengo que dar importancia?
-- Duda: �puede ser que falte el where year(fact_fecha) = 2012? Si se usa ese where, ah� s� se perder�an clientes, �no?
select fact_cliente,
	sum(item_cantidad) 'Unidades totales vendidas en 2012',
	(select top 1 item_producto 
	from factura f2
		join item_factura on f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = item_tipo+item_sucursal+item_numero
	where year(f2.fact_fecha) = 2012 and f2.fact_cliente = f1.fact_cliente 
	group by item_producto 
	order by sum(item_precio * item_cantidad) desc, item_producto) 'Producto m�s vendido en 2012'
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
Supuestamente es pq el otro hace un group by, entonces vuelve a iterar, pero al ponerlo en pr�ctica me da que el de arriba es m�s eficiente.
Yo me imagino que es porque hay un subselect, y esa iteraci�n extra es peor, aunque, seg�n lo que me explicaron, es est�tica y no deber�a
afectar mucho. Es decir, deber�a iterar una sola vez. Adem�s, dijeron varias veces que el subselect tiene que ser el �tlimo recurso, pero bueno.
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
