create trigger trigger_articulo on producto
instead of delete -- No quiero que lo borre primero, antes quiero ejecutar el trigger
as
begin
	if (select * from deleted
		join stock on prod_codigo = stoc_producto
		where stoc_cantidad > 0) > 0
		print 'Error: no se puede borrar productos que tienen stock'
	else
		delete from producto
			where prod_codigo in (select prod_codigo from deleted)
end