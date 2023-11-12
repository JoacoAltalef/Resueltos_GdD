create trigger fact_vendedor
on factura
for insert, update
as
begin

	if exists(
		select *
		from inserted
		where not fact_vendedor in (
			select empl_codigo
			from empleado
		)
	)
		rollback
end