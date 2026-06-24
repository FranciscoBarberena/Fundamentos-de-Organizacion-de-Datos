
Program Ejercicio1;

Type 
  archivoNumeros = file Of integer;




Function promedio (cant: integer; total : integer) : real;
Begin
  If (cant <> 0) Then
    promedio := total/cant
  Else
    promedio := -1
End;

Var 
  num: integer;
  nombreDelArchivo: string;
  unArchivo: archivoNumeros;
Begin
  write('Ingresa el nombre del archivo: ');
  readln(nombreDelArchivo);
  assign(unArchivo, nombreDelArchivo);
  rewrite(unArchivo);
  writeln('Ingrese un numero a guardar (30000 para terminar)');
  readln(num);
  While (num <> 30000) Do
    Begin
      write(unArchivo, num);
      writeln('Ingrese un numero a guardar (30000 para terminar)');
      readln(num);
    End;
  writeln('El archivo se guardo correctamente bajo el nombre "',nombreDelArchivo,'"');
End.
