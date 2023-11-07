--------------
-- Punto 12 --
--------------
/*
Mostrar nombre de producto, cantidad de clientes distintos que lo compraron, importe
promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del
producto y stock actual del producto en todos los depósitos. Se deberán mostrar
aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán
ordenarse de mayor a menor por monto vendido del producto.*/

use GD2015C1

select prod_detalle,
	count(distinct fact_cliente) 'Clientes que lo compraron',
	avg(item_precio) 'Importe promedio pagado por el producto',
	count(distinct stoc_deposito) 'Depósitos con stock',
	(select sum(stoc_cantidad) from stock
	where stoc_producto = prod_codigo) 'Stock actual en todos los depósitos'
from producto
	join item_factura on item_producto = prod_codigo
	join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
	join stock on stoc_producto = prod_codigo
where stoc_cantidad > 0 and --stoc_cantidad > 0 porque tengo que traer los que tenga stock
	prod_codigo in (
		select item_producto from item_factura
		join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		where year(fact_fecha) = 2012
	)
group by prod_detalle, prod_codigo --Tiene que ir prod_codigo para vincular a la subconsulta
order by sum(item_precio * item_cantidad) desc



-- Esta es mejor porque hace menos iteraciones
select prod_detalle,
	count(distinct fact_cliente) 'Clientes que lo compraron',
	avg(item_precio) 'Importe promedio pagado por el producto',
	(select count(*) from stock
		where stoc_cantidad > 0 and stoc_producto = prod_codigo) 'Depósitos con stock',
	(select sum(stoc_cantidad) from stock
		where stoc_producto = prod_codigo) 'Stock actual en todos los depósitos'
from producto
	join item_factura on item_producto = prod_codigo
	join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
where prod_codigo in (
	select item_producto from item_factura
	join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
	where year(fact_fecha) = 2012
)
group by prod_detalle, prod_codigo --Tiene que ir prod_codigo para vincular a la subconsulta
order by sum(item_precio * item_cantidad) desc

