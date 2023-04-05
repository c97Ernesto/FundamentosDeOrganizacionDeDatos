{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}
PROGRAM ejercicio01;

TYPE
	registro_empleado: record
		codEmpleado: integer;
		nombre: str50;
		comision: str50;
	end;
	
	//información del archivo ordenada codEmpleado y el empleado se puede repetir.
	archivo_empleados: file of registro_empleado;

Procedure compactarArchivo(var archivo: archivo_empleados);
Var		
	nuevoArchivo: archivo_empleado;
	empleado: registro_empleado;
	empleadoNuevo: registro_empleado;
	
Begin
	
	reset(archivo);
	
	rewrite(nuevoArchivo);
	
	read(archivo, empleado);
	
	while (not eof(archivo)) do begin	
		empleadoNuevo.codEmpleado:= empleado.codEmpleado;
		
		while (not eof(archivo) and (empleado.codEmpleado = empleadoNuevo.codEmpleado)) do begin
			empleadoNuevo.comision:= empleadoNuevo.comision + empleado.comision
			read(archivo, empleado);
		end;
		
		write(archivoNuevo, empleadoAnterior);
	end;
	
	close(archivo);
	close(archivoNuevo);
	
End;


VAR
	archivo: archivo_empleados;
	
BEGIN
	write('Ingresar nombre del archivo de Empleados: ');
	readln(nombreArchivoEmpleados);
	
	assign(archivo, nombreArchivoEmpleados);
	
	compactarArchivo(archivo)
END.
	
	
