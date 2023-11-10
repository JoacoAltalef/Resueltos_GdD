/*
18.
Sabiendo que el l�mite de cr�dito de un cliente es el monto m�ximo que se le
puede facturar mensualmente, cree el/los objetos de base de datos necesarios
para que dicha regla de negocio se cumpla autom�ticamente. No se conoce la
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas.
*/
use GD2015C1
go

create trigger ej18 on factura
for insert, update
as
begin
	if exists(
		select *
		from inserted
			join cliente on clie_codigo = fact_cliente
		group by clie_codigo, month(fact_fecha)
		having clie_limite_credito > sum(fact_total)
	)
		rollback
end
go

