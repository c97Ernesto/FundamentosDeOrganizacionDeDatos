{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}
PROGRAM Ejercicio01_P1;

CONST
	FIN = 3000;
	
TYPE
	str50 = string[50];
	archivo_enteros = file of integer;	

VAR
	nombre_archLogico: archivo_enteros;
	nombre_archFisico: str50;
	num: integer;
	
BEGIN
	{nombre del archivo debe ser proporcionado por el usuario desde teclado.}
	write('Ingresar nombre de archivo: ');
	readln(nombre_archFisico);
	
	{realizamos asignación entre el nombre lógico que utiliza el algoritmo y el SO. 
	* archLogico: variable definida para trabajar con el archivo físico. 
	* archFísico: cadena de caracteres que representa el camino donde quedará (o ya se 
	* encuentra) el archivo y el nombre del mismo.}
	assign(nombre_archLogico, nombre_archFisico);
	
	{indicamos que el archivo va a ser creado y, por lo tanto la única operación válida para el 
	* mismo es escribir información.}
	rewrite(nombre_archLogico);
	
	write('Ingresar número: ');
	readln(num);
	while (num <> FIN) do begin		{escritura del archivo}
		write(nombre_archLogico, num); 
		{Tanto la instrucción read como la write avanzan en forma automática el puntero 
		* una posición luego de ejecutarse.}
		write('Ingresar otro número: ');
		readln(num);
	end;
	
	{Esta instrucción indica que no se va a trabajar más con el archivo. Significa poner 
	* una marca de EOF (end of file) al final del mismo}
	close(nombre_archLogico);
END.
