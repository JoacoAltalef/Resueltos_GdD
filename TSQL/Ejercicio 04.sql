-----------------
-- Ejercicio 4 --
-----------------
/*
Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del �ltimo a�o. Se deber� retornar el c�digo del vendedor
que m�s vendi� (en monto) a lo largo del �ltimo a�o.

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'ej4')
	DROP PROCEDURE ej4
GO