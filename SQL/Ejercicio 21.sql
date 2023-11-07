--------------
-- Punto 21 --
--------------
/*.
 Escriba una consulta sql que retorne para todos los años en los cuales se haya hecho al
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta.
 Se considera que una factura es incorrecta cuando la diferencia entre el total de la factura
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
los costos de cada uno de los items de dicha factura.
 Las columnas que se deben mostrar son:
 Año
 Clientes a los que se les facturó mal en ese año
 Facturas mal realizadas en ese año*/use GD2015C1select year(fact_fecha) 'Anio', count(distinct fact_cliente) 'Clientes a los que se les facturó mal', count(distinct fact_numero+fact_sucursal+fact_tipo) 'Facturas incorrectas'from facturawhere abs(fact_total - fact_total_impuestos - (select sum(item_precio) from item_factura where fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo)) > 1group by year(fact_fecha)