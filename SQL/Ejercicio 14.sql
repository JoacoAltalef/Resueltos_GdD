--------------
-- Punto 14 --
--------------
/*
Escriba una consulta que retorne una estadística de ventas por cliente.
Los campos que debe retornar son:
- Código del cliente.
- Cantidad de veces que compró en el último año.
- Promedio por compra en el último año.
- Cantidad de productos diferentes que compró en el último año.
- Monto de la mayor compra que realizo en el último año.
- Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
- No se deberán visualizar NULLs en ninguna columna.
*/
use GD2015C1

select f1.fact_cliente,
	count(*) 'Veces que compró en el último año',
	avg(fact_total) 'Promedio por compra en el último año',
	(select count(distinct item_producto) from factura f2
	join item_factura on item_tipo+item_sucursal+item_numero = f2.fact_tipo+f2.fact_sucursal+f2.fact_numero
	where f1.fact_cliente = f2.fact_cliente) 'Productos diferentes que compró el último año',
	max(fact_total) 'Monto de la mayor compra del último año'
from factura f1
where year(fact_fecha) = (select max(year(fact_fecha)) from factura)
group by fact_cliente
order by 2, fact_cliente

-- Este es peor, ya que hace más iteraciones, pues no solo hace un subselect en el select principal, sino 
-- que también hace un join en el from principal. De todas formas, no es tan importante.
select f1.fact_cliente,
	count(distinct fact_tipo+fact_sucursal+fact_numero) 'Veces que compró en el último año',
	(select avg(f2.fact_total) from factura f2
	where year(f2.fact_fecha) = year(f1.fact_fecha) and
		f2.fact_cliente = f1.fact_cliente) 'Promedio por compra en el último año',
	count(distinct item_producto) 'Productos diferentes que compró el último año',
	max(fact_total) 'Monto de la mayor compra del último año'
from factura f1
	join item_factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
where year(fact_fecha) = (select max(year(fact_fecha)) from factura)
group by fact_cliente, year(fact_fecha)
order by 2, fact_cliente



/* Lo del año también se podría hacer resolver así:
where year(f1.fact_fecha) = ( -- Se refiere al último año facturado de la empresa
		select top 1 year(f2.fact_fecha) from factura f2
		order by 1 desc
	)
*/