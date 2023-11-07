------------------
-- Ejercicio 11 --
------------------
/*
Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.
*/

use GD2015C1
go

drop function dbo.ej11
go

-- Funciona pero no la confirmé con nadie
create function ej11 (@codigo_empleado numeric(6))
returns int
begin
	return (select isnull(sum(1 + dbo.ej11(e.empl_codigo)), 0)
			from empleado jefe
				join empleado e on e.empl_jefe = jefe.empl_codigo
			where jefe.empl_codigo = @codigo_empleado --and
				--e.empl_codigo > e.empl_jefe
			)
end
go

-- Con cursor (es la única que mostró Henry (el profe)):
create function ej11 (@jefe numeric(6))
returns int 
AS
BEGIN
    declare @empleado numeric(6), @cantidad int

    select @cantidad = count(*)
	from empleado
	where empl_jefe = @jefe and
		empl_codigo > empl_jefe

    declare c1 cursor for
	select empl_codigo from empleado where empl_jefe = @jefe

    open c1
		fetch next from c1 into @empleado
		while @@FETCH_STATUS = 0
		begin
			set @cantidad = @cantidad + dbo.ej11(@empleado)
			fetch next from c1 into @empleado
		end
    close c1
    deallocate c1
    return @cantidad
end
go

select dbo.ej11(empl_codigo) from empleado
select * from empleado