program Ejercicio1_y_2;
type
    archivoNumeros = file of integer;
procedure ejercicio1(var unArchivo: archivoNumeros);
var
     num: integer;
     nombreDelArchivo: string;
begin
     writeln('Ingresa el nombre del archivo');
     readln(nombreDelArchivo);
     assign(unArchivo, nombreDelArchivo);
     rewrite(unArchivo);
     writeln('Ingrese un numero a guardar (30000 para terminar)');
     readln(num);
     while(num <> 30000) do begin
               write(unArchivo, num);
               writeln('Ingrese un numero a guardar (30000 para terminar)');
               readln(num);
     end;

end;
function promedio (cant: integer; total : integer) : real;
begin
     if (cant <> 0) then
        promedio := total/cant
     else
         promedio := -1
end;
procedure ejercicio2(var unArchivo: archivoNumeros);
var
   menores,total,cant,num: integer;

begin
     total := 0;
     cant := 0;
     menores := 0;
     reset(unArchivo);
     writeln('--- Contenidos del archivo ---');
     while (not EOF(unArchivo)) do begin
           read(unArchivo, num);
           writeln(num);
           if (num < 15000) then
              menores := menores + 1;
           cant := cant + 1;
           total := total + num;
     end;
     close(unArchivo);
     writeln ('--- Datos pedidos ---');
     writeln('Promedio: ', promedio(cant,total):0:2);
     writeln('Cantidad de numeros menores a 15000: ', menores);


end;
var
   unArchivo: archivoNumeros;
begin
     ejercicio1(unArchivo);
     ejercicio2(unArchivo);
     writeln('Presione enter para terminar');
     readln();
end.
