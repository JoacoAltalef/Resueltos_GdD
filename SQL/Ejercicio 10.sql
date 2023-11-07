use GD2015C1

--------------
-- Punto 10 --
--------------
/*
Mostrar los 10 productos m�s vendidos en la historia y tambi�n los 10 productos menos
vendidos en la historia. Adem�s mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/select prod_detalle, (	select top 1 fact_cliente from factura	join item_factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero	where item_producto = prod_codigo	group by fact_cliente	order by sum(item_cantidad) desc) 'Cliente que mayor compra realiz�'from productowhere prod_codigo in (		select top 10 item_producto from item_factura		group by item_producto		order by sum(item_cantidad) desc	)	or prod_codigo in (		select top 10 item_producto from item_factura		group by item_producto		order by sum(item_cantidad) asc	)