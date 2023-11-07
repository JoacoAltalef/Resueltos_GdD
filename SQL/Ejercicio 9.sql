use	GD2015C1

--------------
-- Punto 09 --
--------------
/*
Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/
-- Tiene que ser distinct, ya que sino toma el producto entre ambos count, pues se está haciendo dos joins
select empl_jefe, empl_codigo, rtrim(empl_nombre) + ' ' + rtrim(empl_apellido) Nombre, count(distinct d2.depo_codigo) 'Depositos jefe', count(distinct d1.depo_codigo) 'Depositos empleado' from empleado
left join deposito d1 on d1.depo_encargado = empl_codigo -- Necesito a todos los empleados. Sin el left, no traería a los que no son encargados de ningún depósito.
join deposito d2 on d2.depo_encargado = empl_jefe -- No va left, porque solo necesito sabe la info para cada jefe.
group by empl_jefe, empl_codigo, rtrim(empl_nombre) + ' ' + rtrim(empl_apellido)