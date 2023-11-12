drop table aud_stock
create table aud_stock (
	auds_renglon bigint identity(1, 1),
	auds_operacion char(3),
	auds_fecha_hora smalldatetime,
	auds_cantidad decimal(12, 2),
	auds_punto_reposicion decimal(12, 2),
	auds_stock_maximo decimal(12, 2),
	auds_detalle char(100),
	auds_proxima_reposicion smalldatetime,
	auds_producto char(8),
	auds_deposito char(2)
)
go

create trigger aud_stock
on stock
for insert, update, delete
as
begin
	declare @operacion char(3)
	
	if exists(select * from inserted) and exists(select * from deleted)
	begin
		insert into aud_stock (auds_operacion, auds_fecha_hora, auds_cantidad, auds_punto_reposicion, auds_stock_maximo, auds_detalle, auds_proxima_reposicion, auds_producto, auds_deposito)
		select 'UP1',
			getdate(),
			stoc_cantidad,
			stoc_punto_reposicion,
			stoc_stock_maximo,
			stoc_detalle,
			stoc_proxima_reposicion,
			stoc_producto,
			stoc_deposito
		from inserted

		
		insert into aud_stock (auds_operacion, auds_fecha_hora, auds_cantidad, auds_punto_reposicion, auds_stock_maximo, auds_detalle, auds_proxima_reposicion, auds_producto, auds_deposito)
		select 'UP2',
			getdate(),
			stoc_cantidad,
			stoc_punto_reposicion,
			stoc_stock_maximo,
			stoc_detalle,
			stoc_proxima_reposicion,
			stoc_producto,
			stoc_deposito
		from deleted

	end
	else if exists(select * from inserted)
		insert into aud_stock (auds_operacion, auds_fecha_hora, auds_cantidad, auds_punto_reposicion, auds_stock_maximo, auds_detalle, auds_proxima_reposicion, auds_producto, auds_deposito)
		select 'INS',
			getdate(),
			stoc_cantidad,
			stoc_punto_reposicion,
			stoc_stock_maximo,
			stoc_detalle,
			stoc_proxima_reposicion,
			stoc_producto,
			stoc_deposito
		from inserted
	else
		insert into aud_stock (auds_operacion, auds_fecha_hora, auds_cantidad, auds_punto_reposicion, auds_stock_maximo, auds_detalle, auds_proxima_reposicion, auds_producto, auds_deposito)
		select 'DEL',
			getdate(),
			stoc_cantidad,
			stoc_punto_reposicion,
			stoc_stock_maximo,
			stoc_detalle,
			stoc_proxima_reposicion,
			stoc_producto,
			stoc_deposito
		from deleted

end