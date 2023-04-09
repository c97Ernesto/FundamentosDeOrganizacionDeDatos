{
4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

PROGRAM ejercicio04;
CONST
	MAXdetalles = 5;
	VALOR_ALTO = 9999;
	
TYPE
	rango_detalles = 1..MAXdetalles;
	str20 = string[20];
	
	registro_maestro = record
		codUsuario: integer;
		fecha: str20;
		tiempoTotalDeSesiones: integer;
	end;
	
	registro_detalle = record
		codUsuario: integer;
		fecha: str20;
		tiempoDeSesion: integer;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle = file of registro_detalle;
	
	vector_detalles = array [rango_detalles] of archivo_detalle;
	vector_registrosDetalles = array [rango_detalles] of registro_detalle;
	
//____________________________Leer____________________________
Procedure leer(var archivo: archivo_detalle; registro: registro_detalle);
Begin
	if (not eof(archivo)) then
		read(archivo, registro)
	else
		registro.codUsuario:= VALOR_ALTO;
End;
	
//____________________________Mínimo____________________________
Procedure minimo(var vD: vector_detalles; vR: vector_registrosDetalles; var minReg: registro_detalle);
Var
	i: rango_detalles;
	minPos: rango_detalles;
	
Begin
	minReg.codUsuario:= VALOR_ALTO;
	
	for i:= 1 to MAXdetalles do begin
		if (vR[i].codUsuario < minReg.codUsuario) then begin
			minReg:= vR[i];
			minPos:= i;
		end;
	end;
	
	if (minReg.codUsuario <> VALOR_ALTO) then
		leer(vD[minPos], vR[minPos]);
End;
	
VAR
	i: rango_detalles;
	maestro: archivo_maestro;
	regMaestro: registro_maestro;
	
	vecDetalles: vector_detalles;
	vecRegistros: vector_registrosDetalles;
	minRegistro: registro_detalle;
	
BEGIN
	assign(maestro, 'var/log/maestro');
	rewrite(maestro);

	for i:= 1 to MAXdetalles do begin
		assign(vecDetalles[i], 'Detalle '+ i);
		reset(vecDetalles[i]);
		leer(vecDetalles[i], vecRegistros[i]);
	end;
	
	minimo(vecDetalles, vecRegistros, minRegistro);
	
	while (minRegistro.codUsuario <> VALOR_ALTO) do begin
		//actualizo los campos del nuevo registro maestro
		regMaestro.codUsuario:= minRegistro.codUsuario;
		regMaestro.fecha:= minRegistro.fecha;
		regMaestro.tiempoTotalDeSesiones:= 0;
		
		//proceso todos los registros detalles del mismo usuario que van a acumular en un registro del archivo maestro.
		while (regMaestro.codUsuario = minRegistro.codUsuario) do begin
			regMaestro.tiempoTotalDeSesiones:= regMaestro.tiempoTotalDeSesiones + minRegistro.tiempoDeSesion;
			minimo(vecDetalles, vecRegistros, minRegistro);
		end;
		
		write(maestro, regMaestro);
			
	end;
	
	close(maestro);
	for i:= 1 to MAXdetalles do 
		close(vecDetalles[i]);
END.
