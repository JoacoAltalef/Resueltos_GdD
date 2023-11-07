use GD2015C1

--------------
-- Punto 06 --
--------------
/*Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese
rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que
tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.*/select rubr_id, rubr_detalle, count(distinct prod_codigo) 'Cantidad de artículos', sum(stoc_cantidad) 'Stock total' from rubroleft join producto on rubr_id = prod_rubrojoin stock on prod_codigo = stoc_producto --No hace falta que sea left ya que en el where los eliminowhere stoc_producto in (	select stoc_producto from stock	group by stoc_producto	having sum(stoc_cantidad) > (		select stoc_cantidad from stock		where stoc_producto = '00000000'and stoc_deposito = '00'	))group by rubr_id, rubr_detalleorder by 1-- Está mal porque agrupa por rubro, cuando en realidad se busca agrupar por producto.select rubr_id, rubr_detalle, count(distinct prod_codigo) 'Cantidad de artículos', sum(stoc_cantidad) 'Stock total' from rubroleft join producto on rubr_id = prod_rubroleft join stock on prod_codigo = stoc_productogroup by rubr_id, rubr_detallehaving sum(stoc_cantidad) > (	select stoc_cantidad from stock	where stoc_producto = '00000000'and stoc_deposito = '00')order by 1