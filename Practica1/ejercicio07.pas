{7. Realizar un programa que permita:
	a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
	El nombre del archivo de texto es: “novelas.txt”
	b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
	una novela y modificar una existente. Las búsquedas se realizan por código de novela.
	
NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}
PROGRAM ejercicio07;

TYPE
	str50 = string[50];
	
	registro_novela = record
		codNovela: integer;
		precio: real;
		genero: str50;
		nombreNovela: str50;
	end;
	
	archivo_novelas = file of registro_novela;

{_______________________GENERAR ARCHIVO_______________________}	
Procedure generarArchivo(var archivo: archivo_novelas);
Var
	novela: registro_novela;
	archivoTxt: Text;
	
Begin

	rewrite(archivo);
	
	assign(archivoTxt, 'novelas.txt');
	reset(archivoTxt);
	
	while (not eof(archivoTxt) do begin		//writeln readln
		readln(archivoTxt, novela.codNovela, novela.precio, novela.genero);
		readln(archivoTxt, novela.nombre);
		writeln(archivo_novelas, novela);
	end;
	
	close(archivo);
	close(archivoTxt);
End

{_______________________ACTUALIZAR BINARIO_______________________}	
Procedure actualizarBinario(var archivo: archivo_novela);
	procedure leerNovela(var novela: registro_novela; cod: integer);
	begin
		with novela do begin
			codNovela:= cod;
			write('Precio: ');
			readln(precio);
			write('Genero: ');
			readln(genero);
			write('Nombre: ');
			readln(nombre);
		end;
	end;

Var
	novela: registro_novela;
	codigo: integer;
	encontre: boolean
	
Begin
	encontre:= false;
	
	reset(archivo);
	
	write('Ingresar código de novela: ');
	readln(codigo);
	
	while (not eof(archivo) and not(encontre)) do begin
		read(archivo, novela);
		if (novela.codNovela = codigo) then
			encontre:= true;
	end;
	
	if (encontre) then begin
		write('Editar novela: ');
		leerNovela(novela, codigo);
	end
	else begin
		write('Nueva novela: ');
		leerNovela(novela, codigo);
	end;
		
	Seek(archivo,FilePos(archivo)-1);
	writeln(archivo, novela)
	
	close(archivo);

End;

{_______________________P.P_______________________}	
	
VAR
	archivo: archivo_novelas;
	
BEGIN
	
	generarArchivo(archivo);
	
	actualizarBinario(archivo);
	
END.
