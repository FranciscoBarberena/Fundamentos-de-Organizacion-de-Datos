
Program ejercicio10;

Const 
  valorAlto = 9999;

Type 
  mesa = Record
    provCode: integer;
    locCode: integer;
    numMesa: integer;
    votes: integer;
  End;
  archivoMaestro = file Of mesa;

Var 
  mae: archivoMaestro;
Procedure leer(Var mae: archivoMaestro; Var m: mesa);
Begin
  If (Not(eof(mae))) Then
    read(mae,m)
  Else m.provCode := valorAlto;
End;


//Proceso para generar datos de ejemplo
Procedure generarDatosDePrueba(Var mae: archivoMaestro);

Var 
  m: mesa;
Begin
  Rewrite(mae);


  m.provCode := 1;
  m.locCode := 10;
  m.numMesa := 101;
  m.votes := 150;
  Write(mae, m);
  m.provCode := 1;
  m.locCode := 10;
  m.numMesa := 102;
  m.votes := 100;
  Write(mae, m);

  m.provCode := 1;
  m.locCode := 20;
  m.numMesa := 201;
  m.votes := 80;
  Write(mae, m);


  m.provCode := 2;
  m.locCode := 5;
  m.numMesa := 301;
  m.votes := 200;
  Write(mae, m);
  m.provCode := 2;
  m.locCode := 5;
  m.numMesa := 302;
  m.votes := 250;
  Write(mae, m);

  m.provCode := 2;
  m.locCode := 8;
  m.numMesa := 401;
  m.votes := 50;
  Write(mae, m);

  Close(mae);
End;

Var 
  m,mesaActual : mesa;
  totProv,total,totLoc : integer;

Begin
  Assign(mae,'maestro.dat');
  generarDatosDePrueba(mae);
  reset(mae);
  total := 0;
  leer(mae,m);
  While (m.provCode <> valorAlto) Do
    Begin
      mesaActual.provCode := m.provCode;
      writeln('Codigo de provincia: ',m.provCode);
      totProv := 0;
      While (mesaActual.provCode = m.provCode) Do
        Begin
          totLoc := 0;
          mesaActual.locCode := m.locCode;
          While (mesaActual.provCode = m.provCode) And (m.locCode = mesaActual.locCode) Do
            Begin
              totLoc := totLoc + m.votes;
              leer(mae,m);
            End;
          writeln('Localidad ',mesaActual.locCode,': ',totLoc);
          totProv := totProv + totLoc;
        End;
      writeln ('Total provincia ',mesaActual.provCode,': ',totProv);
      writeln('------------------------------');
      total := total + totProv;
    End;
  writeln('TOTAL GENERAL: ',total);
End.
