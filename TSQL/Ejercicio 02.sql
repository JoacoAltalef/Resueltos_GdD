/*
Realizar una funci�n que dado un art�culo y una fecha, retorne el stock que
exist�a a esa fecha*/create function stock_hasta_fecha (@articulo char(8), @fecha smalldatetime)returns decimal(12,2)

begin
	return (select sum(stoc_cantidad) from stock
		where stoc_producto = @articulo and
			stoc_proxima_reposicion < @fecha) -- Cualquier cosa esto de la fecha pero no aparece la fecha del stock.
end

