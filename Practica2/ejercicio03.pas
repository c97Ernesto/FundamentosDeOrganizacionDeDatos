{
3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}

PROGRAM ejercicio03;
CONST
	MAXdetalles = 30;
	VALOR_ALTO = 999999;

TYPE
	str50 = string[50];
	
	registro_maestro = record
		codProducto: integer;
		nombre: str50;
		descripcion: str50;
		stockDisponible: integer;
		stockMinimo: integer;
		precio: real;
	end;
	
	registro_detalle = record
		codProducto: integer;
		cantVendida: integer;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle = file of registro_detalle;
	
	//vector con la cantidad de archivos detalles para actualizar el maestro
	vec_archDetalles = array [1..MAXdetalles] of archivo_detalle;
	//vector de 30 registros para encontrar el mínimo entre los 30 archivos detalles
	vec_regDetalles = array [1..MAXdetalles] of registro_detalle;
	
Procedure leer(var archivo: archivo_detalle; var registro: registro_detalle);
Begin
	if (not eof(archivo)) then
		read(archivo, registro)
	else
		registro.codProducto:= VALOR_ALTO;
End;
Procedure minimo(var vDetalles: vec_archDetalles; var vRegistros: vec_regDetalles; min: registro_detalle);
var
	i: integer;
	codMin: integer;
	posMin: integer;
	
begin
	posMin:= 1;
	codMin:= VALOR_ALTO;
	
	for (i:= 1 to MAXdetalles) do begin
		if (vRegistros[i].codProducto < codMin) then begin
			codMin:= vRegistros[i].codProducto;
			min:= vRegistro[i];
			posMin:= i;
		end;
	end;
	leer(vDetalles[posMin], )
end;

	
VAR
	maestro: archivo_maestro;
	regMaestro: registro_maestro;
	
	vecArchDetalles: vec_archDetalles;
	vecRegDetalles: vec_regDetalles;
	regMin: registro_detalle;
	
	nombreMaestro, nombreDetalle: str50;
	
	archTxt: Text;
	
BEGIN
	writeln('Ingresar nombre de archivo maestro');
	readln(nombreMaestro);
	assign(maestro, nombreMaestro);
	reset(maestro);

	for (i:= 1 to MAXdetalles) do begin
		writeln('Ingresar nombre de archivo detalle');
		readln(nombreDetalle);
		assign(vecArchDetalles[i], nombreDetalle);
		reset(vecArchDetalles[i]);
		//cargo en el vetor de registros los primeros registros de cada archivo
		leer(vecArchDetalles[i], vecRegDetalle[i]);
	end;
	
	assign(archTxt, 'archivoTxt');
	rewrite(archTxt);
	
	minimo(vecArchDetalles, vecRegDetalle, regMin)
	
	while (regMin.codProducto <> VALOR_ALTO) do begin
		read(maestro, regMaestro);
		
		//pueden venir 0 o N detalles: busco el maestro que coincida con el detalle
		while (regMaestro.codProducto <> regMin.codProducto) do
			read(maestro, regMaestro);
			
		//actualizo registro maestro
		while (regMaestro.codProducto = regMin.codProducto) do begin
			regMaestro.stockDisponible:= regMaestro.stockDisponible - regMin.cantVendida;
			minimo(vecArchDetalles, vecRegDetalles, regMin);
		end;
			
		//escribo archivo txt
		if (regMaestro.stockMinimo > regMaestro.stockDisponible) then begin
			read(archivoTxt, regMaestro.nombre, regMaestro.descripcion, regMaestro,stockDisponible, regMaestro.precio);
		end;
	
		seek(maestro, filePos(maestro)-1);
		write(maestro, regMaestro);
	end;
	
	close(maestro);
	close(archivoTxt);
	for (i:= 1 to MAXdetalles) do
		close(vecArchDetalles[i]);
		
END.

	
	
