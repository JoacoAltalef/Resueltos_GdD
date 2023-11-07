--------------
-- Punto 18 --
--------------
/*
Escriba una consulta que retorne una estad�stica de ventas para todos los rubros.
La consulta debe retornar:
- DETALLE_RUBRO: detalle del rubro.
- VENTAS: suma de las ventas en pesos de productos vendidos de dicho rubro.
- PROD1: c�digo del producto m�s vendido de dicho rubro.
- PROD2: c�digo del segundo producto m�s vendido de dicho rubro.
- CLIENTE: c�digo del cliente que compr� m�s productos del rubro en los �ltimos 30
d�as.
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.*/use GD2015C1select rubr_detalle 'Rubro',	sum(item_cantidad * item_precio) 'Suma de todas las ventas',	(select top 1 prod_codigo from producto	join item_factura on item_producto = prod_codigo	where prod_rubro = rubr_id	group by prod_codigo	order by sum(item_cantidad) desc) 'Producto m�s vendido',	(select top 1 prod_codigo from producto	join item_factura on item_producto = prod_codigo	where prod_rubro = rubr_id and		prod_codigo != (select top 1 prod_codigo from producto			join item_factura on item_producto = prod_codigo			where prod_rubro = rubr_id			group by prod_codigo			order by sum(item_cantidad) desc		)	group by prod_codigo	order by sum(item_cantidad) desc) 'Segundo producto m�s vendido',	(select top 1 fact_cliente from factura f1	join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero	join producto on prod_codigo = item_producto	where prod_rubro = rubr_id and
		datediff(day, fact_fecha, ( -- Esto va si �ltimo a�o = �ltimo a�o en el que hizo una compra. Sino ser�a getdate().
			select top 1 fact_fecha from factura f2
			where f1.fact_cliente = f2.fact_cliente
			order by 1 desc
		)) < 30) 'Cliente que m�s compr� en los �ltimos 30 d�as'from rubro	left join producto on prod_rubro = rubr_id	left join item_factura on item_producto = prod_codigogroup by rubr_detalle, rubr_idorder by count(distinct item_producto)