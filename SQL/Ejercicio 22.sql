/*22.
 Escriba una consulta sql que retorne una estadística de venta para todos los rubros por
trimestre contabilizando todos los años. Se mostrarán como máximo 4 filas por rubro (1
por cada trimestre).
 Se deben mostrar 4 columnas:
 Detalle del rubro.
 Numero de trimestre del año (1 a 4).
 Cantidad de facturas emitidas en el trimestre en las que se haya vendido al menos un producto del rubro.
 Cantidad de productos diferentes del rubro vendidos en el trimestre.
 El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
rubro primero el trimestre en el que mas facturas se emitieron.
 No se deberán mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas
no superen las 100.
 En ningun momento se tendrán en cuenta los productos compuestos para esta
estadística.*/use GD2015C1select rubr_detalle,	datepart(quarter, fact_fecha) 'Trimestre',	count(distinct fact_numero+fact_sucursal+fact_tipo) 'Facturas en las que se vendió al menos un producto del rubro',	count(distinct prod_codigo) 'Productos diferentes vendidos'from rubro	left join producto on prod_rubro = rubr_id --Los left son al pedo, pues el having ya te los filtra (te mata/cancela el left), por lo que no habría que ponerlos	left join item_factura on item_producto = prod_codigo	join factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipogroup by rubr_detalle, datepart(quarter, fact_fecha)having count(distinct fact_numero+fact_sucursal+fact_tipo) > 100order by rubr_detalle, 3 desc--Lo del Trimestre también podría haberse hecho así:--floor(month(fact_fecha) / 4 + 1) 'Trimestre',
