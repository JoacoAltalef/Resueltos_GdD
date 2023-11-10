use GD2015C1

--------------
-- Punto 08 --
--------------
/*Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
artículo, stock del depósito que más stock tiene.*/
select prod_detalle, max(stoc_cantidad) 'Stock del depósito que más tiene' from producto
join stock on prod_codigo = stoc_producto
where stoc_cantidad > 0 -- Pues puede ser que tenga stock negativo para un depósito, por lo que no debería aceptarlo.
group by prod_detalle
having count(*) = (select count(*) from deposito)