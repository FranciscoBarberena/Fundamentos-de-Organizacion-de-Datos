
Program ejercicio8;

Const 
  valorAlto = 9999;
  cantDetalles = 16;

Type 
  provincia = Record
    code : integer;
    nombre : string[40];
    habitantes : integer;
    kilos: real;
  End;
  log = Record
    code: integer;
    kilos: real;
  End;
  archivoMaestro = file Of provincia;
  archivoDetalle = file Of log;
  vectorDetalles = array[1..cantDetalles] Of archivoDetalle;
  vectorLogs = array[1..cantDetalles] Of log;

Var 
  mae: archivoMaestro;
  detalles: vectorDetalles;
  logs: vectorLogs;
Procedure crearDetalles(Var det : vectorDetalles);

Var 
  i : integer;
  strNum : string;
Begin
  For i:=1 To cantDetalles Do
    Begin
      Str(i,strNum);
      Assign(det[i],'Detalle'+strNum+'.dat');
    End;
End;
Procedure leer(Var det: archivoDetalle; Var regd : log);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else regd.code := valorAlto;
End;
Procedure minimo(Var detalles : vectorDetalles; Var logs: vectorLogs; Var min : log);

Var 
  i,posMin : integer;
Begin
  posMin := 0;
  min.code := valorAlto;
  For i:= 1 To cantDetalles Do
    Begin
      If (logs[i].code < min.code) Then
        Begin
          min := logs[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(detalles[posMin],logs[posMin]);
End;
Function promedio (consumo: real; habitantes: integer): real;
Begin
  If (habitantes <> 0) Then
    promedio := consumo/habitantes
  Else promedio := -1;
End;
Procedure informarConsumoAlto(regm : provincia);
Begin
  If (regm.kilos>10000) Then
    Begin
      writeln('Provincia: ',regm.nombre,' (',regm.code,')');
      writeln('     Kilos consumidos: ',regm.kilos:0:2,'kg.');
      writeln('     Promedio de consumo: ',promedio(regm.kilos,regm.habitantes): 0: 2,'kg por habitante.');
      writeln('--------------------------------------------------');

    End;
End;

{ --- Datos para poder probar con archivos de ejemplo --- }
Procedure generarDatosDePrueba(Var mae: archivoMaestro; Var detalles: vectorDetalles);

Var 
  regm: provincia;
  regd: log;
  i: integer;
Begin
  { 1. Generar el maestro }
  Rewrite(mae);
  regm.code := 1;
  regm.nombre := 'Buenos Aires';
  regm.habitantes := 17000;
  regm.kilos := 9000;
  Write(mae, regm);
  regm.code := 2;
  regm.nombre := 'Cordoba';
  regm.habitantes := 3800;
  regm.kilos := 15000;
  Write(mae, regm);
  regm.code := 3;
  regm.nombre := 'Mendoza';
  regm.habitantes := 20000;
  regm.kilos := 5000;
  Write(mae, regm);
  regm.code := 4;
  regm.nombre := 'Misiones';
  regm.habitantes := 1200;
  regm.kilos := 12000;
  Write(mae, regm);
  Close(mae);

  { 2. Generar los 16 detalles }
  For i := 1 To cantDetalles Do
    Begin
      Rewrite(detalles[i]);
      If (i = 1) Then
        Begin
          regd.code := 1;
          regd.kilos := 800;
          Write(detalles[i], regd);
          regd.code := 3;
          regd.kilos := 100;
          Write(detalles[i], regd);
        End;

      If (i = 2) Then
        Begin
          regd.code := 1;
          regd.kilos := 500;
          Write(detalles[i], regd);
        End;
      Close(detalles[i]);
    End;
End;

Var 
  i : integer;
  regm: provincia;
  min : log;
Begin
  Assign(mae, 'maestro.dat');
  crearDetalles(detalles);
  generarDatosDePrueba(mae, detalles);
  writeln('--- REPORTE DE PROVINCIAS CON ALTO CONSUMO ---');
  reset(mae);
  For i:= 1 To cantDetalles Do
    Begin
      reset(detalles[i]);
      leer(detalles[i],logs[i]);
    End;
  minimo(detalles,logs,min);

  While (min.code <> valorAlto) Do
    Begin
      read(mae,regm);
      While (regm.code <> min.code) Do
        Begin
          informarConsumoAlto(regm);
          read(mae,regm);
        End;
      seek(mae,filePos(mae)-1);
      While (min.code = regm.code) Do
        Begin
          regm.kilos := regm.kilos + min.kilos;
          minimo(detalles,logs,min);
        End;
      informarConsumoAlto(regm);
      write(mae,regm);
    End;
  While (Not(eof(mae))) Do
    Begin
      read(mae,regm);
      informarConsumoAlto(regm);
    End;
  close(mae);
  For i:= 1 To cantDetalles Do
    close(detalles[i]);
End.
