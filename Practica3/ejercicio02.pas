{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}
PROGRAM ejercicio2;
CONST
	FIN = -1;
TYPE
	registro_asistente = record
		nroAsistente: integer;
		apellido: str20;
		nombre: str20;
		email: str20;
		telefono: str20;
		dni: str20;
	end;
	
	archivo_registro = file of registro_asistente;
	
Procedure generarArchivo(var archivo: archivo_registro);

	procedure leer(var r: registro_asistente);
	begin
		write('Ingresar número de asistente: ');
		readln(r.nroAsistente);
		if (r.nroAsistente) <> FIN then begin
			with r do begin
				write('Apellido: ');
				readln(apellido);
				write('Nombre: ');
				readln(nombre);
				write('Email: ');
				readln(email);
				write('Teléfono: ');
				readln(telefono);
				write('Dni: ');
				readln(dni);
			end;
		end;
	end;
	
Var
	asistente: registro_asistente;
Begin
	rewrite(archivo);
	leerRegistro(asistente);
	while (asistente.nroAsistente <> FIN) do begin
		read(archivo, asistente);
		leerRegistro(asistente);
	end;
	close(archivo)
End;

Procedure eliminarLogicamente(var archivo: archivo_registro);
	
	procedure leer(var archivo: archivo_registro; var r: registro_asistente);
	begin
		if (not eof(archivo)) then
			read(archivo, r)
		else
			r.nroAsistente:= FIN;
	end;
	
Var
	asistente: registro_asistente;
	
Begin
	reset(archivo);
	leer(archivo, asistente);
	
	while (asistente.nroAsistente <> FIN) do begin
	
		if (asistente.nroAsistente < 1000) then begin
			asistente.dni:= ('@', asistente.dni);
			seek(archivo, filePos(archivo)-1);
			write(archivo, asistente);
		end;
	end;
	
	close(archivo);
End;
	
VAR
	archivo: archivo_registro;
BEGIN
	assign(archivo, 'Archivo_asistentes');
	generarArchivo(archivo);
	eliminarLogicamente(archivo);
END. 
