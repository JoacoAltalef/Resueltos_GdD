/*
7. Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.
VENTAS
Código				| Detalle			   | Cant. Mov.										  | Precio de Venta			 | Renglón					 | Ganancia
Código del articulo | Detalle del articulo | Cantidad de movimientos de ventas (Item factura) | Precio promedio de venta | Nro. de línea de la tabla | Precio de Venta – Cantidad * Costo Actual
*/

-- PROBABLEMENTE ESTÉ MAL, YA QUE LO HICE YO SOLO SIN CHEQUEAR CON NADA NI NADIE

use GD2015C1
go

create table venta (
	codigo char(8),
	detalle char(50),
	cantidad_movimientos decimal(12, 2),
	precio decimal(12, 2),
	renglon char(8),
	ganancia decimal(12, 2)
)
go

create proc ej7 @fecha1 smalldatetime, @fecha2 smalldatetime
as
begin
	insert into venta (codigo, detalle, cantidad_movimientos, precio, renglon, ganancia)
	select prod_codigo,
		prod_detalle,
		sum(item_cantidad),
		sum(item_precio * item_cantidad) / sum(item_cantidad),
		item_numero,
		sum(item_precio * item_cantidad) / sum(item_cantidad) - sum(item_cantidad) * costo_anual
	from producto
		join item_factura on item_producto = prod_codigo
		join factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
	where @fecha1 <= fact_fecha and fact_fecha <= @fecha2
	group by prod_codigo, prod_detalle
end
go
