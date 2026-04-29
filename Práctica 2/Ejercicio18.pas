
Program ejercicio18;

Const 
  valorAlto = 9999;
  valorAltoString = 'zzzz';

Type 
  registroMaestro = Record
    locCode: integer;
    locName: string[40];
    munCode: integer;
    munName: string[40];
    hosCode: integer;
    hosName : string[40];
    fecha: string[10];
    casosPositivos: integer;
  End;
  archivoMaestro = file Of registroMaestro;
Procedure leerMae(Var mae: archivoMaestro; Var regm: registroMaestro);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else
    Begin
      regm.locCode := valorAlto;
      regm.munCode := valorAlto;
      regm.hosCode := valorAlto;
    End;
End;
Procedure generarInforme(Var mae : archivoMaestro);

Var 
  regm: registroMaestro;
  txt: Text;
  cantCasosMunicipios,casosHospital,casosLocalidad,casosTotales: integer;
  munActual,locActual,hosActual : integer;
  locActualNombre,munActualNombre: string[40];
Begin
  reset(mae);
  leerMae(mae,regm);
  casosTotales := 0;
  Assign(txt,'casos.txt');
  Rewrite(txt);
  While (regm.locCode <> valorAlto) Do
    Begin
      locActual := regm.locCode;
      locActualNombre := regm.locName;
      casosLocalidad := 0;
      writeln('Nombre: ',locActualNombre);
      While (locActual = regm.locCode) Do
        Begin
          munActual := regm.munCode;
          munActualNombre := regm.munName;
          cantCasosMunicipios := 0;
          writeln('     Municipio: ',munActualNombre);
          While (locActual = regm.locCode) And (munActual = regm.munCode) Do
            Begin
              hosActual := regm.hosCode;
              casosHospital  := 0;
              write('           Hospital ',regm.hosName,'............... ');
              While (locActual = regm.locCode) And (munActual = regm.munCode) And (hosActual = regm.hosCode) Do
                Begin
                  casosHospital := casosHospital + regm.casosPositivos;
                  leerMae(mae,regm);
                End;
              cantCasosMunicipios := cantCasosMunicipios + casosHospital;
              writeln(casosHospital);
            End;
          casosLocalidad := casosLocalidad + cantCasosMunicipios;
          writeln('     Cantidad de casos en municipio ',munActualNombre,': ',cantCasosMunicipios);
          writeln('...................................................');
          If (cantCasosMunicipios>1500) Then
            Begin
              writeln(txt,cantCasosMunicipios, ' ',locActualNombre);
              writeln(txt,munActualNombre);
            End;
        End;
      writeln('Cantidad de casos en la localidad ',locActualNombre,': ',casosLocalidad);
      writeln('-------------------------------------------------');
      casosTotales := casosTotales + casosLocalidad;
    End;
  close(mae);
  close(txt);
  writeln();
  writeln('Cantidad de casos totales en la provincia: ',casosTotales);

End;

//PROCESOS PARA PROBAR CODIGO
Procedure generarDatosDePrueba();

Var 
  mae_gen: archivoMaestro;
  rm: registroMaestro;
Begin
  Assign(mae_gen, 'maestro.dat');
  Rewrite(mae_gen);

  { --- LOCALIDAD 1: LA PLATA --- }

  { Municipio 1: Casco Urbano (Total esperado: 1600 casos -> Va al TXT) }
  rm.locCode := 1;
  rm.locName := 'La Plata';
  rm.munCode := 1;
  rm.munName := 'Casco Urbano';

  { Hospital 1: San Martin (Suma 1100) }
  rm.hosCode := 1;
  rm.hosName := 'San Martin';
  rm.fecha := '2026-04-20';
  rm.casosPositivos := 800;
  Write(mae_gen, rm);
  rm.hosCode := 1;
  rm.hosName := 'San Martin';
  rm.fecha := '2026-04-21';
  rm.casosPositivos := 300;
  Write(mae_gen, rm);

  { Hospital 2: Rossi (Suma 500) }
  rm.hosCode := 2;
  rm.hosName := 'Rossi';
  rm.fecha := '2026-04-20';
  rm.casosPositivos := 500;
  Write(mae_gen, rm);

  { Municipio 2: Tolosa (Total esperado: 150 casos -> No va al TXT) }
  rm.locCode := 1;
  rm.locName := 'La Plata';
  rm.munCode := 2;
  rm.munName := 'Tolosa';

  { Hospital 3: Hospital R. Gutierrez }
  rm.hosCode := 3;
  rm.hosName := 'Hosp. R. Gutierrez';
  rm.fecha := '2026-04-20';
  rm.casosPositivos := 150;
  Write(mae_gen, rm);


  { --- LOCALIDAD 2: MAR DEL PLATA --- }

  { Municipio 3: Gral Pueyrredon (Total esperado: 1400 casos -> No va al TXT) }
  rm.locCode := 2;
  rm.locName := 'Mar del Plata';
  rm.munCode := 3;
  rm.munName := 'Gral Pueyrredon';

  { Hospital 4: Interzonal }
  rm.hosCode := 4;
  rm.hosName := 'Interzonal';
  rm.fecha := '2026-04-20';
  rm.casosPositivos := 1400;
  Write(mae_gen, rm);

  Close(mae_gen);

End;

Procedure verificarArchivoTexto();

Var 
  txt: Text;
  linea: string;
Begin
  writeln();
  writeln('--------------------------------------------------');
  writeln('CONTENIDO GENERADO EN CASOS.TXT:');
  Assign(txt, 'casos.txt');
  reset(txt);
  While Not eof(txt) Do
    Begin
      readln(txt, linea);
      writeln(linea);
    End;
  close(txt);
  writeln('--------------------------------------------------');
End;

Var 
  mae: archivoMaestro;
Begin
  generarDatosDePrueba();
  Assign(mae,'maestro.dat');
  generarInforme(mae);
  verificarArchivoTexto()
End.
