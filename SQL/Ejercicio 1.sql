use GD2015C1

--------------
-- Punto 01 --
--------------
/* Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o
igual a $ 1000 ordenado por código de cliente. */
select clie_codigo, clie_razon_social from cliente
where clie_limite_credito >= 1000
order by clie_codigo