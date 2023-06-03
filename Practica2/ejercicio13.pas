PROGRAM ejercicio13;
CONST

TYPE
	str50 = string[50];

	registro_maestro = record
		nroUsuario: integer;
		nombreUsuario: str50;
		nombre: str50;
		apellido: str50;
		email str50;
		cantMailsEnviados: integer;
	end;
	
	registro_detalle = record
		nroUsuario: integer;
		cuentaDestino: str50;
		cuerpoMensaje: str50;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle = file of registro_detalle;
//_________________________Leer_________________________
Procedure leer(var archivo: archivo_detalle; var registro: registro_detalle);
Begin
	if (not eof (archivo)) then
		read(archivo, registro)
	else
		registro.nroUsuario:= VALOR_ALTO;
End

//_________________________Actualizar Maestro_________________________
	
Procedure actualizarMaestro(var maestro:archivo_maestro; var detalle: archivo_detalle);
Var
	regMaestro: registro_maestro;
	
	regDetalle: registro_detalle;
	
	cantMailsPorDia: integer;
	
Begin
	assign(maestro, 'Correos enviados');
	rewrite(maestro);
	
	assign(detalle, '/var/log/logmail.dat');
	reset(detalle);
	
	leer(detalle, regDetalle);
	
	while regDetalle.nroUsuario <> VALOR_ALTO do begin
		read(maestro, regMaestro);
		
		while (regDetalle.nroUsuario <> regMaestro.nroUsuario) do
			read(maestro, regMaestro);
		
		while (regDetalle.nroUsuario = regMaestro.nroUsuario) do begin
			cantMailsPorDia:= cantMailsPorDia + 1;
			leer(detalle,regDetalle);
		end;
		
		regMaestro.cantMailsEnviados:= regMaestro.cantMailsEnviados + cantMailsPorDia;
		
		seek(maestro, filePos(maestro)-1);
		
		write(maestro, regMaestro);
	end;
	
	close(maestro);
	close(detalle);
End;
//_________________________Genrar Texto_________________________
Procedure generarTxt(var detalle: archivo_maestro);
Var
	regDetalle: registro_detalle;
	
	nroUsuarioAct: integer;
	
	cantMensajes: integer;
	
	txt: Text;
Begin
	reset(maestro);
	
	assign(txt, 'Informe Detalle');
	rewrite(txt);
	
	while (regDetalle.nroUsuario <> VALOR_ALTO) do begin
		cantMensajes:= 0;
		nroUsuarioAct:= regDetalle.nroUsuario;
		
		while (nroUsuarioAct = regDetalle.nroUsuario) do begin
			cantMensajes:= cantMensajes + 1;
			leer(detalle, regDetalle);
		end;
		
		write(txt, nroUsuarioAct);
		writeln(txt, cantMensajes);
	end;
	
	close(detalle);
	close(txt);
		
End;

//_________________________P.P_________________________
VAR
	maestro: archivo_maestro;
	detalle: archivo_detalle;
	
BEGIN
	
	actualizarMaestro(maestro, detalle);
	generarTxt(detalle);
	
END.
