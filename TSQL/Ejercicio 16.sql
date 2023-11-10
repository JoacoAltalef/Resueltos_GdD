------------------
-- Ejercicio 16 --
------------------
/*
Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos).
 En caso que no alcance el stock de un depósito se descontara del siguiente y asi
hasta agotar los depositos posibles. En última instancia se dejara stock negativo
en el ultimo deposito que se desconto.
*/

use GD2015C1
go

create trigger ej16 on item_factura
for insert
as
begin
	declare cursor_actualizacionStock cursor for
	select item_producto, item_cantidad
	from inserted
	
	declare @item_producto char(8)
	declare @item_cantidad decimal(12, 2)
	
	declare @stoc_producto char(8)
	declare @stoc_deposito char(2)
	declare @stoc_cantidad decimal(12, 2)

	declare @cantidad_a_restar decimal(12, 2)

	open cursor_actualizacionStock
		fetch next from cursor_actualizacionStock into @item_producto, @item_cantidad
		while @@FETCH_STATUS = 0
		begin
			declare cursor_stock cursor for
			select stoc_producto, stoc_deposito, stoc_cantidad
			from stock
			where stoc_producto = @item_producto
			order by stoc_cantidad desc

			open cursor_stock
			fetch next from cursor_stock into @stoc_producto, @stoc_deposito, @stoc_cantidad
			while @@FETCH_STATUS = 0
			begin
				if @item_cantidad = 0
					break

				--set @cantidad_a_restar = min(@item_cantidad, @stoc_cantidad) --No se puede hacer esto xd
				if @item_cantidad <= @stoc_cantidad
					set @cantidad_a_restar = @item_cantidad
				else
					set @cantidad_a_restar = @stoc_cantidad

				set @item_cantidad -= @cantidad_a_restar
				update stock
				set stoc_cantidad -= @cantidad_a_restar
				where stoc_deposito = @stoc_deposito and stoc_producto = @stoc_producto

				fetch next from cursor_stock into @stoc_producto, @stoc_deposito, @stoc_cantidad
			end

			--Resto la cantidad que le quedaba al último depósito de todos (el que menos cantidad tenía).
			--Si ya había restado toda la cantidad, se resta 0 así que no pasa nada.
			--Creo que igual hay que guardarse el @stoc_deposito y @stoc_producto en el while pq acá afuera queda vacío ya.
			update stock
			set stoc_cantidad -= @item_cantidad
			where stoc_deposito = @stoc_deposito and stoc_producto = @stoc_producto

			close cursor_stock
			deallocate cursor_stock

			fetch next from cursor_actualizacionStock into @item_producto, @item_cantidad
		end
	close cursor_actualizacionStock
	deallocate cursor_actualizacionStock
end
go


--Esta es otra forma:
alter trigger ej16 on item_factura for insert
as
begin
	declare @item_producto char(8)
	declare @item_cantidad decimal(12,2)

	declare @stoc_cantidad decimal(12,2)
	declare @stoc_deposito char(2)

	declare cursor_item cursor for (select item_producto, item_cantidad from inserted)
	open cursor_item
		fetch next from cursor_item into @item_producto, @item_cantidad
		while @@FETCH_STATUS = 0
		begin	
			while @item_cantidad > 0
    		begin
        		if (select max(stoc_cantidad) from STOCK where stoc_producto = @item_producto) = 0
				begin
					update stock set stoc_cantidad -= @item_cantidad where stoc_deposito = @stoc_deposito
					break
				end
    
	     		select top 1 @stoc_deposito = stoc_deposito, @stoc_cantidad = stoc_cantidad
				from stock
				where stoc_producto = @item_producto 
				order by stoc_cantidad desc
				
				if @item_cantidad <= @stoc_cantidad
					update stock
					set stoc_cantidad -= @item_cantidad
					where stoc_deposito = @stoc_deposito
				else 
				begin 
            		update stock
					set stoc_cantidad = 0
					where stoc_deposito = @stoc_deposito
						
					select @item_cantidad -= @stoc_cantidad
				end
			end		
			fetch next from cursor_item into @item_producto, @item_cantidad
		end
	close cursor_item
	deallocate cursor_item
end
go

