/*
22.
 Se requiere recategorizar los rubros de productos, de forma tal que ning�n rubro
tenga m�s de 20 productos asignados. Si un rubro tiene m�s de 20 productos
asignados, se deber�n distribuir en otros rubros que no tengan m�s de 20
productos, y si no entran, se deber� crear un nuevo rubro en la misma familia con
la descirpci�n �RUBRO REASIGNADO�.
 Cree el/los objetos de base de datos necesarios para que dicha regla de negocio quede implementada.*/use GD2015C1gocreate trigger ej22on productofor insert, updateasbegin	declare rasignacion cursor for	select prod_rubro, prod_codigo	from inserted	declare @prod_rubro char(4)	declare @prod_codigo char(8)	open reasignacion		fetch next reasignacion into @prod_rubro, @prod_codigo		while @@FETCH_STATUS = 0		begin			if (select count(*) from inserted where prod_rubro = @prod_rubro) > 20			begin				if exists(select 1 from inserted group by prod_rubro having count(*) < 20)					update producto					set prod_rubro = (select top 1 from					where prod_codigo = @prod_codigo				else			end						fetch next reasignacion into @prod_rubro, @prod_codigo		end	close reasignacion	deallocate reasignacionend