{
11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}

PROGRAM ejercicio11;

CONST
	VALOR_ALTO = 'ZZZ';
	
TYPE
	registro_maestro = record
		nombreProvincia: str50;
		cantAlfabetizados: integer;
		totalEncuestados: integer;
	end;
	registro_detalle = record
		nombreProvincia: str50;
		codLocalidad: integer;
		cantAlfabetizados: integer;
		cantEncuestados: integer;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle = file of registro_detalle;
	
//_________________________Leer_________________________	
Procedure leer(var detalle: archivo_detalle; var registro: registro_detalle);
Begin
	if (not eof (detalle)) then
		read(detalle, registro)
	else
		registro.nombreProvincia:= VALOR_ALTO;
End;

//_________________________Minimo_________________________
Procedure minimo(var d1, d2: archivo_detalle; var r1, r2, min: registro_detalle);
Begin
	
	if (r1.nombreProvincia <= r2.nombreProvincia) then begin
		min:= r1;
		leer(d1, r1);
	end;
	else 
		if (r2.nombreProvincia <= r1.nombreProvincia) then begin
			min:= r2;
			leer(d2, r2);
		end;
End;
		
//_________________________P.P_________________________		
VAR
	maestro: archivo_maestro;
	detalle1: archivo_detalle;
	detalle2: archivo_detalle;
	
	
	regMaestro: registro_maestro;
	
	regDetalle1: registro_detalle;
	regDetalle2: registro_detalle;
	regMin: registro_detalle;
	
BEGIN
	assign(maestro, 'maestro');
	reset(maestro);
	
	assign(detalle1. 'detalle1');
	reset(detalle1);
	leer(detalle1, regDetalle1);
	assign(detalle2. 'detalle2');
	reset(detalle2);
	leer(detalle2, regDetalle2);
	
	minimo(detalle1, detalle2, regDetalle1, regDetalle2 regMin);
	
	while (regMin.nombreProvincia <> VALOR_ALTO) do begin
		read(maestro, regMaestro);
		
		while (regMin.nombreProvincia <> regMaestro.nombreProvincia) do
			read(maestro, regMaestro);
		
		while (regMin.nombreProvincia = regMaestro.nombreProvincia) do begin
			regMaestro.cantAlfabetizados:= regMaestro.cantAlfabetizados - regMin.cantAlfabetizados;
			minimo(detalle1, detalle2, regDetalle1, regDetalle2 regMin);
		end;
		
		seek(maestro, filePos(maestro)-1);
		write(maestro, regMaestro);
		
	end;
	
	close(maestro);
	close(detalle1);
	close(detalle2);

END
