{6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

PROGRAM ejercicio_6;

CONST
	VALOR_ALTO = 9999;
	MAX_detalles = 10;
TYPE
	rango_detalles = 1..MAX_detalles;

	reg_localidad = record
		codLocalidad: integer;
		codCepa: integer;
		activos: integer;
		nuevos: integer;
		recuperados: integer;
		fallecidos: integer;
	end;
	
	//ordenado por localidad y cepa
	//archivo que contiene las localidades
	archivo_maestro = file of reg_localidad;
	
	//archivo que contiene las localidades
	archivo_municipio = file of reg_localidad;
	
	//vector de los archivos de cada municipio
	vector_municipios = array [rango_detalles] of archivo_municipio;
	
	vector_localidades = array [rango_detalles] of reg_localidad;
	
	
//____________________________Leer____________________________
Procedure leerArchivo(var a: archivo_municipio; var r: reg_localidad);
Begin
	if (eof (a)) then
		r.codLocalidad:= VALOR_ALTO;
	else
		read(a, r);
End;

//____________________________Mínimo____________________________
Procedure minimo(municipios: vector_municipios; localidades: vector_localidades; min: reg_localidad);
Var

Begin
	min.codLocalidad:= VALOR_ALTO;
	
	for (i:= 1 to MAX_detalles) do
		if (localidades[i].codLocalidad < min.codLocalidad) then begin
			min:= localidades[i];
			minPos:= i;
		end;
			
	if (min.codLocalidad <> VALOR_ALTO) then 
		leerArchivo(vector_municipios[minPos], localidades[minPos])
	
End;
	
//____________________________Actualizar____________________________
Procedure actualizarMaestro(var maestro: archivo_maestro; var municipios: vector_municipios);
Var
	localidades: vector_localidades;
	
	localidad: reg_localidad;
	
	minLocalidad: reg_localidad;
	
	i: rango_detalles;
	
	srt: string;
	
	localidadesConMasDe50: integer;
Begin
	reset(maestro);
	
	for i:= 1 to MAX_detalles do begin
		Str(i,str);
		assign(municipios[i], 'detalle' + str);
		reset(municipios[i]);
		leer(municipios[i], localidades[i]);
	end;
	
	minimo(municipios, localidades, minLocalidad)
	
	while (minLocalidad.codLocalidad <> VALOR_ALTO) do begin
		
		//siempre va a haber un registro del detalle para uno del maestro
		while localidad.codLocalidad <> minLocalidad.codLocalidad do 
			read(maestro, localidad);	//busco la localidad en el maestro que concuerde con la localidad del municipio en el que estoy
		
		while (minLocalidad.codLocalidad = localidad.codLocalidad) do begin
			localidad.fallecidos:= localidad.fallecidos + minLocalidad.fallecidos;
			localidad.recuperados:= localidad.recuperados + minLocalidad.recuperados;
			localidad.activos:= minLocalidad.activos;
			localidad.hallados:= minLocalidad.hallados;
		
			minimo(municipios, localidades, minLocalidad);
		end;
		
		if (localidad.activos > 50) then
			localidadesConMasDe50:= localidadesConMasDe50 + 1;
			
		seek(maestro, filePos(maestro)-1);
		write(maestro, localidad);	
		
	end;
	
	close(maestro);
	for i:= 1 to MAX_detalles do
		close(municipios[i]);
		
	
	writeln('La cantidad de localidad con más de 5o casos activos fue de: ' + localidadesConMasDe50);

End;
	

//____________________________P.P____________________________
VAR
	maestro: archivo_maestro;
	detalles: vector_municipios;
	
BEGIN
	assign(maestro, 'ministerioSalud');
	
	actualizarMaestro(maestro, detalles);
END.
	
	
	
		