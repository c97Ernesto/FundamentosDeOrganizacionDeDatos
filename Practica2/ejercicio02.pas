{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
	a. Actualizar el archivo maestro de la siguiente manera:
		i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
		ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
		final.
	b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
	con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.}

PROGRAM ejercicio_02

CONST


TYPE
	reg_alumno = record		//registro maestro
		codigo: integer;
		apellido: str20;
		nombre: str20;
		aprobadas: integer;
		aprobadasConFinal: integer;
	end;
	
	reg_materia = record		//registro detalle
		codAlumno: integer;
		aprobada: boolean;
		aprobadaConFinal: boolean;
	end;
	
	archivo_alumnos = file of reg_alumno;	//archivo maestro
	
	archivo_materias = file of reg_materia;		//archivo detalle
	
Procedure actualizarMaestro(var maestro: archivo_alumnos; var detalle: archivo_materias);
Var

Begin
		
End;
	
VAR

BEGIN
	assign(maestro, 'alumnos');
	assign(detalle, 'materias');
	
	actualizarMaestro(maestro, detalle);

END.