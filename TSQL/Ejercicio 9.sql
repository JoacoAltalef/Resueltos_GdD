-----------------
-- Ejercicio 9 --
-----------------
/*
Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
factura de un artículo con composición realice el movimiento de sus
correspondientes componentes.
*/

use GD2015C1
go

create trigger ej9 on item_factura
for update
as
begin
	update stock set stoc_cantidad =
		-- Productos que fueron modificados y que tienen componentes.
		(select comp_cantidad * (i.item_cantidad - d.item_cantidad)
		from inserted i
			join deleted d on d.item_numero+d.item_sucursal+d.item_tipo+d.item_producto = i.item_numero+i.item_sucursal+i.item_tipo+i.item_producto --Pues es la PK
			join composicion on comp_producto = i.item_producto
		where comp_componente = stoc_producto and
			stoc_deposito = (select top 1 stoc_deposito -- Esto se hace para solo utilizar el stock de un único depósito, pues sino lo haría una vez por cada depósito
							from stock where stoc_producto = comp_componente
							order by stoc_cantidad desc)
		)
end
go

-- Con cursor:
-- (siempre es preferible hacerlo sin cursor)
CREATE TRIGGER ej9 ON ITEM_FACTURA FOR UPDATE 
AS 
BEGIN
	DECLARE @COMPONENTE char(8), @CANTIDAD decimal(12,2)
	DECLARE cursorComponentes CURSOR
	FOR SELECT comp_componente, (I.item_cantidad - d.item_cantidad) * comp_cantidad
		FROM Composicion 
			JOIN inserted I on comp_producto = i.item_producto
			JOIN deleted d on comp_producto = d.item_producto
		WHERE i.item_cantidad != d.item_cantidad

	OPEN cursorComponentes
		FETCH NEXT FROM cursorComponentes 
		INTO @COMPONENTE, @CANTIDAD
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE STOCK SET stoc_cantidad = stoc_cantidad - @CANTIDAD
			WHERE stoc_producto = @COMPONENTE AND STOC_DEPOSITO = (SELECT TOP 1 STOC_DEPOSITO FROM STOCK
										 WHERE STOC_PRODUCTO = @COMPONENTE ORDER BY STOC_CANTIDAD DESC)
			FETCH NEXT FROM cursorComponentes
			INTO @COMPONENTE, @CANTIDAD
		END
	CLOSE cursorComponentes
	DEALLOCATE cursorComponentes
END
GO