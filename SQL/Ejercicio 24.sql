/*
24.
 Escriba una consulta que, considerando solamente las facturas correspondientes a los
dos vendedores con mayores comisiones, retorne los productos con composición
facturados en al menos cinco facturas.
 La consulta debe retornar las siguientes columnas:
 Código de Producto
 Nombre del Producto
 Unidades facturadas
 El resultado deberá ser ordenado por las unidades facturadas descendente
*/

use GD2015C1
go

select prod_codigo,
	prod_detalle,
	sum(item_cantidad)
from producto
	join item_factura on item_producto = prod_codigo
	join factura on fact_sucursal+fact_tipo+fact_numero = item_sucursal+item_tipo+item_numero
where prod_codigo in (select comp_producto from composicion) and
	 fact_vendedor in (select top 2 empl_codigo from empleado order by empl_comision desc)
group by prod_codigo, prod_detalle
having count(distinct item_sucursal+item_tipo+item_numero) >= 5
order by sum(item_cantidad) desc


--select comp_producto from composicion group by comp_producto
