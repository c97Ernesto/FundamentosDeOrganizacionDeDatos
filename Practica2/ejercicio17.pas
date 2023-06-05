{17. Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con
información de las motos que posee a la venta. De cada moto se registra: código, nombre,
descripción, modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles
con información de las ventas de cada uno de los 10 empleados que trabajan. De cada
archivo detalle se dispone de la siguiente información: código de moto, precio y fecha de la
venta. Se debe realizar un proceso que actualice el stock del archivo maestro desde los
archivos detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.
}

PROGRAM ejercicio13;
CONST
	VALOR_ALTO = 9999;
	MAX_EMPLEADOS = 10;
	
TYPE
	rangoDetalles = 1..MAX_EMPLEADOS;
	str30 = string[30];

	registro_moto = record
		codigo: integer;
		nombre: str30;
		descripción: string;
		modelo: str30;
		marca: str30;
		stockActual: integer;
	end;
	
	registro_empleado = record
		codigoMoto: integer;
		precio: real;
		fechaVenta: str30;
	end;
	
	archivo_maestro = file of registro_moto;
	archivo_detalle = file of registro_empleado;
	
	vector_detalles = array [rangoDetalles] of archivo_detalle;
	vector_empleados = array [rangoDetalles] of registro_empleado
	
Procedure leer(var a: archivo_detalle, r: registro_empleado);
Begin
	if (a.codigoMoto <> VALOR_ALTO) then
		read(a, r);
	else
		r.codigoMoto:= VALOR_ALTO;
End;

Procedure minimo(var detalles: vector_detalles; empleados: vector_empleados; min: empleado);
Var
	i, minPos: rangoDetalles;
Begin
	
	min.codigoMoto:= VALOR_ALTO;
	
	for i:= 1 to MAX_EMPLEADOS do begin	
		if (empleados[i].codigoMoto < min.codigoMoto) then begin
			min:= empleado[i];
			minPos:= i;
		end;
	end;
	
	if (min.codigoMoto <> VALOR_ALTO) then
		leer(detalles[minPos], empleados[minPos]);
	
End;
	
Procedure actualizarArchivo(var maestro: archivo_maestro);
Var
	moto: registro_moto;
	
	detalles: vector_detalles;
	empleados: vector_empleados;
	empleadoMin: registro_empleado;
	
	cantVentas, maxVentas: integer;
	codMotoMasVendida: integer;
	
Begin
	reset(maestro);
	
	for i:= 1 to MAX_EMPLEADOS do begin
		Str (i,aString);
		assign(detalles[i], 'detalle', aString);
		reset(detalles[i]);
		leer(detalles[i], empleados[i]);
	end;
	
	minimo(detalles, empleados, empleadoMin);
	
	maxVentas:= 0;
	
	while (empleadoMin.codigoMoto <> VALOR_ALTO) do begin
		cantVentas:= 0;
		
		read(maestro, moto);	
		while (moto.codigo <> empleadoMin.codigoMoto) do
			//busco registro del maestro que coincida con el detalle.
			read(maestro, moto);
		
		//actualizo las ventas de las motos
		while (moto.codigo = empleadoMin.codigoMoto) do begin
			//cada empleado que contenga el mismo código de moto es una venta de la misma.
			cantVentas:= cantVentas + 1;
			minimo(detalles, empleados, empleadoMin);
		end;
		
		
		if (cantVentas > maxVentas) then begin
			maxVentas:= cantVentas;
			codMotoMasVendida:= moto.codigo;
		end;
		
		moto.stockActual:= moto.stockActual - cantVentas;
		seek(maestro, filePos(maestro)-1);
		write(maestro, moto);
		
	end;
	
	if (maxVentas <> 0) then
		writeln('La moto más vendida fue: ', codMotoMasVendida);
	
	close(maestro);
	for i:= 1 to MAX_EMPLEADOS do begin
		close(detalles[i]);
End;
	
VAR
	maestro: archivo_maestro;
BEGIN
	assign(maestro, 'Archivo_Maestro');
	
	actualizarArchivo(maestro);
END.