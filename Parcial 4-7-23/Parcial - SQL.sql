
-- Practicando PARCIAL JUAMPI

-- fran:
use GD2015C1


select zona_detalle "Detalle Zona", count(distinct depo_codigo) "Cantidad de Depositos x Zona",
	
	(select count(distinct comp_producto) from Composicion 
		join Producto on comp_producto = prod_codigo 
		join STOCK on prod_codigo = stoc_producto and stoc_deposito in 
		(select depo_codigo from DEPOSITO where depo_zona = zona_codigo)) 
		"Cantidad de Productos distintos compuestos",
	
	(select top 1 item_producto from Item_Factura join factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
		where year(fact_fecha) = 2012 and item_producto in (select stoc_producto from stock join DEPOSITO on stoc_deposito = depo_codigo
		where depo_zona = zona_codigo and stoc_cantidad > 0) 
		group by item_producto order by sum(item_cantidad*item_precio) desc) 
		"Producto mas vendido en 2012",

	(select top 1 depo_encargado from DEPOSITO join Empleado on empl_codigo = depo_encargado
		join Factura on fact_vendedor = empl_codigo where depo_zona = zona_codigo
		group by depo_encargado order by sum(fact_total) desc) "Mejor encargado de la zona"

from zona join DEPOSITO on depo_zona = zona_codigo
group by zona_codigo, zona_detalle
having count(distinct depo_codigo) >= 3
order by (select top 1 sum(fact_total) from DEPOSITO join Empleado on empl_codigo = depo_encargado
		join Factura on fact_vendedor = empl_codigo where depo_zona = zona_codigo
		group by depo_encargado order by sum(fact_total) desc)

-- juampi:
select zona_detalle, count(depo_codigo) as cantDepositos,

(select count(distinct stoc_producto) from STOCK 
join DEPOSITO a on (a.depo_codigo = stoc_deposito) 
where a.depo_zona = zona_codigo and stoc_producto in 
(select comp_producto from Composicion)) as cantProdCompuestos,

(select top 1 item_producto from Item_Factura 
where item_producto in (select stoc_producto from STOCK where stoc_cantidad >0 and stoc_deposito in (select depo_codigo from DEPOSITO where depo_zona = zona_codigo)) ),

(select top 1 empl_codigo from Empleado join Factura on (fact_vendedor = empl_codigo) join Departamento on (empl_departamento = depa_codigo and depa_zona = zona_codigo)  group by empl_codigo order by sum(fact_total) desc  )

from zona
join DEPOSITO on (depo_zona = zona_codigo)
group by zona_detalle, zona_codigo
having count(zona_codigo) >= 3
