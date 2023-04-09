{
9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:

	Código de Provincia
	Código de Localidad			Total de Votos
	....................		.......................
	....................		......................
	Total de Votos Provincia: ____
	
	Código de Provincia
	Código de Localidad			Total de Votos
	....................		.......................
	....................		......................
	Total de Votos Provincia: ____
	
	....................................................................
	Total General de Votos: ___
	
NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.
}

PROGRAM ejercicio09;
CONST 
	VALOR_ALTO = 9999;

TYPE
	registro_archivo = record
		codProvincia: integer;
		codLocalidad: integer;
		nroMesa: integer;
		cantVotos: integer;
	end;
	
	file_archivo = file of registro_archivo;
	
	
Procedure leer(var a: file_archivo; var r: registro_archivo);
Begin
	if (not eof(a)) then
		read(a, r)
	else
		r.codProvincia:= VALOR_ALTO;
End;

VAR
	archivo: file_archivo;
	registro: registro_archivo;
	
	registroAux: registro_archivo;
	
	cantVotosLocalidad: integer;
	cantVotosProvincia: integer;
	cantVotosTotal: integer;
	
BEGIN
	assign(archivo, 'archivo');
	reset(archivo);
	
	leer(archivo, registro);
	
	cantVotosTotal:= 0;
	while (not eof(archivo)) do begin
		registroAux:= registro;	//actualizo el registro auxiliar con el registro leido.
		cantVotosProvincia:= 0;
		
		//compruebo si sigo en la misma provincia.
		while (registro.codProvincia = registroAux.codProvincia) do begin		
			registroAux.codLocalidad:= registro.codLocalidad;		//si cambié de localidad actualizo la nueva localidad.
			cantVotosLocalidad:= 0;
		
			//compruebo si sigo en la misma provincia y en la misma localidad
			while (registro.codProvincia = registroAux.codProvincia) and (registro.codLocalidad = registroAux.codLocalidad) do begin
				cantVotosLocalidad:= cantVotosLocalidad + registroAux.cantVotos;
				leer(archivo, registro);
			end;
			
			writeln('Localidad: ', registroAux.codLocalidad);
			writeln('Votos: ', cantVotosLocalidad);
			
			cantVotosProvincia:= cantVotosProvincia + cantVotosLocalidad;
		end;
		
		writeln('Provincia: ', registroAux.codProvincia);
		writeln('Votos: ', cantVotosProvincia);
		
		cantVotosTotal:= cantVotosTotal + cantVotosProvincia;
	end;
	
	writeln('Total: ', cantVotosTotal);
	
	close(archivo);
END.
