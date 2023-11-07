-----------------
-- Ejercicio 6 --
-----------------
/*Realizar un procedimiento que si en alguna factura se facturaron componentes
que conforman un combo determinado (o sea que juntos componen otro
producto de mayor nivel), en cuyo caso deberá reemplazar las filas
correspondientes a dichos productos por una sola fila con el producto que
componen con la cantidad de dicho producto que corresponda
*/

use GD2015C1
go


create procedure ej6
as
begin
	declare @fact_tipo char(1);
	declare @fact_suc char(4);
	declare @fact_nro char(8);
	declare @combo char(8);
	declare @combocantidad integer;	
	
	declare cFacturas cursor for --CURSOR PARA RECORRER LAS FACTURAS
		select fact_tipo, fact_sucursal, fact_numero -- Primary key
		from factura

	open cFacturas
		fetch next from cFacturas into @fact_tipo, @fact_suc, @fact_nro
		
		while @@FETCH_STATUS = 0
		begin
		-- Este cursor me va a traer todos los productos compuestos que podría armar para una factura.
			declare cProducto cursor for
			-- Esto sirve para traer de una factura solo los productos que sean componentes y que la cantidad que se facturó es mayor que la que utilizo para componer.
			-- Básicamente, trae todos los productos que pueden componer un combo.
				select comp_producto --ACÁ NECESITAMOS UN CURSOR PORQUE PUEDE HABER MáS DE UN COMBO EN UNA FACTURA
				from item_factura
					join composicion C1 on item_producto = C1.comp_componente
				where item_cantidad >= C1.comp_cantidad and
					  item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo
				group by C1.comp_producto
				having count(*) = -- Cantidad de productos diferentes que componen a ese producto y se vendieron en esta factura.
					(select count(*) from composicion as C2 where C2.comp_producto= C1.comp_producto) -- Cuántos componentes se requieren para formar al producto compuesto.

			open cProducto
			fetch next from cProducto into @combo
			while @@FETCH_STATUS = 0 
			begin
	  					
				select @combocantidad = min(floor((item_cantidad/c1.comp_cantidad)))
				from item_factura
					join Composicion C1 on item_producto = C1.comp_componente
				where item_cantidad >= C1.comp_cantidad and
					  item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo and
					  c1.comp_producto = @combo	--SACAMOS CUÁNTOS COMBOS PUEDO ARMAR COMO MÁXIMO (POR ESO EL MIN)
				
				--INSERTAMOS LA FILA DEL COMBO CON EL PRECIO QUE CORRESPONDE
				insert into item_factura (item_tipo, item_sucursal, item_numero, item_producto, item_cantidad, item_precio)
				select @fact_tipo, @fact_suc, @fact_nro, @combo, @combocantidad, @combocantidad * (select prod_precio from producto where prod_codigo = @combo);

				update item_factura
				set 
				-- Se va restando la cantidad según la cantidad de combos que se armaron.
				item_cantidad = i1.item_cantidad - (@combocantidad * (select comp_cantidad from composicion
																		where i1.item_producto = comp_componente 
																			and comp_producto = @combo)),
				item_precio = (i1.item_cantidad - (@combocantidad * (select comp_cantidad from composicion
																		where i1.item_producto = comp_componente
																			and comp_producto = @combo))) * 	
													(select prod_precio from producto where prod_codigo = I1.item_producto)
				--item_precio = item_cantidad * (select prod_precio from producto where prod_codigo = I1.item_producto)
				from item_factura I1, composicion C1 
				where I1.item_sucursal = @fact_suc and
					  I1.item_numero = @fact_nro and
					  I1.item_tipo = @fact_tipo and
					  I1.item_producto = C1.comp_componente and
					  C1.comp_producto = @combo
					  
				delete from item_factura
				where item_sucursal = @fact_suc and
					  item_numero = @fact_nro and
					  item_tipo = @fact_tipo and
					  item_cantidad = 0 -- Se eliminan los que pudieron utilizarse por completo para combos, es decir, que su cantidad quedó en 0 al ir restando.
				
				fetch next from cProducto into @combo
			end

			close cProducto;
			deallocate cProducto;
			
			fetch next from cFacturas into @fact_tipo, @fact_suc, @fact_nro
			end
		
		close cFacturas;
		deallocate cFacturas;
	end 
go



	select item_producto
	from factura
		join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero
		
	select item_producto
	from item_factura
	group by item_sucursal+item_tipo+item_numero
	having 


	select comp_producto
	from composicion
	group by comp_producto