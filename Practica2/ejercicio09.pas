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

TYPE
	registro_archivo = record
		codProvincia: integer;
		codLocalidad: integer;
		nroMesa: integer;
		cantVotos: integer;
	end;
	
	archivo = file of registro_archivo;
	
	

VAR
	arch: archivo;
	registro: registro_archivo;
	
BEGIN
	assign(arch, 'archivo');
	reset(arch);
	
	while

END.
