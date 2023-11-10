-----------------
-- Ejercicio 4 --
-----------------
/*
Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.*/use GD2015C1go

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'ej4')
	DROP PROCEDURE ej4
GOcreate procedure ej4	as	begin			update empleado			set empl_comision = (				select isnull(sum(fact_total), 0) from factura				where fact_vendedor = empl_codigo and					year(fact_fecha) = (select max(year(fact_fecha)) from factura)			)			declare @mayor_vendedor numeric(6)		select top 1 @mayor_vendedor = fact_vendedor from factura f1				where year(fact_fecha) = (select max(year(fact_fecha)) from factura)				group by fact_vendedor				order by sum(fact_total) desc			print 'Vendedor que más vendió en el último año: ' + str(@mayor_vendedor)	endgo/* Si se hace con cursor: Es mucho peor, no solo porque es más verboso sino que también pasa que hace un update por cada fila,que encima es el mismo update para todos (es decir, hace lo mismo, no cambia), cuando la forma de arriba hace un solo update de todo el conjunto. También sucede que hay que declarar más variables.*/create proc ej4 @vendedor numeric(6) outputasbegin	declare @otro_vendedor numeric(6), @monto numeric(12, 2)	declare c1 cursor for		select fact_vendedor, sum(fact_total) from factura		where year(fact_fecha) = (select max(year(fact_fecha)) from factura)		group by fact_vendedor	open c1		fetch next c1 into @otro_vendedor, @monto				while @@FETCH_STATUS = 0		begin			update empleado				set empl_comision = @monto				where empl_codigo = @otro_vendedor			fetch next c1 into @otro_vendedor, @monto		end	close c1	deallocate c1	select @vendedor = max(empl_comision) from empleado	returnend-- Lo del año también podría hacerse así.select top 1 year(fact_fecha) from facturaorder by fact_fecha desc