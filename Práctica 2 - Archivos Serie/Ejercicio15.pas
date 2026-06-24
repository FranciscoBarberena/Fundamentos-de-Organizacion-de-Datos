
Program ejercicio15;

Const 
  valorAlto = 9999;
  cantDetalles = 10;

Type 
  registroMaestro = Record
    provCode: integer;
    provNom: string[30];
    locCode: integer;
    locNom: string[40];
    sinLuz: integer;
    sinGas: integer;
    cantChapa: integer;
    sinAgua : integer;
    sinSanitarios: integer;
  End;
  registroDetalle = Record
    provCode: integer;
    locCode: integer;
    conLuz: integer;
    construidas: integer;
    conAgua: integer;
    conGas: integer;
    conSantarios: integer;
  End;
  archivoDetalle = file Of registroDetalle;
  archivoMaestro = file Of registroMaestro;
  vectorRegistros = array[1..cantDetalles] Of registroDetalle;
  vectorArchivos = array[1..cantDetalles] Of archivoDetalle;

Procedure leer(Var det: archivoDetalle; Var regd: registroDetalle);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else
    Begin
      regd.provCode := valorAlto;
      regd.locCode := valorAlto;
    End;
End;
Procedure leerMae(Var mae: archivoMaestro; Var regm: registroMaestro);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else
    Begin
      regm.provCode := valorAlto;
      regm.locCode := valorAlto;
    End;

End;
Procedure minimo(Var v: vectorRegistros; Var min: registroDetalle; Var det: vectorArchivos );

Var 
  i : integer;
  posMin: integer;
Begin
  posMin := 0;
  min.provCode := valorAlto;
  min.locCode := valorAlto;

  For i:=1 To cantDetalles Do
    Begin

      If (v[i].provCode<min.provCode) Or
         ((v[i].provCode = min.provCode) And (v[i].locCode<min.locCode)) Then
        Begin
          min := v[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(det[posMin],v[posMin]);
End;
Procedure crearDetalles(Var detalles: vectorArchivos; Var registros: vectorRegistros);

Var 
  i : integer;
  iStr: string;
Begin
  For i:=1 To cantDetalles Do
    Begin
      str(i, iStr);
      Assign(detalles[i], 'detalle' + iStr + '.dat');
      reset(detalles[i]);
      leer(detalles[i], registros[i]);
    End;
End;
Procedure actualizarMaestro(Var mae: archivoMaestro; Var detalles: vectorArchivos; Var registros: vectorRegistros; Var min: registroDetalle);

Var 
  flag: boolean;
  i, cantSinChapa: integer;
  regm: registroMaestro;
Begin
  cantSinChapa := 0;
  reset(mae);
  leerMae(mae,regm);
  While (regm.provCode <> valorAlto) Do
    Begin
      flag := (regm.provCode = min.provCode) And (regm.locCode = min.locCode);
      While (regm.provCode = min.provCode) And (regm.locCode = min.locCode) Do
        Begin
          regm.sinLuz := regm.sinLuz - min.conLuz;
          regm.sinAgua := regm.sinAgua - min.conAgua;
          regm.sinGas := regm.sinGas - min.conGas;
          regm.sinSanitarios := regm.sinSanitarios - min.conSantarios;
          regm.cantChapa := regm.cantChapa - min.construidas;
          minimo(registros,min,detalles);
        End;
      If (regm.cantChapa = 0) Then
        cantSinChapa := cantSinChapa + 1;
      If (flag) Then
        Begin
          seek(mae,filePos(mae)-1);
          write(mae,regm);
        End;
      leerMae(mae,regm);
    End;
  writeln('Cantidad de localidades sin viviendas de chapa: ',cantSinChapa);
  close(mae);
  For i := 1 To cantDetalles Do
    close(detalles[i]);
End;
Procedure generarDatosDePrueba();

Var 
  mae_gen: archivoMaestro;
  det_gen: archivoDetalle;
  rm: registroMaestro;
  rd: registroDetalle;
  i: integer;
  iStr: string;
Begin
  Assign(mae_gen, 'maestro.dat');
  Rewrite(mae_gen);

  { Registro 1: Salta - Cafayate }
  rm.provCode := 1;
  rm.provNom := 'Salta';
  rm.locCode := 1;
  rm.locNom := 'Cafayate';
  rm.sinLuz := 10;
  rm.sinGas := 10;
  rm.cantChapa := 15;
  rm.sinAgua := 10;
  rm.sinSanitarios := 10;
  Write(mae_gen, rm);

  { Registro 2: Salta - Tartagal }
  rm.provCode := 1;
  rm.provNom := 'Salta';
  rm.locCode := 2;
  rm.locNom := 'Tartagal';
  rm.sinLuz := 5;
  rm.sinGas := 5;
  rm.cantChapa := 5;
  rm.sinAgua := 5;
  rm.sinSanitarios := 5;
  Write(mae_gen, rm);

  { Registro 3: Mendoza - San Rafael }
  rm.provCode := 2;
  rm.provNom := 'Mendoza';
  rm.locCode := 1;
  rm.locNom := 'San Rafael';
  rm.sinLuz := 2;
  rm.sinGas := 2;
  rm.cantChapa := 0;
  rm.sinAgua := 2;
  rm.sinSanitarios := 2;
  Write(mae_gen, rm);

  Close(mae_gen);

  For i := 1 To cantDetalles Do
    Begin
      str(i, iStr);
      Assign(det_gen, 'detalle' + iStr + '.dat');
      Rewrite(det_gen);

      If (i = 1) Then
        Begin
          rd.provCode := 1;
          rd.locCode := 1;
          rd.conLuz := 5;
          rd.construidas := 10;
          rd.conAgua := 5;
          rd.conGas := 5;
          rd.conSantarios := 5;
          Write(det_gen, rd);
        End
      Else If (i = 2) Then
             Begin
               rd.provCode := 1;
               rd.locCode := 1;
               rd.conLuz := 5;
               rd.construidas := 5;
               rd.conAgua := 5;
               rd.conGas := 5;
               rd.conSantarios := 5;
               Write(det_gen, rd);
             End
      Else If (i = 3) Then
             Begin
               rd.provCode := 1;
               rd.locCode := 2;
               rd.conLuz := 2;
               rd.construidas := 2;
               rd.conAgua := 2;
               rd.conGas := 2;
               rd.conSantarios := 2;
               Write(det_gen, rd);
             End;

      Close(det_gen);
    End;
End;

Procedure imprimirMaestroActualizado();

Var 
  mae_print: archivoMaestro;
  rm: registroMaestro;
Begin
  writeln('--------------------------------------------------');
  writeln('ESTADO FINAL DEL ARCHIVO MAESTRO:');
  Assign(mae_print, 'maestro.dat');
  reset(mae_print);
  While Not eof(mae_print) Do
    Begin
      read(mae_print, rm);
      writeln('> ', rm.provNom, ' - ', rm.locNom, ' | Viviendas de Chapa restantes: ', rm.cantChapa);
    End;
  close(mae_print);
  writeln('--------------------------------------------------');
End;

Var 
  mae: archivoMaestro;
  detalles: vectorArchivos;
  registros: vectorRegistros;
  min : registroDetalle;

Begin
  generarDatosDePrueba();
  Assign(mae,'maestro.dat');
  crearDetalles(detalles,registros);
  minimo(registros,min,detalles);
  actualizarMaestro(mae, detalles, registros, min);
  imprimirMaestroActualizado();
End.
