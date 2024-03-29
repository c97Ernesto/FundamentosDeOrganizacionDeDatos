{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
	utiliza la técnica de lista invertida para recuperar espacio libre en el
	archivo. Para ello, durante la creación del archivo, en el primer registro del
	mismo se debe almacenar la cabecera de la lista. Es decir un registro
	ficticio, inicializando con el valor cero (0) el campo correspondiente al
	código de novela, el cual indica que no hay espacio libre dentro del
	archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
	inciso a., se utiliza lista invertida para recuperación de espacio. En
	particular, para el campo de  ́enlace ́ de la lista, se debe especificar los
	números de registro referenciados con signo negativo, (utilice el código de
	novela como enlace).Una vez abierto el archivo, brindar operaciones para:
	i. Dar de alta una novela leyendo la información desde teclado. Para
		esta operación, en caso de ser posible, deberá recuperarse el
		espacio libre. Es decir, si en el campo correspondiente al código de
		novela del registro cabecera hay un valor negativo, por ejemplo -5,
		se debe leer el registro en la posición 5, copiarlo en la posición 0
		(actualizar la lista de espacio libre) y grabar el nuevo registro en la
		posición 5. Con el valor 0 (cero) en el registro cabecera se indica
		que no hay espacio libre.
	ii. Modificar los datos de una novela leyendo la información desde
		teclado. El código de novela no puede ser modificado.
	iii. Eliminar una novela cuyo código es ingresado por teclado. Por
		ejemplo, si se da de baja un registro en la posición 8, en el campo
		código de novela del registro cabecera deberá figurar -8, y en el
		registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
}
PROGRAM
CONST 
	FIN = 0;
	VALOR_ALTO = 9999;
TYPE
	opciones = 'a'..'d';
	str20 = String[20]

	registro_novela = record
		codigo: integer;
		genero: str20;
		nombre: str20;
		duracion: str20;
		director: str20;
		precio: real;
	end;
	
	archivo_novelas = file of registro_novela;
	
procedure leerReg(var reg: reg_Novela);
begin
	with reg do begin
		write('Codigo: ');
		readln(codigo);
		if (codigo <> FIN) then begin
			write('Genero: ');
			readln(genero);
			write('Nombre: ');
			readln(nombre);
			write('Duracion: ');
			readln(duracion);
			write('Director: ');
			readln(director);
			write('Precio: ');
			readln(precio);
		end;
	end;
end;

Procedure leerArchivo(var a: archivo_novelas; r: registro_novela);
Begin
	if (not eof(a)) then
		read(a, r);
	else
		r.codigo:= VALOR_ALTO;
End;
{_____________________________________Generar Archivo_____________________________________}
{Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el archivo}
Procedure GenerarArchivo (var archivo: archivo_novelas);
Var
	novela: registro_novela;
Begin
	assign(archivo, 'Novelas');
	rewrite(archivo);
	{creo el 1er registro del archivo (regAux), con 0 espacios disponibles en el archivo}
	novela.codigo:= 0;
	write(archivo, novela);
	
	LeerRegistro(novela);
	while (novela.codigo <> FIN) do begin
		write(archivo, novela);
		leer(archivo, novela);
	end;
	
	close(archivo);
End;	

{_____________________________________Abrir Archivo Existente_____________________________________}
{Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio.}
Procedure AbrirArchivoExistente(var archivo: archivo_novelas);

	procedure darDeAlta(var archivo: archivo_novelas);
	var
		novela, regAux: registro_novela;
		
	begin
		read(archivo, regAux);
		
		leerReg(novela);
		
		if (regAux.codigo < 0) then begin
			seek(archivo,  regAux.codigo*-1);	//me posiciono en el registro vacío 
			
			read(archivo, regAux);	//leo el registro vacío
			
			seek(archivo, filePos(archivo)-1)		
			
			read(archivo, novela);			//escribo la nueva novela
			
			seek(archivo, 0);
			
			write(archivo, regAux); 		//actualizo el cabecero
		end;
		else begin
			seek(archivo, fileSize(archivo));		//almaceno en el final del archivo
			write(archivo, novela);
		end;
	end;
	
	procedure modificarNovela(var archivo: archivo_novelas);
	var
		cod: integer;
	begin
		write('Codigo de novela a eliminar: ');
		readln(cod);
		
		read(archivo, novela);
		while (not eof(archivo)) and (cod <> novela.codigo) do
			read(archivo, novela);
		
		if (novela.codigo = cod) then begin
			readln(novela.genero);
			readln(novela.nombre);
			readln(novela.duracion);
			readln(novela.director);
			readln(novela.precio);
			
			seek(archivo, filePos(archivo)-1);
			write(archivo, novela);
		end;
	end;
	
	procedure eliminarNovela(var archivo);
	var
		novela, regAux: registro_novela;
		cod: integer;
	begin
		read(archivo, regAux);	//leo el 1er registro del archivo que contiene los enlaces a los registros vacíos
	
		write('Ingresar código de novela a eliminar: ');
		readln(cod);
		
		leerArchivo(archivo, novela);	//leo el 2do registro
		while (novela.codigo <> VALOR_ALTO) and (novela.codigo <> cod) do 
			leerArchivo(archivo, novela);
		
		if (novela.codigo = cod) then begin //si es la novela a eliminar:
			//almaceno en la novela eliminada, el índice en negativo de la anterior novela eliminada.
			novela.codigo:= regAux.codigo;	
			
			//me posiciono en el lugar de la novela eliminada
			seek(archivo, filePos(archivo)-1);
			
			//almaceno en el regAux la posición de la novela eliminada  *-1
			regAux.codigo:= (filePos(archivo)) * -1;		
			
			write(archivo, novela);
			
			seek(archivo, 0);
			
			write(archivo, regAux);
		end;
	end;
Var
	opc: opciones;
Begin
	assign(archivo,  'Novelas');
	reset(archivo);
	
	repeat
		writeln('				MENU				');
		writeln('a. Dar de alta una Novela.');
		writeln('b. Modificar Datos de Novela.');
		writeln('c. Eliminar Novela.');
		writeln('d. Salir.');
		writeln('');
		writeln('');
		
		write('Ingresar Opcion: ');
		readln(opc);
		
		case opc of
			'a': darAlta(archivo);
			'b': modificarDatos(archivo);
			'c': eliminar(archivo);
		end;
			
	until (opc = 'd')
	
	close(archivo);
	
End;


//_______________________________P.P_______________________________
VAR
	archivo: archivo_novelas;
	opc: opciones;
BEGIN
	
	repeat
		writeln('				MENU				');
		writeln('a. Generar Archivo de Novelas.');
		writeln('b. Abrir Archivo Existente.');
		writeln('c. Listar Archivo en Txt.');
		writeln('d. Salir.');
		writeln('');
		writeln('');
		
		write('Ingresar Opcion: ');
		readln(opc);
		
		case opc of
			'a': GenerarArchivo(archivo);
			'b': AbrirArchivoExistente(archivo);
			'c': ExportarTxt(archivo);
		end;
		
	until (opc = 'd')
END.

