--------------
-- Punto 13 --
--------------
/*
Realizar una consulta que retorne para cada producto que posea composición nombre
del producto, precio del producto, precio de la sumatoria de los precios por la cantidad
de los productos que lo componen. Solo se deberán mostrar los productos que estén
compuestos por más de 2 productos y deben ser ordenados de mayor a menor por
cantidad de productos que lo componen.
*/

use GD2015C1

select p_compuesto.prod_detalle,
	p_compuesto.prod_precio,
	sum(p_componente.prod_precio * comp_cantidad) 'Sumatoria de precios por la cantidad de los productos que lo componen'
from producto p_compuesto
	join composicion on comp_producto = prod_codigo
	join producto p_componente on p_componente.prod_codigo = comp_componente
group by p_compuesto.prod_detalle, p_compuesto.prod_precio
having count(*) > 2
order by count(*) desc
-- Puede ser count(*), pues el segundo join no aumenta la atomicidad, ya que es de muchos a uno.
