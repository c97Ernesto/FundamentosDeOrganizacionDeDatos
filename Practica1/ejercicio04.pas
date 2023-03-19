{4. Agregar al menú del programa del ejercicio 3, opciones para: 
* a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
* teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
* un número de empleado ya registrado (control de unicidad).
* b.Modificar edad a uno o más empleados.
* c.Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
* d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no 
* tengan cargado el DNI (DNI en 00).
* NOTA: Las búsquedas deben realizarse por número de empleado.}
 

PROGRAM ejercicio04; 
CONST
	FIN = 'fin';
TYPE
	str50 = string[50];
	opciones = 'a'..'i';
	
	registro_empleado = record
		nro_empleado: integer;
		nombre: str50;
		apellido: str50;
		edad: integer;
		dni: integer;
	end;
	
	file_empleados = file of registro_empleado;

{__________________LEER EMPLEADO__________________}
Procedure leerEmpleado(var registro: registro_empleado);
Begin
	write('Apellido de empleado (fin para terminar): ');
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
	end
	
End;

{__________________CONTROL UNICIDAD__________________}
Function controlUnicidad(var archivo: file_empleados; id: integer): boolean;
Var
	existe: boolean;
	empleado: registro_empleado;
Begin
	existe:= false;
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo, empleado);
		if (empleado.nro_empleado = id) then
			existe:= true;
	end;
	close(archivo);
	controlUnicidad:= existe
End;
{
Procedure controlUnicidad(var archivo: file_empleados; id: integer; var ok: boolean);
Var
	empleado: registro_empleado;
Begin
	ok:= false;
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo, empleado);
		if (empleado.nro_empleado = id) then
			ok:= true;
	end;
	close(archivo);
End;
}

{__________________MOSTRAR EMPLEADO__________________}
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

{__________________CREAR ARCHIVO__________________}
Procedure crearArchivo(var archivo: file_empleados);
	
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

{__________________LISTAR DETERMINADOS__________________}
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

{__________________LISTAR TODOS__________________}
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

{__________________LISTAR JUBILADOS__________________}
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

{__________________AGREGAR EMPLEADO__________________}
Procedure agregarEmpleados(var archivo: file_empleados);
Var
	empleado: registro_empleado;
{
	existe: boolean;
}
Begin
{
	existe:= false;
}
	reset(archivo);
	leerEmpleado(empleado);
	while (empleado.apellido <> FIN) do begin
		if (controlUnicidad(archivo, empleado.nro_empleado)) then
			writeln('El empleado ya existe.')
{
		controlUnicidad(archivo, empleado.nro_empleado, existe);
		if (existe) then
			write('El empleado ya existe.')
}
			
		else begin
			Seek(archivo, FileSize(archivo));
			write(archivo, empleado);
		end;
		leerEmpleado(empleado);
	end;
	
	close(archivo);
End;

{__________________MODIFICAR EDAD__________________}
Procedure modificarEdad(var archivo: file_empleados);
	procedure editarEmpleado(var empleado: registro_empleado);
	begin
		write('Ingresar nueva edad del empleado: ');
		readln(empleado.edad);
	end;
	
Var
	n: integer;
	empleado: registro_empleado;
	encontre: boolean;
	
Begin
	encontre:= false;
	reset(archivo);
	
	write('Ingresar número de empleado a editar ("0" para finalizar): ');
	readln(n);
	while (n <> 0) do begin
		Seek(archivo,0);
		
		while (not eof (archivo) and not(encontre)) do begin
			read(archivo, empleado);
			
			if (empleado.nro_empleado = n) then begin
				encontre:= true;
				editarEmpleado(empleado);
				Seek(archivo,(FilePos(archivo)-1));
				write(archivo, empleado);
			end;
		end;
		
		write('Ingresar número de empleado a editar ("0" para finalizar): ');
		readln(n);	
	end;
	
	close(archivo);
End;

{__________________EXPORTAR EMPLEADOS A TXT__________________}
Procedure exportarAtxt(var archivo_empelados: file_empleados);
Var
	archivo_txt: Text;	//creación de la variable del archivo .txt
	empleado: registro_empleado;
	
Begin
	reset(archivo_empelados);
	
	assign(archivo_txt, 'todos_empleados.txt'); //enlazamos la variable con el nombre que contendrá el archivo
	rewrite(archivo_txt); //creamos el archivo nuevo
	
	while (not eof(archivo_empelados)) do begin
		read(archivo_empelados, empleado);
		
		//escribo el nuevo archivo con un salto de línea y dejando espacios entre cada campo
		writeln(archivo_txt, ' ', empleado.nro_empleado,' ', empleado.apellido,' ', empleado.nombre,' ', empleado.edad, ' ', empleado.dni);
	end;
	
	close(archivo_empelados);
	close(archivo_txt);
	
End;

{__________________EXPORTAR EMPLEADOS SIN DNI__________________}


Procedure exportarAtxtSinDni(var archivo_empelados: file_empleados);
Var
	empleado: registro_empleado;
	archivo_txt: Text;
	
Begin
	reset(archivo_empelados);
	
	assign(archivo_txt, 'faltaDNIEmpleado.txt');
	rewrite(archivo_txt);
	
	while (not eof(archivo_empelados)) do begin
		read(archivo_empelados, empleado);
		
		if (empleado.dni = 00) then
			writeln(archivo_txt, ' ', empleado.nro_empleado,' ', empleado.apellido,' ', empleado.nombre,' ', empleado.edad, ' ', empleado.dni);
		
	end;
	
	close(archivo_empelados);
	close(archivo_txt);
End;


{__________________P.P__________________}
VAR
	empleados: file_empleados;
	opcion: opciones;

BEGIN
	writeln('Opciones');
	writeln('a. Crear archivo de registros de empleado.');
	writeln('b. Listar determinados empleados.');
	writeln('c. Listar todos los empleados uno por línea.');
	writeln('d. Listar empleados pronto a jubilarse.');
	writeln('e. Agregar Empleados.');
	writeln('f. Modificar edad.');	
	writeln('g. Exportar todos los empleados a "todos_empleados.txt".');
	writeln('h. Exportar empleados a "faltaDNIEmpleado.txt" los que no tengan cargado su DNI.');
	writeln('i. Salir.');
	writeln('');
	
	write('Ingresar opción: ');
	readln(opcion);
	
	while (opcion <> 'i') do begin
		case opcion of
			'a': crearArchivo(empleados);
			'b': listarDeterminadosEmpleados(empleados);
			'c': listarTodos(empleados);			
			'd': listarJubilados(empleados);
			
			'e': agregarEmpleados(empleados);
			'f': modificarEdad(empleados);
			'g': exportarAtxt(empleados);
			'h': exportarAtxtSinDni(empleados);
		end;
		
		write('Ingresar opción: ');
		readln(opcion);
		writeln('');
	end;
		
END.
