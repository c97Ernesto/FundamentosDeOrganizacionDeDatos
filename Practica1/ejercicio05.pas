{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
	a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
	ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
	correspondientes a los celulares, deben contener: código de celular, el nombre,
	descripción, marca, precio, stock mínimo y el stock disponible.
	b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
	stock mínimo.
	c. Listar en pantalla los celulares del archivo cuya descripción contenga una
	cadena de caracteres proporcionada por el usuario.
	d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
	“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
	podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
	debería respetar el formato dado para este tipo de archivos en la NOTA 2.
	
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
	tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
	marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
	nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
	“celulares.txt”.
}

PROGRAM ejercicio05;

TYPE
	str50 = string[50];	
	opciones = 'a'..'e';
	
	registro_celular = record
		codCelular: integer;
		precio: integer;
		marca: str50;
		stockDisponible: integer;
		stockMinimo: integer;
		descripcion: str50;
		nombre: str50;
	end;
	
	archivo_celulares = file of registro_celular;
	
	
Procedure mostrarCelular(celular: registro_celular);
Begin
	with celular do begin
		write(codCelular, ' ');
		write(precio, ' ');
		write(marca, ' ');
		write(stockDisponible, ' ');
		write(stockMinimo, ' ');
		write(descripcion, ' ');
		write(nombre, ' ');
	end;
End;

Procedure cargarArchivoCelulares(var archivo: archivo_celulares);
Var
	archivoTxt: Text;
	celular: registro_celular;
	nombreArchivo: str50;
	
Begin
	write('Ingresar nombre del nuevo archivo: ');
	readln(nombreArchivo);
	
	assign(archivo, nombreArchivo);
	rewrite(archivo);
	
	assign(archivoTxt, 'Celulares.txt');
	reset(archivoTxt);
	
	while (not eof(archivoTxt)) do begin
		{utilización de "readln" pasa saltar de renglón y los strings siempre al final}
		//cargamos registro
		readln(archivoTxt, celular.codCelular, celular.precio, celular.marca);				
		readln(archivoTxt, celular.stockMinimo, celular.stockDisponible, celular.descripcion);		
		readln(archivoTxt, celular.nombre);
		
		write(archivo, celular);
		
	end;
	
End;

Procedure listarCelularesConPocoStock(var archivo: archivo_celulares);
Var
	celular: registro_celular;
Begin
	
	reset(archivo);
	
	while (not eof(archivo)) do begin
		read(archivo, celular);
		
		if(celular.stockDisponible < celular.stockMinimo) then
			mostrarCelular(celular);
	
	end;
	
	close(archivo);
End;

Procedure listarDeterminadosCelulares(var archivo: archivo_celulares);
Var
	celular: registro_celular;
	caracteristica: str50;
	existe: boolean;
Begin
	existe:= false;
	reset(archivo);
	
	write('Ingresar característica del celular: ');
	readln(caracteristica);
	
	while(not eof(archivo)) do begin
		read(archivo, celular);
		if (celular.descripcion = caracteristica) then begin
			existe:= true;
			mostrarCelular(celular);
		end;
	end;
	
	close(archivo);
	
	if (not existe) then
		writeln('No existe celular con esas características.');
	
End;


Procedure exportarArchivo(var archivo: archivo_celulares);
Var
	celular: registro_celular;
	archivoExportarTxt: Text;
	
Begin
	reset(archivo);
	
	assign(archivoExportarTxt, 'Celulares1.txt');
	rewrite(archivoExportarTxt);
	
	while (not eof(archivo)) do begin
		read(archivo, celular);
	
{
		writeln(archivoExportarTxt, celular.codCelular, celular.precio, celular.marca);				
		writeln(archivoExportarTxt, celular.stockMinimo, celular.stockDisponible, celular.descripcion);		
		writeln(archivoExportarTxt, celular.nombre);
}
		
		writeln(archivoExportarTxt, celular.codCelular,' ', celular.precio,' ', celular.marca,' ', celular.stockMinimo, ' ', celular.stockDisponible, ' ', celular.descripcion, ' ', celular.nombre);
	end;
	
	close(archivo);
End;


VAR
	archivoCelulares: archivo_celulares;
	opcion: opciones;

BEGIN
	
	
	writeln('Opciones');
	writeln('a. Cargar archivo con archivo "celulares.txt".');
	writeln('b. Listar celulares con stock minimo alcanzado.');
	writeln('c. Listar celulares con determinada descripcion.');
	writeln('d. Exportar celulares a "celulares.txt".');
	writeln('e. Salir');

	writeln('');
	write('Ingresar opción: ');
	readln(opcion);

	while (opcion <> 'e') do begin
		case opcion of
			'a': cargarArchivoCelulares(archivoCelulares);
			'b': listarCelularesConPocoStock(archivoCelulares);
			'c': listarDeterminadosCelulares(archivoCelulares);
			'd': exportarArchivo(archivoCelulares);

		end;
		
		writeln('');
		write('Ingresar opción: ');
		readln(opcion);	
		writeln('');
	end;
	
END.

