-----------------
-- Ejercicio 1 --
-----------------
/*
Hacer una funci�n que dado un art�culo y un deposito devuelva un string que
indique el estado del dep�sito seg�n el art�culo. Si la cantidad almacenada es
menor al l�mite retornar �OCUPACION DEL DEPOSITO XX %� siendo XX el
% de ocupaci�n. Si la cantidad almacenada es mayor o igual al l�mite retornar
�DEPOSITO COMPLETO�.
*/


create function ejercicio1 (@articulo char(8), @deposito char(2))
returns char(40)
AS
begin
	declare @stock_actual decimal (12,2), @stock_maximo decimal(12,2)
	declare @retorno char(40)

	select @stock_actual = stoc_cantidad, @stock_maximo = stoc_stock_maximo from stock
	where stoc_producto = @articulo and stoc_deposito = @deposito
	if @stock_maximo is null or @stock_actual >= @stock_maximo
		select @retorno = 'DEPOSITO COMPLETO'
	else
		set @retorno = 'OCUPACI�N DEL DEP�SITO ' + str(@stock_actual / @stock_maximo * 100, 12, 2) + '%'

	return @retorno
end


go



create function [dbo].[ejercicio1] (@articulo char(8), @deposito char(2))
returns varchar(40)
as
begin
return (select
			case
				when stoc_stock_maximo is null or stoc_cantidad >= stoc_stock_maximo then 'DEPOSITO COMPLETO'
				else 'OCUPACI�N DEL DEP�SITO' + str(stoc_cantidad / stoc_stock_maximo * 100, 12, 2) + '%'
			end
		from stock
		where stoc_producto = @articulo and stoc_deposito = @deposito)
end