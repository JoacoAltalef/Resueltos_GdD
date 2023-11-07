------------------
-- Ejercicio 21 --
------------------
/*
Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y
debe emitirse un error en pantalla.
*/

use GD2015C1
go

--Siempre hace insert, por eso es un for insert, pero después borra a todos aquellos items que no cumplan
--la regla, y luego al padre, que sería la factura.
create trigger ej21 on item_Factura for insert
as
begin
    if exists(select item_tipo + item_sucursal + item_numero from inserted 
				join producto on item_producto = prod_codigo
				group by item_tipo + item_sucursal + item_numero
				having count(distinct prod_familia) > 1)
    begin
        delete from item_factura where item_tipo + item_sucursal + item_numero in 
            (select item_tipo + item_sucursal + item_numero from inserted 
			join producto on item_producto = prod_codigo
			group by item_tipo + item_sucursal + item_numero
			having count(distinct prod_familia) > 1)
        delete from factura where fact_tipo + fact_sucursal + fact_numero in 
            (select item_tipo + item_sucursal + item_numero from inserted 
			join producto on item_producto = prod_codigo
			group by item_tipo + item_sucursal + item_numero
			having count(distinct prod_familia) > 1)
        raiserror('Hay items insertados de diferentes familias para al menos una factura.', 16, 1)
    end
end


--Está mal proque solo rollbackea a un único item, y no a todos. Ni siqiuera rollbackea a la factura.
/*
create trigger ej21 on item_factura
for insert
as
begin
	if exists (select *
			from inserted
				join producto on prod_codigo = item_producto
			group by item_numero+item_sucursal+item_tipo, prod_familia
			having count(*) > 1)
		rollback

	raiserror('Hay items insertados de diferentes familias para al menos una factura.', 16, 1)

end
*/
