
Program Ejercicio2;

Type 
  archivoNumeros = file Of integer;


Function promedio (cant: integer; total : integer) : real;
Begin
  If (cant <> 0) Then
    promedio := total/cant
  Else
    promedio := -1
End;

procedure imprimirDatos(var unArchivo: archivoNumeros);
Var 
  menores,total,cant,num: integer;

Begin
  total := 0;
  cant := 0;
  menores := 0;
  reset(unArchivo);
  writeln('--- Contenidos del archivo ---');
  While (Not EOF(unArchivo)) Do
    Begin
      read(unArchivo, num);
      writeln(num);
      If (num < 15000) Then
        menores := menores + 1;
      cant := cant + 1;
      total := total + num;
    End;
  close(unArchivo);
  writeln ('--- Datos pedidos ---');
  writeln('Promedio: ', promedio(cant,total): 0: 2);
  writeln('Cantidad de numeros menores a 15000: ', menores);


End;

Var 
  unArchivo: archivoNumeros;
  nombreDelArchivo: string;
Begin
  write('Ingrese el nombre del archivo creado en el ejercicio 1: ');
  readln(nombreDelArchivo);
  assign(unArchivo,nombreDelArchivo);
  imprimirDatos(unArchivo);
End.
