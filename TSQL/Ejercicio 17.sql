/*
17.
Sabiendo que el punto de reposición del stock es la menor cantidad de ese objeto
que se debe almacenar en el depósito y que el stock máximo es la máxima
cantidad de ese producto en ese depósito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automáticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock.
*/

use GD2015C1
go


create trigger ej17 on stock
for insert, update
as
begin
	if exists(
		select *
		from inserted
		where stoc_punto_reposicion < stoc_cantidad or
			stoc_cantidad < stoc_stock_maximo
	)
		rollback
end
go

-- Con cursor:
alter trigger ej17 on stock
for insert, update
as
begin
	declare @cantidad decimal(12, 2)
	declare @punto_reposicion decimal(12, 2)
	declare @stock_maximo decimal(12, 2)

	declare cursor_stock cursor for
	select stoc_cantidad, stoc_punto_reposicion, stoc_stock_maximo from inserted

	open cursor_cantidad
		fetch next from cursor_cantidad into @cantidad, @punto_reposicion, @stock_maximo
		while @@FETCH_STATUS = 0
		begin
			if @punto_reposicion < @cantidad or @cantidad < @stock_maximo
			begin
				rollback
				break
			end

			fetch next from cursor_cantidad into @cantidad, @punto_reposicion, @stock_maximo
		end
	close cursor_cantidad
	deallocate cursor_cantidad
end
