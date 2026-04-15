
Program ejercicio5;

Const 
  valorAlto = 9999;
  cantDetalles = 5;
  fechaAlta = 'ZZZZZZZZZ';

Type 
  log = Record
    code: integer;
    date: string[10];
    time: real;
  End;
  archivo = file Of log;
  vectorDetalles = array[1..cantDetalles] Of archivo;
  vectorLogs = array[1..cantDetalles] Of log;

Var 
  detalles: vectorDetalles;
  //Ordenados por código de usuario y fecha.
  mae: archivo;
  logsD: vectorLogs;

Procedure crearDetalles;

Var 
  i : integer;
  v: log;
  numStr: string;
Begin
  For i:=1 To cantDetalles Do
    Begin
      Str(i, numStr);
      Assign(detalles[i],'Detalle_'+numStr+'.dat');
      //DATOS DE EJEMPLO PAR PROBAR CODIGO
      rewrite(detalles[i]);
      If (i = 1) Then
        Begin
          v.code := 1;
          v.date := '2026-04-10';
          v.time := 2.5;
          write(detalles[i], v);
          v.code := 2;
          v.date := '2026-04-12';
          v.time := 1.5;
          write(detalles[i], v);
        End;

      If (i = 2) Then
        Begin
          v.code := 1;
          v.date := '2026-04-10';
          v.time := 1.0;
          write(detalles[i], v);
          v.code := 1;
          v.date := '2026-04-11';
          v.time := 3.0;
          write(detalles[i], v);
        End;

      If (i = 3) Then
        Begin
          v.code := 2;
          v.date := '2026-04-05';
          v.time := 5.0;
          write(detalles[i], v);
        End;

      If (i = 4) Then
        Begin
          v.code := 2;
          v.date := '2026-04-12';
          v.time := 2.0;
          write(detalles[i], v);
          v.code := 3;
          v.date := '2026-04-15';
          v.time := 4.0;
          write(detalles[i], v);
        End;

      If (i = 5) Then
        Begin
          v.code := 3;
          v.date := '2026-04-15';
          v.time := 0.5;
          write(detalles[i], v);
        End;
      Close(detalles[i])
    End;
End;

Procedure leer (Var arch: archivo; Var regd: log);
Begin
  If (Not(eof(arch))) Then
    read(arch,regd)
  Else regd.code := valorAlto;
End;
Procedure minimo(Var min: log);

Var 
  i : integer;
  posMin : integer;
Begin
  posMin := 0;
  min.code := valorAlto;
  min.date := fechaAlta;
  For i:=1 To cantDetalles Do
    Begin
      If (logsD[i].code < min.code) Or
         ((logsD[i].code = min.code) And (logsD[i].date < min.date)) Then
        Begin
          min := logsD[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(detalles[posMin],logsD[posMin]);
End;
Procedure imprimirMaestro(Var mae: archivo);

Var 
  regm: log;
Begin
  reset(mae);
  writeln('------ ARCHIVO MAESTRO ------');
  While Not eof(mae) Do
    Begin
      read(mae, regm);
      writeln('Usuario: ', regm.code);
      writeln('  Fecha: ', regm.date);
      writeln('  Horas: ', regm.time:0:2);
      writeln('----------------------------------');
    End;
  writeln();
  close(mae);
End;

Var 
  min,regm: log;
  codActual,i: integer;
  fechaActual: string[10];

Begin
  crearDetalles;
  Assign(mae,'var/log/maestro.dat');
  For i:=1 To cantDetalles Do
    Begin
      reset(detalles[i]);
      leer(detalles[i],logsD[i]);
    End;
  rewrite(mae);
  minimo(min);

  While (min.code <> valorAlto) Do
    Begin   
      codActual := min.code;
      fechaActual := min.date;
      regm.time := 0;
      While ((codActual = min.code) And (fechaActual = min.date)) Do
        Begin
          regm.time := regm.time + min.time;
          minimo(min);
        End;
      regm.date := fechaActual;
      regm.code := codActual;
      write(mae,regm);
    End;
  close(mae);
  For i:=1 To cantDetalles Do
    close(detalles[i]);
  imprimirMaestro(mae);

End.
