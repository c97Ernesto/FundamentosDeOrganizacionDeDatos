PROGRAM ejercicio18;

CONST


TYPE
	reg_archivo = record
		codLocalidad: integer;
		nombreLocalidad: str50;
		codMunicipio: integer;
		nombreMunicipio: str50;
		codHospital: integer;
		nombreHospital: str50;
		fecha: str10;
		casosPositivos: integer;	
	end;
	
	archivo_maestro = file of reg_archivo;
	
Procedure listarArchivo_GenerarTxt(var archivo: archivo_maestro; var txt: Text);
Var
	registro, registroAuxiliar: reg_archivo;
	
	casosHospital, casosMunicipio, casosLocalidad, casosProvincia: integer;
	
Begin
	reset(archivo);
	
	casosProvincia:= 0;
	leer(archivo, registro)
	while(registro.codLocalidad <> VALOR_ALTO) do begin
		registroAuxiliar.codLocalidad:= registro.codLocalidad;
		registroAuxiliar.nombreLocalidad:= registro.nombreLocalidad;
		
		writeln('Localidad: '+ registroAuxiliar.nombreLocalidad);
		
		casosLocalidad:= 0;
		
		while (registro.codLocalidad = registroAuxiliar.codLocalidad) do begin
			registroAuxiliar.codMunicipio:= registro.codMunicipio;
			registroAuxiliar.nombreMunicipio:= registro.nombreMunicipio;
			
			writeln('Municipio: '+ registroAuxiliar.nombreMunicipio);
			
			casosMunicipio:= 0;
		
			while (registro.codLocalidad = registroAuxiliar.codLocalidad) and (registro.codMunicipio = registroAuxiliar.casosMunicipio) do begin
				registroAuxiliar.codHospital:= registro.codHospital;
				registroAuxiliar.nombreHospital:= registro.nombreHospital;
				
				writeln('Hospital: '+ registroAuxiliar.nombreHospital);	
				
				casosHospital:= 0;
			
				while (registro.codLocalidad = registroAuxiliar.codLocalidad) and (registro.codMunicipio = registroAuxiliar.casosMunicipio) and (registro.codHospital = registroAuxiliar.codHospital) do begin				
					casosHospital:= casosHospital + registro.casosPositivos;			
					
					leer(archivo, registro);
					
				end;
				writeln('Cantidad de casos en el hospital' + registroAuxiliar.nombreHospital + ': ' casosHospital);
				
				casosMunicipio:= casosMunicipio + casosHospital;
				
			end;
			writeln('Cantidad de casos en el Municipio' + registroAuxiliar.nombreMunicipio + ': ' casosMunicipio);
			
			if (casosMunicipio > 1500) then begin
				write(txt, registroAuxiliar.nombreLocalidad);
				write(txt, casosMunicipio, registroAuxiliar.nombreMunicipio);
			end;
			
			casosLocalidad:= casosLocalidad + casosMunicipio;
		end;
		writeln('Cantidad de casos en la Localidad' + registroAuxiliar.nombreLocalidad + ': ' casosLocalidad);
		
		casosProvincia:= casosProvincia + casosLocalidad;
	end;
	writeln('Cantidad de casos en la Provincia: ' casosProvincia);
	
	close(archivo)
	
End;

VAR
	archivo: archivo_maestro;
	texto: Txt;
BEGIN
	assign(archivo, 'archivoProvinciaBinario');
	assign(txt, 'archivoProvinciaTxt.txt');
	listarArchivo_GenerarTxt(archivo, texto);
END.