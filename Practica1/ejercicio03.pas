{3. Realizar un programa que presente un menú con opciones para:
a.Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b.Abrir el archivo anteriormente generado y:
	i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
	determinado.
	ii.Listar en pantalla los empleados de a uno por línea.
	iii.Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

PROGRAM ejercicio03; 
CONST
	FIN = 'fin';
TYPE
	str50 = string[50];
	opciones = 'a'..'e';
	
	registro_empleado = record
		nro_empleado: integer;
		nombre: str50;
		apellido: str50;
		edad: integer;
		dni: integer;
	end;
	
	file_empleados = file of registro_empleado;
	
Procedure mostrarEmpleado(empleado: registro_empleado);
Begin
	with empleado do begin
		writeln('Número empleado: ', nro_empleado);
		writeln('Nombre empleado: ', nombre);
		writeln('Apellido empleado: ', apellido);
		writeln('Edad empleado: ', edad);
		writeln('Dni empleado: ', dni);
		writeln('');
	end;
End;
	
Procedure crearArchivo(var archivo: file_empleados);
	procedure leerEmpleado(var registro: registro_empleado);
	begin
		write('Apellido de empleado ("fin" para terminar): ');
		readln(registro.apellido);
		
		if (registro.apellido <> FIN) then begin
			with registro do begin
				write('Número de empleado: ');
				readln(nro_empleado);
				write('Nombre de empleado: ');
				readln(nombre);
				write('Edad de empleado: ');
				readln(edad);
				write('Dni de empleado: ');
				readln(dni);
				writeln('');
			end;
		end;
	end;
Var
	nombre: str50;
	empleado: registro_empleado;	
Begin
	write('Ingrese nombre del archivo para crear: ');
	readln(nombre);
	assign(archivo, nombre);
	
	rewrite(archivo);
	leerEmpleado(empleado);
	while (empleado.apellido <> FIN) do begin
		write(archivo, empleado);
		leerEmpleado(empleado);
	end;
	close(archivo);
End;

Procedure listarDeterminadosEmpleados(var archivo: file_empleados);
Var
	empleado: registro_empleado;
	caracteristica: str50;
	
Begin
	write('Ingresar nombre o apellido de empleados a listar: ');
	readln(caracteristica);

	reset(archivo);
	
	while (not eof(archivo)) do begin
		read(archivo, empleado);
		if ((empleado.apellido = caracteristica) or (empleado.nombre = caracteristica)) then
			mostrarEmpleado(empleado);
	end;
	
	close(archivo);
	
End;

Procedure listarTodos(var archivo: file_empleados);
Var
	empleado: registro_empleado;

Begin
	reset(archivo);
	
	while (not eof (archivo)) do begin
		read(archivo, empleado);
		mostrarEmpleado(empleado);
	end;
	
	close(archivo);
End;

Procedure listarJubilados(var archivo: file_empleados);
Var
	empleado: registro_empleado;
Begin
	reset(archivo);
	
	while (not eof (archivo)) do begin
		read(archivo, empleado);
		
		if (empleado.edad > 70) then
		mostrarEmpleado(empleado);
	end;
	
	close(archivo);
End;


VAR
	empleados: file_empleados;
	opcion: opciones;

BEGIN
	writeln('Opciones');
	writeln('a. Crear archivo de registros de empleado.');
	writeln('b. Listar determinados empleados.');
	writeln('c. Listar todos los empleados uno por línea.');
	writeln('d. Listar empleados pronto a jubilarse.');
	writeln('e. Salir.');
	writeln('');
	
	write('Ingresar opción: ');
	readln(opcion);
	
	while (opcion <> 'e') do begin
		case opcion of
			'a': crearArchivo(empleados);
			'b': listarDeterminadosEmpleados(empleados);
			'c': listarTodos(empleados);			
			'd': listarJubilados(empleados);
		end;
		
		write('Ingresar opción: ');
		readln(opcion);				//probleamas con read
		writeln(' ');
		
	end;
		
END.
