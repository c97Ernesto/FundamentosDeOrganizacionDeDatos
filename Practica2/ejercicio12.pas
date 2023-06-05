{
12. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de
la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y
tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado por los
siguientes criterios: año, mes, dia e idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:
Año : ---
    Mes:-- 1
        día:-- 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 1
            --------
            idUsuario N Tiempo total de acceso en el dia 1 mes 1
        Tiempo total acceso dia 1 mes 1
    -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 1
            --------
            idUsuario N Tiempo total de acceso en el dia N mes 1
        Tiempo total acceso dia N mes 1
    Total tiempo de acceso mes 1
    ------
    Mes 12
        día 1
            idUsuario 1 Tiempo Total de acceso en el dia 1 mes 12
            --------
            idUsuario N Tiempo total de acceso en el dia 1 mes 12
        Tiempo total acceso dia 1 mes 12
    -------------
        día N
            idUsuario 1 Tiempo Total de acceso en el dia N mes 12
            --------
            idUsuario N Tiempo total de acceso en el dia N mes 12
        Tiempo total acceso dia N mes 12
    Total tiempo de acceso mes 12
Total tiempo de acceso año

Se deberá tener en cuenta las siguientes aclaraciones:
- El año sobre el cual realizará el informe de accesos debe leerse desde teclado.
- El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
- Debe definir las estructuras de datos necesarias.
- El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.
}

PROGRAM ejercicio12;

CONST
	VALOR_ALTO = 99999;
	
TYPE
	str30 = string[30];
	
	anios = 2000..2100;
	meses = 1..12;
	dias = 1..31;
	
	registro_archivo = record
		anio: anios;
		mes: meses;
		dia: dias;
		idUsuario: integer;
		tiempoDeAcceso: real;
	end;
	
	archivo_accesos = file of registro_archivo;
	
Procedure leer(var a: archivo_accesos; r: registro_archivo);
Begin
	if (not (eof (a))) then
		read(a, r);
	else
		r.anio:= VALOR_ALTO;
End;
	
VAR
	archivo: archivo_accesos;
	
	nombreArchivo: str30;
	
	registro: registro_archivo;
	
	anioActual: anios; 
	mesActual: meses; 
	diaActual: dias;
	idUsuarioActual: integer;
	
	tiempoAnio, tiempoMes, tiempoDia:, tiempoUsuario: real;
	
	anio: integer;
BEGIN
	write('Ingresar nombre del archivo: ');
	readln(nombreArchivo);
	assign(archivo, nombreArchivo);
	reset(archivo);
	
	write('Ingrese año: ');
	readln(anio):
	
	leer(archivo, registro);
	
	while  (registro.anio <> VALOR_ALTO) and (registro.anio <> anio) then
		leer(archivo, registro);
	end;
	
	if (registro.anio = anio) then begin
		anioActual = anio;
		tiempoAnio:= 0;
		
		while (registro.anio = anioActual) do begin
			mesActual = registro.mes
			tiempoMes:= 0;
			
			while (registro.mes = registroAux.mes) and (registro.anio = anioActual) do begin
				//recorre los días del mes
				diaActual:= registro.dia;
				tiempoDia:= 0;
				
				while (registro.dia = diaActual) and (registro.mes = mesActual) and (registro.anio = anioActual) do begin
					//recorro los usuarios que han accedido un determinado día.
					idUsuarioActual:= registro.idUsuario;
					tiempoUsuario:= 0;
					
					while (registro.idUsuario = idUsuarioActual) and (registro.dia = diaActual) and (registro.mes = mesActual) and (registro.anio = anioActual) do begin
						//recorro los tiempos de acceso de un mismo usuario.
						tiempoUsuario:= tiempoUsuario + registro.tiempoDeAcceso;
						leer(archivo, registro);
					end;
					
					writeln('idUsuario ', idUsuarioActual, ' Tiempo total de acceso en el día ', diaActual, ' mes', mesActual);
					writeln('	', tiempoUsuario:2:2);
					tiempoDia:= tiempoDia + tiempoUsuario;
				end;
				
				writeln('Tiempo total de acceso en el día ', diaActual, ' mes', mesActual);
				writeln('	', tiempoDia:2:2);
				
				tiempoMes:= tiempoMes + tiempoDia;
			end;
			
			writeln('Tiempo total de acceso en el mes ', mesActual, ' ', tiempoMes:2:2);
			tiempoAnio:= tiempoAnio + tiempoMes;
		end;
		
		writeln('Tiempo total de acceso en el año: ', tiempoAnio:2:2);
	end
	else
		writeln('No existe el año ingresado.');
		
	close (archivo);
END.
