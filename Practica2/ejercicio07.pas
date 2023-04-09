{
7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos 
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
	a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
	Ambos archivos están ordenados por código de producto.
	Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
	archivo detalle.
	El archivo detalle sólo contiene registros que están en el archivo maestro.
	b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
	stock actual esté por debajo del stock mínimo permitido.
}
PROGRAM ejercicio07;

CONST
	VALOR_ALTO = 9999;

TYPE
	opciones = 'a'..'c';
	str50 = string[50];
	
	registro_maestro = record
		codProducto: integer;
		nombre: str50;
		precio: real;
		stockActual: integer;
		stockMinimo: integer;
	end;
	
	registro_detalle = record
		codProducto: integer;
		cantVendida: integer;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle = file of registro_detalle;

//____________________________Leer____________________________
Procedure leer(var archivo: archivo_detalle; var registro: registro_detalle);
Begin
	if (not eof(archivo)) then
		read(archivo, registro)
	else
		registro.codProducto:= VALOR_ALTO;
End;

//____________________________Actualizar Maestro____________________________
Procedure actualizarMaestro(var maestro: archivo_maestro; var detalle: archivo_detalle);
Var
	registroMaestro: registro_maestro;
	registroDetalle: registro_detalle;
	
Begin
	reset(maestro);
	reset(detalle);
	
	leer(detalle, registroDetalle);
	
	//comenzamos leyendo detalle por si hay algo que modificar en el maestro. No hay detalles no hay modificaciones.
	while (registroDetalle.codProducto <> VALOR_ALTO) do begin
		read(maestro, registroMaestro);
		
		//busco el maestro que coincida con el detalle que lo va a modificar
		while (registroMaestro.codProducto <> registroDetalle.codProducto) do
			read(maestro, registroMaestro);
		
		//si hay más de un detalle para el mismo maestro, acumulo.
		while (registroMaestro.codProducto = registroDetalle.codProducto) do begin
			registroMaestro.stockMinimo:= registroMaestro.stockMinimo - registroDetalle.cantVendida;
			leer(detalle, registroDetalle);
		end;
		
		seek(maestro, filePos(maestro)-1);
		write(maestro, registroMaestro);
		
	end;	
	
	close(maestro);
	close(detalle);
End;

//____________________________Listar en Txt____________________________
Procedure listarTxt(var maestro: archivo_maestro);
Var
	archivoTxt: Text;
	registroMaestro: registro_maestro;
	
Begin
	reset(maestro);
	
	assign(archivoTxt, 'stock_minimo.txt');
	rewrite(archivoTxt);
	
	while (not eof(maestro)) do begin
		read(maestro, registroMaestro);
		
		if (registroMaestro.stockMinimo > registroMaestro.stockActual) then
			write(archivoTxt, registroMaestro.codProducto, registroMaestro.nombre, registroMaestro.precio, registroMaestro.stockMinimo, registroMaestro.stockActual);
	end;
	
	close(maestro);
	close(archivoTxt)
End;
	
//____________________________P.P____________________________
VAR
	opcion: opciones;
	
	maestro: archivo_maestro;
	detalle: archivo_detalle;
	
BEGIN
	assign(maestro, 'maestro');
	assign(detalle, 'detalle');
	
	writeln('a. Actualizar maestro con detalle');
	writeln('b. Listar en Txt productos por debajo del mínimo');

	write('Ingresar opción: ');
	readln(opcion);
	
	while (opcion <> 'c') do begin
		case opcion of 
			'a': actualizarMaestro(maestro, detalle);
			'b': listarTxt(maestro);
		end;
		
		writeln('a. Actualizar maestro con detalle');
		writeln('b. Listar en Txt productos por debajo del mínimo');

		write('Ingresar opción: ');
		readln(opcion);
	end;
END.
