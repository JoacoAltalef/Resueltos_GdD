use GD2015C1

--------------
-- Punto 03 --
--------------
/*Realizar una consulta que muestre código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por
nombre del artículo de menor a mayor.*/
select prod_codigo, prod_detalle, sum(stoc_cantidad) 'Stock total' from producto
join stock on stoc_producto = prod_codigo
group by prod_codigo, prod_detalle
order by prod_detalle