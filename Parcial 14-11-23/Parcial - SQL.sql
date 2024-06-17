use GD2015C1

-- Punto 1 - SQL
select prod_codigo,
	prod_detalle,

	(select top 1 depo_domicilio
	from deposito
		join stock on stoc_deposito = depo_codigo
	where stoc_producto = prod_codigo and
		stoc_cantidad <= 0) 'Domicilio del depósito sin stock',

	(select count(*)
	from stock -- No hace falta joinearlo con deposito
	where stoc_producto = prod_codigo and
		stoc_cantidad > stoc_punto_reposicion) 'Cantidad de depósitos con stock superior al punto de reposición'
from producto
where prod_codigo in (
		select stoc_producto
		from stock
		where stoc_cantidad <= 0
	) and prod_codigo in (
		select stoc_producto
		from stock
		where stoc_cantidad > stoc_punto_reposicion
	)
order by prod_codigo
go

-- Punto 2 - TSQL

create procedure punto2 (@prod_codigo char(3), @fecha_minima smalldatetime, @max_cant_dias_consecutivos int output)
as
begin

	declare c_dias_consecutivos cursor for
	select fact_fecha, item_producto
	from factura
		join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
	where item_producto = @prod_codigo and
		fact_fecha > @fecha_minima
	order by fact_fecha

	
	declare @ultima_fecha smalldatetime
	set @ultima_fecha = @fecha_minima --Arranca siendo la primer fecha
	declare @cant_dias_consecutivos int
	set @cant_dias_consecutivos = 0 -- Inicializo
	set @max_cant_dias_consecutivos = 0 -- Inicializo

	declare @fecha smalldatetime
	declare @item_producto char(3)
	open c_dias_consecutivos
		fetch next from c_dias_consecutivos into @fecha, @item_producto
		while @@FETCH_STATUS = 0
		begin
			if datediff(day, @fecha, @ultima_fecha) = 1
				set @cant_dias_consecutivos = @cant_dias_consecutivos + 1
			else
			begin
				if @cant_dias_consecutivos > @max_cant_dias_consecutivos
					set @max_cant_dias_consecutivos = @cant_dias_consecutivos

				set @cant_dias_consecutivos = 0
			end
				
			set @ultima_fecha = @fecha
			fetch next from c_dias_consecutivos into @fecha, @item_producto
		end
	close c_dias_consecutivos
	deallocate c_dias_consecutivos

	
end





