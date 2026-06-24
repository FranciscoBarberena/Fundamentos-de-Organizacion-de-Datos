
Program examen;

Const 
  ValorAlto = 30000;

Type 
  Partido = Record
    codEquipo: integer;
    nomEquipo: string[30];
    ano: integer;
    codTorneo: integer;
    codRival: integer;
    golesF: integer;
    golesC: integer;
    puntos: integer;
  End;

  ResumenEquipo = Record
    golesF: integer;
    golesC: integer;
    ganados: integer;
    perdidos: integer;
    empatados: integer;
    puntos: integer;
  End;

  tArchPart = file Of Partido;

Procedure leer(Var a: tArchPart; Var reg: Partido);
Begin
  If (Not EOF(a)) Then
    read(a, reg)
  Else
    reg.ano := ValorAlto;
End;

Procedure inicializarResumen(Var R: ResumenEquipo);
Begin
  R.golesF := 0;
  R.golesC := 0;
  R.ganados := 0;
  R.perdidos := 0;
  R.empatados := 0;
  R.puntos := 0;
End;

Procedure InformarResumen(R: ResumenEquipo);
Begin
  writeln('      Cantidad total de goles a favor: ', R.golesF);
  writeln('      Cantidad total de goles en contra: ', R.golesC);
  writeln('      Diferencia de gol: ', (R.golesF - R.golesC));
  writeln('      Cantidad de partidos ganados: ', R.ganados);
  writeln('      Cantidad de partidos perdidos: ', R.perdidos);
  writeln('      Cantidad de partidos empatados: ', R.empatados);
  writeln('      Cantidad total de puntos en el torneo: ', R.puntos);
  writeln('      ----------------------------------------');
End;

Procedure GenerarInforme(Var a: tArchPart);

Var 
  reg, PActual: Partido;
  resumen: ResumenEquipo;
  nomGanador: string[30];
  puntosGanador: integer;
Begin
  reset(a);
  leer(a, reg);

  While (reg.ano <> ValorAlto) Do
    Begin
      PActual.ano := reg.ano;
      writeln('Año ', PActual.ano);

      While (reg.ano = PActual.ano) Do
        Begin
          PActual.codTorneo := reg.codTorneo;
          puntosGanador := -1;
          nomGanador := '';

          writeln('  cod torneo ', PActual.codTorneo);

          While (reg.ano = PActual.ano) And (reg.codTorneo = PActual.codTorneo) Do
            Begin
              PActual.codEquipo := reg.codEquipo;
              PActual.nomEquipo := reg.nomEquipo;
              inicializarResumen(resumen);

              writeln('    ', PActual.codEquipo, ' ', PActual.nomEquipo);

              While (reg.ano = PActual.ano) And (reg.codTorneo = PActual.codTorneo) And (reg.codEquipo = PActual.codEquipo) Do
                Begin

                  resumen.golesF := resumen.golesF + reg.golesF;
                  resumen.golesC := resumen.golesC + reg.golesC;
                  resumen.puntos := resumen.puntos + reg.puntos;
                  Case reg.puntos Of 
                    3: resumen.ganados := resumen.ganados + 1;
                    1: resumen.empatados := resumen.empatados + 1;
                    0: resumen.perdidos := resumen.perdidos + 1;
                  End;
                  leer(a, reg);
                End;
              InformarResumen(resumen);
              If (resumen.puntos > puntosGanador) Then
                Begin
                  puntosGanador := resumen.puntos;
                  nomGanador := PActual.nomEquipo;
                End;
            End;
          writeln('El equipo "', nomGanador, '" fue campeón del torneo ', PActual.codTorneo, ' del año ', PActual.ano);
          writeln('');
        End;
    End;

  close(a);
End;

Begin
    { Cuerpo principal }
End.
