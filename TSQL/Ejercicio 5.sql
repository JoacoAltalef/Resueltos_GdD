-----------------
-- Ejercicio 5 --
-----------------
/*
Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada fact_table, que tiene las siguiente definici�n:

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
)
alter table fact_table
add constraint pk_fact_table primary key(anio, mes, familia, rubro, zona, cliente, producto)

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
)
alter table fact_table
add constraint pk_fact_table primary key(anio, mes, familia, rubro, zona, cliente, producto)