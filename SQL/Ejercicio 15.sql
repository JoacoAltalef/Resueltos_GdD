--------------
-- Punto 15 --
--------------
/*
Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
Ejemplo de lo que retornaría la consulta:
PROD1 | DETALLE1          | PROD2 | DETALLE2              | VECES
1731  | MARLBORO KS	      | 1718  | PHILIPS MORRIS KS     | 507
1718  | PHILIPS MORRIS KS | 1705  | PHILIPS MORRIS BOX 10 | 562
Este es un ejemplo, pero no es el resultado posta que debería tirar la query.
*/
use GD2015C1

select p1.prod_codigo,
	p1.prod_detalle,
	p2.prod_codigo,
	p2.prod_detalle,
	count(*) 'Veces que se vendieron juntos' -- El count no cuenta todos los items de la factura, pues al matchear
	-- con la factura y con el producto, eso forma la PK, por lo que solo me trae una única fila.
from item_factura i1
	join producto p1 on i1.item_producto = p1.prod_codigo
	join item_factura i2 on i2.item_tipo+i2.item_sucursal+i2.item_numero = i1.item_tipo+i1.item_sucursal+i1.item_numero
	join producto p2 on i2.item_producto = p2.prod_codigo
where p1.prod_codigo < p2.prod_codigo --No se pone != pues en ese caso sería conmutativo
group by p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
having count(*) > 500
order by 5


-- Esta es otra forma, pidiendo dos tablas en el from en vez de hacer otro join más. Son equivalentes.
select p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle, count(*) 'Veces que se vendieron juntos'
from item_factura i1
		join producto p1 on i1.item_producto = p1.prod_codigo,
	item_factura i2
		join producto p2 on i2.item_producto = p2.prod_codigo
where i2.item_tipo+i2.item_sucursal+i2.item_numero = i1.item_tipo+i1.item_sucursal+i1.item_numero and
	p1.prod_codigo < p2.prod_codigo
group by p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
having count(*) > 500
order by 5




