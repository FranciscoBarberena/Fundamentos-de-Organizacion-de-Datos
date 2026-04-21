
Program ejercicio12;

Const 
  valorAlto = 9999;

Type 
  acceso = Record
    year: integer;
    month: integer;
    day : integer;
    ID: integer;
    time: real;
  End;
  archivoMaestro = file Of acceso;

Var 
  mae : archivoMaestro;
Procedure leer(Var mae: archivoMaestro; Var regm: acceso);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else regm.year := valorAlto;
End;
Procedure generarInforme(Var mae: archivoMaestro; anio: integer);

Var 
  accesoActual,regm: acceso;
  timeDay,timeMonth, timeYear: real;
Begin
  reset(mae);
  leer(mae,regm);
  While (regm.year <> valorAlto) And (regm.year < anio) Do
    Begin
      leer(mae,regm);
    End;
  If (regm.year=anio) Then
    Begin
      timeYear := 0;
      writeln('Year: ',regm.year);
      While (regm.year = anio) Do
        Begin
          accesoActual.month := regm.month;
          writeln(' Month: ',regm.month);
          timeMonth := 0;
          While (regm.year = anio) And (regm.month = accesoActual.month) Do
            Begin
              accesoActual.day := regm.day;
              timeDay := 0;
              writeln('     Day: ',regm.day);
              While (regm.year = anio) And (regm.month = accesoActual.month) And (regm.day = accesoActual.day) Do
                Begin
                  accesoActual.ID := regm.ID;
                  accesoActual.time := 0;
                  While (regm.year = anio) And (regm.month = accesoActual.month) And (regm.day = accesoActual.day) And (accesoActual.ID = regm.ID) Do
                    Begin
                      accesoActual.time := accesoActual.time + regm.time;
                      leer(mae,regm);
                    End;
                  writeln('           Time spent by user ',accesoActual.ID,': ',accesoActual.time: 0: 1);
                  timeDay := timeDay + accesoActual.time;
                End;
              timeMonth := timeMonth + timeDay;
              writeln('     Total time in day ',accesoActual.day,', month ',accesoActual.month,': ',timeDay: 0: 1,'hs.');
            End;
          timeYear := timeYear + timeMonth;
          writeln(' Total time in month ',accesoActual.month,': ',timeMonth: 0: 1,'hs.');
          writeln('-------------------------------------------');
        End;
      writeln('Total time in year ',anio,': ',timeYear:0:1,'hs.');

    End
  Else writeln('Year ',anio,' not found in file.');
  close(mae);
End;
//Proceso para generar archivo a modo de ejemplo
Procedure generarDatosDePrueba(Var mae: archivoMaestro);

Var 
  a: acceso;
Begin
  Rewrite(mae);

  a.year := 2023;
  a.month := 12;
  a.day := 31;
  a.ID := 99;
  a.time := 1.5;
  Write(mae, a);


  a.year := 2024;
  a.month := 1;
  a.day := 1;
  a.ID := 1;
  a.time := 2.0;
  Write(mae, a);
  a.year := 2024;
  a.month := 1;
  a.day := 1;
  a.ID := 1;
  a.time := 1.5;
  Write(mae, a);
  a.year := 2024;
  a.month := 1;
  a.day := 1;
  a.ID := 2;
  a.time := 1.0;
  Write(mae, a);

  a.year := 2024;
  a.month := 1;
  a.day := 2;
  a.ID := 1;
  a.time := 3.0;
  Write(mae, a);

  a.year := 2024;
  a.month := 2;
  a.day := 15;
  a.ID := 5;
  a.time := 2.5;
  Write(mae, a);

  a.year := 2025;
  a.month := 1;
  a.day := 1;
  a.ID := 10;
  a.time := 5.0;
  Write(mae, a);

  Close(mae);
End;

Var 
  anio: integer;
Begin
  Assign(mae,'maestro.dat');
  generarDatosDePrueba(mae);
  write('Ingrese el anio sobre el cual se quiere realizar un informe: ');
  readln(anio);
  writeln('');
  generarInforme(mae,anio);
End.
