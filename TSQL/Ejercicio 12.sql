------------------
-- Ejercicio 12 --
------------------
/*
Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.
*/

use GD2015C1
go

create trigger ej12 on composicion after insert, update 
as
begin
    if (select count(*) from inserted where dbo.compuestopor(comp_producto, comp_componente) = 1) > 0
        rollback
end
go

create function compuestopor(@producto CHAR(8), @componente char(8))
returns int
as
begin
	if @producto = @componente 
		return 1

	declare @prodaux char(8)
	declare cursor_componente cursor
	for select comp_componente
		from composicion
		where comp_producto = @componente
	open cursor_componente
		fetch next from cursor_componente into @prodaux
		while @@FETCH_STATUS = 0
		begin
			if dbo.compuestopor(@producto, @prodaux) = 1
				return 1 
			fetch next from cursor_componente into @prodaux
		end
	close cursor_componente
	deallocate cursor_componente
	return 0
end
go



-- MAL! Porque no es recursivo y por ende no llega a varios niveles de composición.
create trigger ej12 on composicion
instead of insert
as
begin
	declare cComposicion cursor
	for select * from inserted

	declare @compuesto char(8)
	declare @componente char(8)
	declare @cantidad decimal(12, 2)

	open cComposicion
		fetch next from cComposicion into @compuesto, @componente, @cantidad
		while @@FETCH_STATUS = 0
		begin
			if @compuesto != @componente
				insert into composicion (comp_producto, comp_componente, comp_cantidad)
				values (@compuesto, @componente, @cantidad)

			fetch next from cComposicion into @compuesto, @componente, @cantidad
		end
	close cComposicion
	deallocate cComposicion
end
go
