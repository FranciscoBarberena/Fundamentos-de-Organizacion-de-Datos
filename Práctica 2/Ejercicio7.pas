
Program ejercicio7;

Const 
  valorAlto = 9999;

Type 
  alumno = Record
    legajo: integer;
    apellido: string[40];
    nombre: string[40];
    cursadasAprobadas: integer;
    finalesAprobados: integer;
  End;
  cursada = Record
    legajo: integer;
    materia: integer;
    year: integer;
    aprobada: boolean;

  End;
  final = Record
    legajo: integer;
    materia: integer;
    fecha: string[10];
    nota: integer;
  End;
  archivoFinales = file Of final;
  archivoCursadas = file Of cursada;
  archivoMaestro = file Of alumno;

Var 
  mae: archivoMaestro;
  detCursadas: archivoCursadas;
  detFinales: archivoFinales;
Procedure leerCursada(Var archivo: archivoCursadas; Var c: cursada);
Begin
  If (Not(eof(archivo))) Then
    read(archivo,c)
  Else c.legajo := valorAlto;
End;
Procedure leerFinal(Var archivo: archivoFinales; Var f: final);
Begin
  If (Not(eof(archivo))) Then
    read(archivo,f)
  Else f.legajo := valorAlto;
End;
Procedure minimo(fLegajo: integer; cLegajo: integer; Var min : integer);
Begin
  If (fLegajo<cLegajo) Then
    min := fLegajo
  Else min := cLegajo;
End;

{ --- PROCEDIMIENTOS DE PRUEBA --- }
Procedure generarDatosDePrueba(Var mae: archivoMaestro; Var detCursadas: archivoCursadas; Var detFinales: archivoFinales);

Var 
  a: alumno;
  c: cursada;
  f: final;
Begin
  { 1. Crear Maestro }
  Rewrite(mae);
  a.legajo := 100;
  a.apellido := 'Perez';
  a.nombre := 'Juan';
  a.cursadasAprobadas := 5;
  a.finalesAprobados := 2;
  Write(mae, a);
  a.legajo := 200;
  a.apellido := 'Gomez';
  a.nombre := 'Ana';
  a.cursadasAprobadas := 10;
  a.finalesAprobados := 8;
  Write(mae, a);
  a.legajo := 300;
  a.apellido := 'Lopez';
  a.nombre := 'Luis';
  a.cursadasAprobadas := 0;
  a.finalesAprobados := 0;
  Write(mae, a);
  Close(mae);

  { 2. Crear Detalle de Cursadas }
  Rewrite(detCursadas);
  c.legajo := 100;
  c.materia := 1;
  c.year := 2025;
  c.aprobada := true;
  Write(detCursadas, c);  { Suma 1 a Juan }
  c.legajo := 100;
  c.materia := 2;
  c.year := 2025;
  c.aprobada := false;
  Write(detCursadas, c); { No suma }
  c.legajo := 300;
  c.materia := 1;
  c.year := 2025;
  c.aprobada := true;
  Write(detCursadas, c);  { Suma 1 a Luis }
  c.legajo := 300;
  c.materia := 2;
  c.year := 2026;
  c.aprobada := true;
  Write(detCursadas, c);  { Suma 1 a Luis }
  Close(detCursadas);

  { 3. Crear Detalle de Finales }
  Rewrite(detFinales);
  f.legajo := 100;
  f.materia := 3;
  f.fecha := '10/02/2026';
  f.nota := 7;
  Write(detFinales, f); { Suma 1 a Juan }
  f.legajo := 200;
  f.materia := 4;
  f.fecha := '15/02/2026';
  f.nota := 9;
  Write(detFinales, f); { Suma 1 a Ana }
  f.legajo := 200;
  f.materia := 5;
  f.fecha := '12/03/2026';
  f.nota := 2;
  Write(detFinales, f); { No suma }
  Close(detFinales);
End;

Procedure imprimirMaestro(Var mae: archivoMaestro);

Var 
  a: alumno;
Begin
  Reset(mae);
  While Not eof(mae) Do
    Begin
      Read(mae, a);
      Writeln('Legajo: ', a.legajo, ' | ', a.apellido, ', ', a.nombre);
      Writeln('  Cursadas Aprobadas: ', a.cursadasAprobadas);
      Writeln('  Finales Aprobados: ', a.finalesAprobados);
      Writeln('-----------------------------------');
    End;
  Writeln();
  Close(mae);
End;

Var 
  f: final;
  c: cursada;
  regm: alumno;
  min,contadorCursadas, contadorFinales: integer;
Begin
  Assign(mae, 'maestro.dat');
  Assign(detCursadas,'cursadas.dat');
  Assign(detFinales,'finales.dat');
  generarDatosDePrueba(mae, detCursadas, detFinales);
  Writeln('MAESTRO ANTES DE ACTUALIZAR:');
  imprimirMaestro(mae);
  reset(mae);
  reset(detCursadas);
  reset(detFinales);
  leerFinal(detFinales,f);
  leerCursada(detCursadas,c);
  While (f.legajo <> valorAlto) Or (c.legajo <> valorAlto) Do
    Begin
      minimo(f.legajo,c.legajo,min);
      read(mae,regm);
      While (regm.legajo < min) Do
        read(mae,regm);
      seek(mae,FilePos(mae)-1);
      contadorFinales := 0;
      While (f.legajo = min) Do
        Begin
          If (f.nota >= 4) Then
            contadorFinales := contadorFinales + 1;
          leerFinal(detFinales,f);
        End;
      contadorCursadas := 0;
      While (c.legajo = min) Do
        Begin
          If (c.aprobada) Then
            contadorCursadas := contadorCursadas + 1;
          leerCursada(detCursadas,c);
        End;
      regm.finalesAprobados := regm.finalesAprobados + contadorFinales;
      regm.cursadasAprobadas := regm.cursadasAprobadas + contadorCursadas;
      write(mae,regm);
    End;
  close(mae);
  close(detCursadas);
  close(detFinales);
  Writeln('MAESTRO DESPUES DE ACTUALIZAR:');
  imprimirMaestro(mae);

End.
