use GD2015C1

--------------
-- Punto 05 --
--------------
/*Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.*/
select prod_codigo, prod_detalle, sum(item_cantidad) 'Cantidad de egresos de stock' from producto
	join item_factura on item_producto = prod_codigo
	join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
where year(fact_fecha) = 2012
group by prod_codigo, prod_detalle
having sum(item_cantidad) > (
	select sum(item_cantidad) from item_factura
		join factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
	where item_producto = prod_codigo and year(fact_fecha) = 2011 --Tiene que ser subconsulta ya que ambas condiciones son excluyentes
	--group by item_producto --Está al pedo
)