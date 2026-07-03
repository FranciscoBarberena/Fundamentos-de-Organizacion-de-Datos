
Program ejercicio3;

Const 
  valorAlto = 9999;
  cantDetalles = 5;

Type 
  str10 = string[10];
  pair = Record
    code : integer;
    date: str10;
  End;
  log = Record
    code: integer;
    date: str10;
    time: real;
  End;
  archivo = file Of log;
  logsProcesados = file Of pair;
  vectorArchivos = array[1..cantDetalles] Of archivo;
  vectorRegistros = array[1..cantDetalles] Of log;
Procedure leerDetalle(Var det: archivo; Var regd: log);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else regd.code := valorAlto;
End;
Procedure minimo(Var vRegistros: vectorRegistros; Var min: log; Var vDetalles: vectorArchivos);

Var 
  i,posMin: integer;
Begin
  posMin := 0;
  min.code := valorAlto;
  For i:= 1 To cantDetalles Do
    Begin
      If (vRegistros[i].code<min.code) Then
        Begin
          min := vRegistros[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leerDetalle(vDetalles[posMin],vRegistros[posMin]);
End;
Procedure buscarPar(Var arch: logsProcesados; fecha : str10;code : integer; Var encontre: boolean);

Var 
  par: pair;
Begin
  seek(arch,0);
  encontre := false;
  While (Not (eof(arch))) And (Not encontre) Do
    Begin
      read(arch,par);
      If (par.code = code) And (par.date = fecha) Then
        encontre := true;
    End;
End;
Procedure generarMaestro (Var vDetalles: vectorArchivos; Var mae: archivo);

Var 
  vRegistros: vectorRegistros;
  i: integer;
  min,regm : log;
  yaProcesados : logsProcesados;
  regProc: pair;
  encontre : boolean;
Begin
  Assign(yaProcesados, 'procesados.dat');
  rewrite(mae);
  rewrite(yaProcesados);
  For i := 1 To cantDetalles Do
    Begin
      reset(vDetalles[i]);
      leerDetalle(vDetalles[i],vRegistros[i]);
    End;
  minimo(vRegistros,min,vDetalles);
  While (min.code <> valorAlto) Do
    Begin
      regm.code := min.code;
      regm.time := 0;
      regm.date := min.date;
      buscarPar(yaProcesados,regm.date,regm.code,encontre);
      If (Not encontre) Then
        Begin
          While (min.code <> valorAlto) Do
            Begin
              If (min.code = regm.code) And (min.date = regm.date) Then
                Begin
                  regm.time := regm.time + min.time;
                End;
              minimo(vRegistros,min,vDetalles);
            End;
          regProc.code := regm.code;
          regProc.date := regm.date;
          write(mae,regm);
          seek(yaProcesados,fileSize(yaProcesados));
          write(yaProcesados, regProc);
          For i := 1 To cantDetalles Do
            seek(vDetalles[i],0);
          For i := 1 To cantDetalles Do
            leerDetalle(vDetalles[i],vRegistros[i]);
        End;
      minimo(vRegistros,min,vDetalles);
    End;
  close(yaProcesados);
  close(mae);
  For i := 1 To cantDetalles Do
    close(vDetalles[i]);
End;
// Procedimientos para probar código
Procedure generarDatosDePrueba(Var vDetalles: vectorArchivos);

Var 
  reg: log;
Begin
  { Detalle 1 }
  rewrite(vDetalles[1]);
  reg.code := 10;
  reg.date := '01/05/2026';
  reg.time := 2.5;
  write(vDetalles[1], reg);
  reg.code := 20;
  reg.date := '01/05/2026';
  reg.time := 1.0;
  write(vDetalles[1], reg);
  close(vDetalles[1]);

  { Detalle 2 }
  rewrite(vDetalles[2]);
  reg.code := 10;
  reg.date := '01/05/2026';
  reg.time := 1.5;
  write(vDetalles[2], reg);
  reg.code := 10;
  reg.date := '02/05/2026';
  reg.time := 3.0;
  write(vDetalles[2], reg);
  close(vDetalles[2]);

  { Detalle 3 }
  rewrite(vDetalles[3]);
  reg.code := 30;
  reg.date := '05/05/2026';
  reg.time := 0.5;
  write(vDetalles[3], reg);
  close(vDetalles[3]);

  { Detalle 4 }
  rewrite(vDetalles[4]);
  reg.code := 20;
  reg.date := '01/05/2026';
  reg.time := 2.0;
  write(vDetalles[4], reg);
  close(vDetalles[4]);

  { Detalle 5 }
  rewrite(vDetalles[5]);
  reg.code := 10;
  reg.date := '02/05/2026';
  reg.time := 1.0;
  write(vDetalles[5], reg);
  close(vDetalles[5]);
End;

Procedure imprimirMaestro(Var mae: archivo);

Var 
  reg: log;
Begin
  reset(mae);
  writeln('=== ESTADO FINAL DEL ARCHIVO MAESTRO ===');
  While Not eof(mae) Do
    Begin
      read(mae, reg);
      writeln('Usuario: ', reg.code, ' | Fecha: ', reg.date, ' | Tiempo Total: ', reg.time:0:2, ' hs');
    End;
  writeln('========================================');
  writeln;
  close(mae);
End;
Procedure imprimirDetalles(Var vDetalles: vectorArchivos);

Var 
  i: integer;
  reg: log;
Begin
  writeln('=== ESTADO INICIAL DE LOS ARCHIVOS DETALLE ===');
  For i := 1 To cantDetalles Do
    Begin
      reset(vDetalles[i]);
      writeln('--- MAQUINA ', i, ' ---');
      If eof(vDetalles[i]) Then
        writeln('  (Sin conexiones registradas)')
      Else
        Begin
          While Not eof(vDetalles[i]) Do
            Begin
              read(vDetalles[i], reg);
              writeln('  Usuario: ', reg.code, ' | Fecha: ', reg.date, ' | Tiempo: ', reg.time:0:2, ' hs');
            End;
        End;

      close(vDetalles[i]);
      writeln;
    End;
  writeln('==============================================');
  writeln;
End;

Var 
  mae: archivo;
  vDetalles : vectorArchivos;
  iStr: string;
  i : integer;
Begin
  Assign(mae,'maestro.dat');
  For i := 1 To cantDetalles Do
    Begin
      str(i,iStr);
      Assign(vDetalles[i],'detalle'+iStr+'.dat');
    End;
  generarDatosDePrueba(vDetalles);
  generarMaestro(vDetalles, mae);
  imprimirDetalles(vDetalles);
  imprimirMaestro(mae);

End.
