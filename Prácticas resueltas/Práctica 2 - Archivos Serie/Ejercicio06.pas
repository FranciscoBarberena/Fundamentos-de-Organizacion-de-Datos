
Program ejercicio6;

Const 
  cantDetalles = 10;
  valorAlto = 9999;

Type 
  registroDetalle = Record
    codLocalidad: integer;
    codCepa: integer;
    casosActivos: integer;
    casosNuevos: integer;
    casosRecuperados: integer;
    casosFallecidos : integer;
  End;
  archivoDetalle = file Of registroDetalle;
  registroMaestro = Record
    codLocalidad: integer;
    codCepa: integer;
    nombreLocalidad: string[40];
    nombreCepa: string[40];
    casosActivos: integer;
    casosNuevos: integer;
    casosRecuperados: integer;
    casosFallecidos : integer;
  End;
  archivoMaestro = file Of registroMaestro;
  vectorDetalles = array[1..cantDetalles] Of archivoDetalle;
  vectorRegistros = array[1..cantDetalles] Of registroDetalle;

Var 
  mae: archivoMaestro;
  detalles: vectorDetalles;
  registrosDet: vectorRegistros;

Procedure leer(Var regd: registroDetalle; Var detalle: archivoDetalle);
Begin
  If (Not(eof(detalle))) Then
    read(detalle,regd)
  Else regd.codLocalidad := valorAlto;
End;
Procedure leerMae(Var mae: archivoMaestro;Var regm: registroMaestro );
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else regm.codLocalidad := valorAlto;
End;

Procedure minimo(Var min: registroDetalle; Var registros: vectorRegistros);

Var i, posMin : integer;
Begin
  min.codLocalidad := valorAlto;
  min.codCepa := valorAlto;
  posMin := 0;
  For i:=1 To cantDetalles Do
    Begin
      If (registros[i].codLocalidad<min.codLocalidad) Or
         ((registros[i].codLocalidad = min.codLocalidad) And (registros[i].codCepa < min.codCepa)) Then
        Begin
          min := registros[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(registros[posMin],detalles[posMin]);
End;

Procedure crearDetalles;

Var i : integer;
  strNum: string;
Begin
  For i:= 1 To cantDetalles Do
    Begin
      Str(i,strNum);
      Assign(detalles[i],'detalle_'+strNum+'.dat');
    End;
End;
Procedure contarLocalidades50(Var mae: archivoMaestro; Var localidadesCumplen: integer);

Var 

  cantLocalidad: integer;
  locActual : integer;
  regm: registroMaestro;
Begin
  reset(mae);
  leerMae(mae,regm);
  While (regm.codLocalidad <> valorAlto) Do
    Begin
      locActual := regm.codLocalidad;
      cantLocalidad := 0;
      While (locActual = regm.codLocalidad) Do
        Begin
          cantLocalidad := cantLocalidad + regm.casosActivos;
          leerMae(mae,regm);
        End;
      If (cantLocalidad > 50) Then
        localidadesCumplen := localidadesCumplen + 1;
    End;
  close(mae);
End;

//Procesos para datos de ejemplo

Procedure generarDatos(Var mae: archivoMaestro; Var detalles: vectorDetalles);


Var 
  i : integer;
  rm : registroMaestro;
  rd: registroDetalle;

Begin
  Rewrite(mae);
  rm.codLocalidad := 1;
  rm.nombreLocalidad := 'La Plata';
  rm.codCepa := 1;
  rm.nombreCepa := 'Alfa';
  rm.casosActivos := 10;
  rm.casosNuevos := 2;
  rm.casosRecuperados := 100;
  rm.casosFallecidos := 5;
  Write(mae, rm);
  rm.codLocalidad := 1;
  rm.nombreLocalidad := 'La Plata';
  rm.codCepa := 2;
  rm.nombreCepa := 'Beta';
  rm.casosActivos := 5;
  rm.casosNuevos := 1;
  rm.casosRecuperados := 50;
  rm.casosFallecidos := 2;
  Write(mae, rm);
  rm.codLocalidad := 2;
  rm.nombreLocalidad := 'Berisso';
  rm.codCepa := 1;
  rm.nombreCepa := 'Alfa';
  rm.casosActivos := 15;
  rm.casosNuevos := 0;
  rm.casosRecuperados := 80;
  rm.casosFallecidos := 10;
  Write(mae, rm);

  Close(mae);
  For i := 1 To cantDetalles Do
    Begin
      Rewrite(detalles[i]);
      If (i = 1) Then
        Begin
          rd.codLocalidad := 1;
          rd.codCepa := 1;
          rd.casosActivos := 30;
          rd.casosNuevos := 15;
          rd.casosRecuperados := 5;
          rd.casosFallecidos := 1;
          Write(detalles[i], rd);
        End;

      If (i = 2) Then
        Begin
          rd.codLocalidad := 1;
          rd.codCepa := 2;
          rd.casosActivos := 25;
          rd.casosNuevos := 10;
          rd.casosRecuperados := 2;
          rd.casosFallecidos := 0;
          Write(detalles[i], rd);

          rd.codLocalidad := 2;
          rd.codCepa := 1;
          rd.casosActivos := 10;
          rd.casosNuevos := 5;
          rd.casosRecuperados := 1;
          rd.casosFallecidos := 0;
          Write(detalles[i], rd);
        End;

      Close(detalles[i]);
    End;

End;
Procedure imprimirMaestro(Var mae: archivoMaestro);

Var 
  rm: registroMaestro;
Begin
  Reset(mae);
  While Not eof(mae) Do
    Begin
      Read(mae, rm);
      Writeln('Loc: ', rm.codLocalidad, ' (', rm.nombreLocalidad, ') | Cepa: ', rm.codCepa, ' (', rm.nombreCepa, ')');
      Writeln('   Activos: ', rm.casosActivos, ' | Nuevos: ', rm.casosNuevos, ' | Recup: ', rm.casosRecuperados, ' | Fall: ', rm.casosFallecidos);
    End;
  Writeln('--------------------------------------------------');
  Close(mae);
End;

Var 
  min: registroDetalle;
  locActual, cepaActual : integer;
  regm: registroMaestro;
  localidadesCumplen: integer;
  i: integer;
Begin
  localidadesCumplen := 0;
  Assign(mae,'maestro.dat');

  crearDetalles;
  generarDatos(mae, detalles);
  writeln('Maestro ANTES de la actualizacion');
  imprimirMaestro(mae);
  reset(mae);

  For i:=1 To cantDetalles Do
    Begin
      reset(detalles[i]);
      leer(registrosDet[i],detalles[i]);
    End;
  minimo(min,registrosDet);
  While (min.codLocalidad <> valorAlto) Do
    Begin
      locActual := min.codLocalidad;
      cepaActual := min.codCepa;
      leerMae(mae,regm);
      While (locActual <> regm.codLocalidad) Or (cepaActual <> regm.codCepa) Do
        Begin
          leerMae(mae,regm);
        End;
      regm.casosActivos := 0;
      regm.casosNuevos := 0;
      seek(mae,filePos(mae)-1);
      While (locActual = min.codLocalidad) And (cepaActual = min.codCepa) Do
        Begin
          regm.casosFallecidos := regm.casosFallecidos + min.casosFallecidos;
          regm.casosRecuperados := regm.casosRecuperados + min.casosRecuperados;
          regm.casosActivos := regm.casosActivos + min.casosActivos;
          regm.casosNuevos := regm.casosNuevos + min.casosNuevos;
          minimo(min,registrosDet);
        End;
      write(mae,regm);
    End;
  close(mae);
  For i:=1 To cantDetalles Do
    close(detalles[i]);
  writeln('Maestro DESPUES de la actualizacion');
  imprimirMaestro(mae);
  contarLocalidades50(mae,localidadesCumplen);
  writeln('La cantidad de localidades con mas de 50 casos activos es: ',localidadesCumplen);
End.
