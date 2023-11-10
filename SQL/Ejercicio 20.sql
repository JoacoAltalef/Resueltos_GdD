--------------
-- Punto 20 --
--------------
/*.
Escriba una consulta sql que retorne un ranking de los 3 mejores empleados del 2012.
 Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
2012.
 El puntaje de cada empleado se calculará de la siguiente manera: para los que
hayan vendido al menos 50 facturas, el puntaje se calculará como la cantidad de facturas
que superen los 100 pesos que haya vendido en el año. Para los que tengan menos de 50
facturas en el año, el cálculo del puntaje será el 50% de la cantidad de facturas realizadas
por sus subordinados directos en dicho año.*/use GD2015C1--El legajo es el empl_codigoselect top 3	empl_codigo,	empl_nombre,	empl_apellido,	empl_ingreso,	dbo.puntaje(empl_codigo, 2011) 'puntaje 2011',	dbo.puntaje(empl_codigo, 2012) 'puntaje 2012'from empleadoorder by dbo.puntaje(empl_codigo, 2012)gocreate function puntaje (@empl_codigo numeric(6), @anio smalldatetime)returns intasbegin	if (select count(*) from factura where fact_vendedor = @empl_codigo) >= 50		return (select count(*)				from factura				where fact_vendedor = @empl_codigo and					fact_total > 100 and					year(fact_fecha) = @anio)	else		return 0.5 * (select count(*)						from factura							join empleado on empl_codigo = fact_vendedor						where year(fact_fecha) = @anio and							empl_jefe = @empl_codigo)	return -1endgo/*Como no se pueden usar funciones en SQL, para el parcial habría que repetir la lógica (lo cuál es una pelotudez) y hacer:*/select top 3 empl_codigo,
	rtrim(empl_nombre)+' '+	rtrim(empl_apellido) 'Nombre y apellido',
	empl_ingreso,
    case
		when (select count(*) from factura where fact_vendedor = empl_codigo) >= 50
			then (select count(*) from factura where fact_vendedor = empl_codigo and fact_total > 100 
                    and year(fact_fecha) = 2011)
	    else
		    (select count(*) from factura join empleado e2 on e2.empl_codigo = fact_vendedor
						where year(fact_fecha) = 2011 and e2.empl_jefe = e1.empl_codigo)/2
    end 'puntaje 2011',
    case 
		when (select count(*) from factura where fact_vendedor = empl_codigo) >= 50
			then (select count(*) from factura where fact_vendedor = empl_codigo and fact_total > 100 
                    and year(fact_fecha) = 2012)
	    else
			(select count(*) from factura join empleado e2 on e2.empl_codigo = fact_vendedor
						where year(fact_fecha) = 2012 and e2.empl_jefe = e1.empl_codigo)/2
    end 'puntaje 2012'
from empleado e1
order by 5 desc