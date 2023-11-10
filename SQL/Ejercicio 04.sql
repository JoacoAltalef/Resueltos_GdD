use GD2015C1

--------------
-- Punto 04 --
--------------
/*Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.*/
select prod_codigo, prod_detalle, count(comp_componente) 'Cantidad componentes' from producto
left join composicion on comp_producto = prod_codigo
where prod_codigo in (
	select stoc_producto from stock 
	group by stoc_producto 
	having avg(stoc_cantidad) > 100
)
group by prod_codigo, prod_detalle
order by 3 DESC

/* Esta solución está mal ya que itera 5564 veces demás (cantidad de filas de la tabla Stock).
Esto debido a que se utiliza join cuando en realidad la consulta es estática.*/
select prod_codigo, prod_detalle, count(distinct comp_componente) 'Cantidad componentes' from producto
left join composicion on comp_producto = prod_codigo
join stock on stoc_producto = prod_codigo
group by prod_codigo, prod_detalle
having avg(stoc_cantidad) > 100

select count(*) from stock -- 5564