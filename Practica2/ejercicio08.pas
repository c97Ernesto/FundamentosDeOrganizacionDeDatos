{
8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras.
}
PROGRAM ejercicio08;
CONST
	VALOR_ALTO = 9999;

TYPE
	
	rng_meses: 1..12;
	rng_dias: 1..31;
	rng_anios: 2000..2100;
	
	reg_maestro = record
		codCliente: integer;
		nombre: str20;
		apellido: str20;
		anio: rng_anios;
		mes: rng_meses;
		dia: rng_dias;
		monto: real;
	end;
	
	archivo_maestro = file of reg_maestro;
//____________________________Leer____________________________	
Procedure leer(var a: archivo_maestro; var r: reg_maestro);
Begin
	if (not eof(a)) then
		read(a, r);
	else
		a.codCliente:= VALOR_ALTO;
End
	
//____________________________Generar Reporte____________________________	
Procedure generarReporte (var archivo: archivo_maestro);
Var

Begin
	reset(archivo);
	
	leer(archivo, cliente);
	
	while (cliente.codCliente <> VALOR_ALTO) do begin
		clienteActual:= cliente;
		
		while (cliente.codCliente = codActual) do begin
			anioActual:= cliente.anio;
			totalAnio:= 0;
			
			while (cliente.codCliente = codActual) and (cliente.anio = anioActual) do begin
				mesActual:= cliente.mes;
				totalMes:= 0;
				
				writeln('Codigo cliente: ' + codActual + ' - Nombre:  ' + cliente.nombre + ' - Apellido:  ' + cliente.apellido);
				while (cliente.codCliente = codActual) and (cliente.anio = anioActual) and (cliente.mes = mesActual) do begin
					totalMes:= totalMes + cliente.monto;
					leer(archivo, cliente);
				
				writeln('El total del cliente en el mes '+ cliente.mesActual + ' fue de: '+ totalMes);
				
				totalAnio:= totalAnio + totalMes;
			end;
			
			writeln('El total del cliente en el año ' + anioActual + ' fue de: '+ totalAnio);
			totalCliente:= totalCliente + totalAnio;
		end;
		
		writeln('El total del cliente' + cliente.codActual + ' fue de: ' + totalCliente);
		totalEmpresa:= totalEmpresa + totalCliente;
		
	end;
	
	writeln('El total de la empresa fue de: '+ totalEmpresa);
	
	close(archivo);
End;
	
//____________________________P.P____________________________
VAR
	maestro: archivo_maestro;
BEGIN
	assign(maestro, 'reporteCliente');
	
	generarReporte(maestro);
END.

