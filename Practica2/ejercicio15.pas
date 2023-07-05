{15. Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua,# viviendas sin sanitarios.
Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.
Para la actualización se debe proceder de la siguiente manera:
1. Al valor de vivienda con luz se le resta el valor recibido en el detalle.
2. Idem para viviendas con agua, gas y entrega de sanitarios.
3. A las viviendas de chapa se le resta el valor recibido de viviendas construidas
La misma combinación de provincia y localidad aparecen a lo sumo una única vez.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).}

PROGRAM ejercicio15

CONST
	VALOR_ALTO = 9999;
	MAX_detalles = 10;

TYPE
	str20: string[20];
	rng_detalles: 1..MAX_detalles;
	
	reg_maestro = record
		codProvincia: integer;
		nombreProvincia: str20;
		codLocalidad: integer;
		nombreLocalidad: str20;
		casasSinLuz: integer;
		casasSinGas: integer;
		casasSinGhapa: integer;
		casasSinAgua: integer;
		casasSinSanitario: integer;
	end;
	
	reg_provincia = record
		codProvincia: integer;
		codLocalidad: integer;
		casasConLuz: integer;
		casasConGas: integer;
		casasConstruidas: integer;
		casasConAgua: integer;
		casasConSanitario: integer;
	end;
	
	archivo_maestro = file of reg_maestro;
	
	archivo_detalle = file of reg_provincia;
	
	vector_detalles = array [rng_detalles] of archivo_detalle;

	vector_provincias = array [rng_detalles] of reg_provincia;
	
Procedure leer(var a: archivo_detalle; r: reg_provincia);
Begin
	if (not eof(a))
		read(a, r);
	else
		r.codProvincia:= VALOR_ALTO;
End;

Procedure minimo(var detalles: vector_detalles; var provincias: vector_provincias; regMin: reg_provincia);
Begin
	regMin.codProvincia:= VALOR_ALTO;
	for i:= 1 to MAX_detalles do begin;
		if (provincias[i].codProvincia < regMin.codProvincia) and (provincia[i].codLocalidad < regMin.codLocalidad) then begin
			regMin:= provincias[i];
			minPos:= i;
		end;
	end;
	
	if (regMin.codProvincia <> VALOR_ALTO) then
		leer(detalles[minPos], provincias[minPos]);
End;

//____________________________actualizarArchivo____________________________
Procedure actualizarArchivo(var maestro: archivo_maestro; var detalles: vector_detalles);
Var
	provincias: vector_provincias;
	
	provincia: reg_maestro;
	
	minProvincia: reg_provincia;
	
Begin
	reset(maestro);
	for i:= 1 to MAX_detalles do begin
		Str(i, str);
		assign(detalles[i], 'detalle'+str);
		reset(detalles[i])
		leer(detalles[i], provincias[i]);
	end;
	
	minimo(detalles, provincias);
	
	while (provincia.codProvincia <> VALOR_ALTO) do begin
		
		while(provincia.codProvincia <> minProvincia.codProvincia) and (provincia.codLocalidad <> minProvincia.codLocalidad) do begin
			read(maestro, provincia);
		end;
		
		//voy actualizando la información del registro del maestro con la de los detalles.
		while(provincia.codProvincia = minProvincia.codProvincia) and (provincia.codLocalidad = minProvincia.codLocalidad) do begin
			provincia.casasSinLuz:= provincia.casasSinLuz - minProvincia.casasConLuz;
			provincia.casasSinAgua:= provincia.casasSinAgua - minProvincia.casasConAgua;
			provincia.casasSinGas:= provincia.casasSinGas - minProvincia.casasConGas;
			provincia.casasSinSanitario:= provincia.casasSinSanitario - minProvincia.casasConSanitario;
			provincia.casasSinGhapa:= provincia.casasSinGhapa - minProvincia.casasConstruidas;
			
			minimo(detalles, provincias);
		end;
		
		totalSinChapa:= totalSinChapa + provincia.casasSinGhapa;
			
	end;
	
	close(maestro);
	for i:= 1 to MAX_detalles do 
		close(detalles[i]);
	
End;
	
//____________________________P.P____________________________
VAR
	maestro: archivo_maestro;
	detalles: vector_detalles;
BEGIN
	assign (maestro, 'archivoDeLaOng');
	actualizarArchivo(maestro, detalles)
END.