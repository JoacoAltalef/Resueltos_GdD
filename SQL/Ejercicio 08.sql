use GD2015C1

--------------
-- Punto 08 --
--------------
/*Mostrar para el o los art�culos que tengan stock en todos los dep�sitos, nombre del
art�culo, stock del dep�sito que m�s stock tiene.*/
select prod_detalle, max(stoc_cantidad) 'Stock del dep�sito que m�s tiene' from producto
join stock on prod_codigo = stoc_producto
where stoc_cantidad > 0 -- Pues puede ser que tenga stock negativo para un dep�sito, por lo que no deber�a aceptarlo.
group by prod_detalle
having count(*) = (select count(*) from deposito)