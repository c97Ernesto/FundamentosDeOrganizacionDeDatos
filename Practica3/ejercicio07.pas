{7.Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}


PROGRAM ejercicio_7;
CONST
	VALOR_ALTO = 9999;
	BORRADO = '##';
TYPE
	
	reg_ave = record
		codigo: integer;
		nombre: str50;
		familia: str50;
		descripcion: string;
		zona: string;
	end;
	
	archivo_aves = file of reg_ave;
	
//____________________________Marcar____________________________
Procedure marcarRegistros(var archivo: archivo_aves);
Var
	ave: reg_ave;
	
	nombre: str50;
	
	marcado: boolean;
	
Begin
	reset(archivo);
	
	write('Ingresar nombre de ave a eliminar: ');
	readln(nombre)
	
	marcado:= false;
	
	leer(archivo, ave)
	while (archivo.codigo <> VALOR_ALTO) and (not marcado) do begin
		if (nombre = ave.nombre) then begin
			ave.nombre:= BORRADO;
			marcado:= true;
			seek(archivo, filePos(archivo)-1);
			write(archivo, ave);
		end
		else
			leer(archivo, ave);
	end;
	
	if (marcado) then
		writeln('El ave fue eliminada.');
	else
		writeln('No hay ave con ese nombre.')
	
	close(archivo);
End;

//____________________________Compactar____________________________
Procedure compactarArchivo(var archivo: archivo_aves);
Var

Begin

End;


	//____________________________P.P____________________________
VAR

BEGIN

END.