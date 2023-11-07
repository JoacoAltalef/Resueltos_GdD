-----------------
-- Ejercicio 5 --
-----------------
/*
Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada fact_table, que tiene las siguiente definición:

create table fact_table(
	anio char(4),
	mes char(2),
	familia char(3),
	rubro char(4),
	zona char(3),
	cliente char(6),
	producto char(8),
	cantidad decimal(12, 2),
	monto decimal(12, 2)
)go
alter table fact_table
add constraint pk_fact_table primary key(anio, mes, familia, rubro, zona, cliente, producto)go*/use GD2015C1

create table fact_table(
	anio char(4),
	mes char(2),
	familia char(3),
	rubro char(4),
	zona char(3),
	cliente char(6),
	producto char(8),
	cantidad decimal(12, 2),
	monto decimal(12, 2)
)go
alter table fact_table
add constraint pk_fact_table primary key(anio, mes, familia, rubro, zona, cliente, producto)gocreate proc ej5asbegin	insert into fact_table (anio, mes, familia, rubro, zona, cliente, producto, cantidad, monto)	select year(fact_fecha), month(fact_fecha), prod_familia, prod_rubro, depa_zona, fact_cliente, item_producto, sum(item_cantidad), sum(item_cantidad * item_precio)	from factura		join item_factura on item_sucursal+item_tipo+item_numero = fact_sucursal+fact_tipo+fact_numero		join producto on prod_codigo = item_producto		join empleado on fact_vendedor = empl_codigo		join departamento on depa_codigo = empl_departamento	group by year(fact_fecha), month(fact_fecha), prod_familia, prod_rubro, depa_zona, fact_cliente, item_productoendgo