{
4. Dada la siguiente estructura:
type
	reg_flor = record
		nombre: String[45];
		codigo:integer;
	tArchFlores = file of reg_flor;
	
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

	a. Implemente el siguiente módulo:
		//Abre el archivo y agrega una flor, recibida
		//manteniendo la política descripta anteriormente
		procedure agregarFlor (var a: tArchFlores; nombre: string; codigo: integer);
	
	b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
	considere necesario para obtener el listado.

5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
	//Abre el archivo y elimina la flor recibida como parámetro manteniendo
	//la política descripta anteriormente
	procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
}
Program ejercicio04;

CONST
	VALOR_ALTO = 9999;
type
	str45 = String[45];
	
	reg_flor = record
		nombre: str45;
		codigo: integer;
	end;
	
	tArchFlores = file of reg_flor;

{_____________________________________Leer Archivo_____________________________________}
Procedure leerArchivo(var a: tArchFlores var r: reg_flor);
Begin
	if (not eof(a)) then
		read(a, r);
	else
		r.codigo:= VALOR_ALTO;
End.

{_____________________________________Eliminar Flor_____________________________________}
Procedure eliminarFlor(var a :tArchFlores; flor: reg_flor);
Var
	florAux, regAux: reg_flor;
Begin
	reset(a);
	
	read(a, regAux);	//leo el registro cabecera
	leerArchivo(a, florAux);	//leo primer registro si hay
	while(florAux.codigo <> VALOR_ALTO) and (florAux.codigo <> flor.codigo) do
		leerArchivo(a, florAux);
		
	if (florAux.codigo = flor.codigo) then begin
		florAux.codigo:= regAux.codigo		//piso el código de flor con el índice de la anterior eliminada.
		seek(a, filePos(a)-1);	//me posiciono en la flor recientemente eliminada.
		regAux.codigo:= (filePos(a))*-1		//almaceno en la cabecera, la posición de la flor recientemente eliminada.
		write(a, florAux);
		seek(a, 0);
		write(a, regAux);
	end;
	
	close(a);
End;


{_____________________________________Agregar Flor_____________________________________}
Procedure agregarFlor (var a: tArchFlores; nombre string; codigo: integer);
Var
	flor, regAux: reg_flor;
	
Begin
	reset(a);
	read(a,regAux);		//leo cabecera
	
	flor.codigo:= codigo;
	flor.nombre:= nombre;
	
	if (regAux.codigo < 0) then begin
		seek(a, regAux.codigo*-1); 		//me posiciono en el último registro vacío.
		read(a, regAux);		//leo el contenido del registro vacío.
		seek(a, filePos(a)-1);
		write(a, flor);
		seek(a, 0);
		write(a, regAux);		//actualizo cabecero 
	end;
	else begin
		seek(a, fileSize(a));
		write(a, flor);
	end;
	close(a);
End.


{_____________________________________Imprimir_____________________________________}
Procedure imprimir(var a: tArchFlores);
Var
	flor: reg_flor;
	
Begin
	reset(archivo);
	
	seek(a, 1);
	
	leerArchivo(a, flor);
	while (flor.codigo <> VALOR_ALTO) do begin
		write(flor.nombre, ' ');
		wrtieln(flor.codigo, ' ');
		leerArchivo(a, flor);
	end;
	
	close(archivo);
End;

	
{_____________________________________P.P_____________________________________}
VAR
	archivo: tArchFlores;
	nombre: str45;
	codigo: integer;
	flor: reg_flor;
BEGIN
	assign(archivo, 'archivo_flores');
	
	Write('Nombre de Flor: ');
	readln(nombre);
	write('Codigo de Flor: ');
	readln(codigo);
	agregarFlor(archivo, nombre, codigo)
	
	flor.nombre:= nombre;
	flor.codigo:= codigo;
	eliminarFlor(archivo, flor);
	
	imprimir(archivo);
END.