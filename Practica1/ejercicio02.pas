{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados 
* creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 
* y el promedio de los números ingresados. El nombre del archivo a procesar debe ser 
* proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el 
* contenido del archivo en pantalla.} 

PROGRAM ejercicio02;


TYPE
	str50 = string[50];
	archivo_enteros = file of integer;


VAR
	nombre_archLogico: archivo_enteros;
	nombre_archFisico: str50;
	num, cant_numeros, suma_total: integer;

BEGIN
	suma_total:= 0;
	cant_numeros:= 0;
	
	write('Ingresar nombre del archivo creado en el ejercicio01: ');
	readln(nombre_archFisico);
	
	assign(nombre_archLogico, nombre_archFisico);
	
	{indica que el archivo ya existe, y por lo tanto, las operaciones válidas sobre el 
	* mismo son lectura/escritura de información. El sistema operativo coloca un 
	* puntero direccionando al primer registro disponible dentro del archivo.}
	reset(nombre_archLogico);
	
	while(not eof(nombre_archLogico)) do begin
		
		read(nombre_archLogico, num);
		
		writeln('Nro',filePos(nombre_archLogico), ' ' ,num);
		
		suma_total:= suma_total + num;
		
		if (num < 1500) then
			cant_numeros:= cant_numeros + 1;
	end;
	
	
	write('La cantidad de números menores a 1500 que contenía el archivo ',nombre_archFisico,
	' es de ',cant_numeros,' y el promedio es ',(suma_total/FileSize(nombre_archLogico)));
	
	close(nombre_archLogico);
END.
