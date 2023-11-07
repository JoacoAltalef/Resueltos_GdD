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
por cantidad de productos diferentes vendidos del rubro.
		datediff(day, fact_fecha, ( -- Esto va si �ltimo a�o = �ltimo a�o en el que hizo una compra. Sino ser�a getdate().
			select top 1 fact_fecha from factura f2
			where f1.fact_cliente = f2.fact_cliente
			order by 1 desc
		)) < 30) 'Cliente que m�s compr� en los �ltimos 30 d�as'