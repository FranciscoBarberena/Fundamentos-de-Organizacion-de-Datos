
Program ejercicio2;

Const 
  valorAlto = 9999;

Type 
  mesa = Record
    codLoc: integer;
    code: integer;
    cantVotos: integer;
  End;
  archivoMaestro = file Of mesa;
  localidadesProcesadas = file Of integer;
Procedure leerMae(Var mae: archivoMaestro; Var regm: mesa);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else regm.codLoc := valorAlto;
End;
Procedure leerLoc(Var loc: localidadesProcesadas; Var reg: integer);
Begin
  If (Not(eof(loc))) Then
    read(loc,reg)
  Else reg := valorAlto;
End;

Procedure buscarLocalidad(Var archLoc: localidadesProcesadas; codeLoc: integer; Var encontro : boolean);

Var 
  regArch: integer;
Begin
  seek(archLoc,0);
  leerLoc(archLoc, regArch);
  encontro := false;
  While (regArch <> valorAlto) And (Not encontro) Do
    Begin
      If (regArch = codeLoc) Then
        encontro := true
      Else leerLoc(archLoc,regArch);
    End;
End;
Procedure generarInforme(Var mae: archivoMaestro; Var loc: localidadesProcesadas);

Var 
  regm: mesa;
  codActual,totalLocalidad,posActual,total : integer;
  encontro: boolean;
Begin
  reset(mae);
  rewrite(loc);
  leerMae(mae,regm);
  total := 0;
  posActual := 0;
  writeln('====================================================');
  writeln('Codigo de Localidad ----------------- Total de Votos');
  writeln('====================================================');
  While (regm.codLoc <> valorAlto) Do
    Begin
      totalLocalidad := 0;
      codActual := regm.codLoc;
      buscarLocalidad(loc,codActual,encontro);
      If (Not encontro) Then
        Begin
          While (regm.codLoc <> valorAlto) Do
            Begin
              If (regm.codLoc = codActual) Then
                totalLocalidad := totalLocalidad + regm.cantVotos;
              leerMae(mae,regm);
            End;
          seek(loc,fileSize(loc));
          write(loc,codActual);
          writeln(codActual,'-----------------------------------------',totalLocalidad);
          total := total + totalLocalidad;
        End;
      posActual := posActual + 1;
      seek(mae,posActual);
      leerMae(mae,regm);

    End;
  close(mae);
  close(loc);
  writeln('Total General de Votos: ---------------------',total);
  writeln('====================================================');

End;
Procedure generarDatosDePrueba(Var mae: archivoMaestro);

Var 
  m: mesa;
Begin
  rewrite(mae);

  m.codLoc := 1896;
  m.code := 101;
  m.cantVotos := 150;
  write(mae, m);

  m.codLoc := 1900;
  m.code := 201;
  m.cantVotos := 250;
  write(mae, m);

  m.codLoc := 1896;
  m.code := 102;
  m.cantVotos := 70;
  write(mae, m);

  m.codLoc := 1923;
  m.code := 301;
  m.cantVotos := 100;
  write(mae, m);

  m.codLoc := 1900;
  m.code := 202;
  m.cantVotos := 300;
  write(mae, m);

  m.codLoc := 1894;
  m.code := 401;
  m.cantVotos := 120;
  write(mae, m);

  close(mae);
End;

Var 
  mae: archivoMaestro;
  loc: localidadesProcesadas;
Begin
  Assign(mae,'maestro.dat');
  Assign(loc,'localidades.dat');
  generarDatosDePrueba(mae);
  generarInforme(mae,loc);
End.
