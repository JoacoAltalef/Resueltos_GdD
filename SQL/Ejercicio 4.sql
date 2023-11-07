use GD2015C1

--------------
-- Punto 04 --
--------------
/*Realizar una consulta que muestre para todos los art�culos c�digo, detalle y cantidad de
art�culos que lo componen. Mostrar solo aquellos art�culos para los cuales el stock
promedio por dep�sito sea mayor a 100.*/
select prod_codigo, prod_detalle, count(comp_componente) 'Cantidad componentes' from producto
left join composicion on comp_producto = prod_codigo
where prod_codigo in (
	select stoc_producto from stock 
	group by stoc_producto 
	having avg(stoc_cantidad) > 100
)
group by prod_codigo, prod_detalle
order by 3 DESC

/* Esta soluci�n est� mal ya que itera 5564 veces dem�s (cantidad de filas de la tabla Stock).
Esto debido a que se utiliza join cuando en realidad la consulta es est�tica.*/
select prod_codigo, prod_detalle, count(distinct comp_componente) 'Cantidad componentes' from producto
left join composicion on comp_producto = prod_codigo
join stock on stoc_producto = prod_codigo
group by prod_codigo, prod_detalle
having avg(stoc_cantidad) > 100

select count(*) from stock -- 5564