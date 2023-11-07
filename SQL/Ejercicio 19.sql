--------------
-- Punto 19 --
--------------
/*
En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
 Codigo de producto.
 Detalle del producto.
 Codigo de la familia del producto.
 Detalle de la familia actual del producto.
 Codigo de la familia sugerido para el producto.
 Detalla de la familia sugerido para el producto.
 La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
 En caso que 2 o más familias pudieran ser sugeridas se deberá seleccionar la de menor
código. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida.
 Los resultados deben ser ordenados por detalle de producto de manera ascendente.*/use GD2015C1select prod_codigo,	prod_detalle,	fami_id,	fami_detalle,	(select top 1 p2.prod_familia from producto p2	where left(p1.prod_detalle, 5) = left(p2.prod_detalle, 5)	group by p2.prod_familia	order by count(*) desc) 'Codigo de la familia sugerido',	(select top 1 fami_detalle from producto p2	join familia on fami_id = p2.prod_familia	where left(p1.prod_detalle, 5) = left(p2.prod_detalle, 5)	group by fami_detalle	order by count(*) desc) 'Detalle de la familia sugerido',	(select fami_detalle from familia	where fami_id = (select top 1 p2.prod_familia from producto p2		where left(p1.prod_detalle, 5) = left(p2.prod_detalle, 5)		group by p2.prod_familia		order by count(*) desc)	) 'Detalle de la familia sugerido' -- Es una forma distinta a la anteriorfrom producto p1	join familia on fami_id = prod_familiaorder by 2	 -- Esta está bien si se refiere a que simplemente el detalle del producto coincida en los primeros 5 caracteres con el de la familia.select prod_codigo,	prod_detalle,	fami_id,	fami_detalle,	(select top 1 fami_id from familia	where left(fami_detalle, 5) = left(prod_detalle, 5)	group by fami_id	order by count(*) desc) 'Codigo de la familia sugerido', -- Esto es lo que cambia	(select top 1 fami_detalle from familia	where left(fami_detalle, 5) = left(prod_detalle, 5)	group by fami_detalle	order by count(*) desc) 'Detalle de la familia sugerido' -- Esto es lo que cambiafrom producto	join familia on fami_id = prod_familiaorder by 2