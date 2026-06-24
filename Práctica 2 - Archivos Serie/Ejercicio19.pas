
Const 
  valorAlto = 9999;
  cantDetalles = 50;

Type 
  direcciones = Record
    calle: string[20];
    numero: integer;
    piso: integer;
    depto: integer;
    ciudad: string[40];
  End;
  registroMaestro = Record
    partidaNacimiento: integer;
    nombre: string[40];
    apellido: string[40];
    direccion: direcciones;
    matriculaNacimiento: integer;
    nomMadre: string[40];
    apeMadre: string[40];
    DNIMadre: integer;
    nomPadre: string[40];
    apePadre: string[40];
    DNIPadre: integer;
    fallecio: boolean;
    matriculaDeceso: longInt;
    fecha: string[20];
    lugarDeceso: string[40];
  End;
  archivoMaestro = file Of registroMaestro;
  registroDetalleNacimientos = Record
    partidaNacimiento: integer;
    nombre: string[40];
    apellido: string[40];
    direccion: direcciones;
    matriculaNacimiento: longInt;
    nomMadre: string[40];
    apeMadre: string[40];
    DNIMadre: longInt;
    nomPadre: string[40];
    apePadre: string[40];
    DNIPadre: longInt;
  End;
  archivoDetalleNacimientos = file Of registroDetalleNacimientos;
  registroDetalleFallecimientos = Record
    partidaNacimiento: integer;
    DNI: longInt;
    nombre: string[40];
    apellido: string[40];
    matriculaDeceso: longInt;
    fecha: string[20];
    lugarDeceso: string[40];
  End;
  archivoDetalleFallecimientos = file Of registroDetalleFallecimientos;

  vectorDetallesNacimientos = array[1..cantDetalles] Of archivoDetalleNacimientos;
  vectorDetallesFallecimientos = array[1..cantDetalles] Of archivoDetalleFallecimientos;
  vectorRegistrosNacimientos = array[1..cantDetalles] Of registroDetalleNacimientos;
  vectorRegistrosFallecimientos = array [1..cantDetalles] Of registroDetalleFallecimientos;
Procedure leerNac(Var det: archivoDetalleNacimientos; Var nac: registroDetalleNacimientos);
Begin
  If (Not(eof(det))) Then
    read(det,nac)
  Else nac.partidaNacimiento := valorAlto;
End;
Procedure leerMue(Var det: archivoDetalleFallecimientos; Var mue: registroDetalleFallecimientos);
Begin
  If (Not(eof(det))) Then
    read(det,mue)
  Else mue.partidaNacimiento := valorAlto;
End;
Procedure minimoNac(Var detalles: vectorDetallesNacimientos; Var registros: vectorRegistrosNacimientos;Var min : registroDetalleNacimientos);

Var 
  i,posMin : integer;
Begin
  posMin := 0;
  min.partidaNacimiento := valorAlto;
  For i := 1 To cantDetalles Do
    Begin
      If (registros[i].partidaNacimiento<min.partidaNacimiento) Then
        Begin
          posMin := i;
          min := registros[i];
        End;
    End;
  If (posMin <> 0) Then
    leerNac(detalles[posMin],registros[posMin]);
End;
Procedure minimoMue(Var detalles: vectorDetallesFallecimientos; Var registros: vectorRegistrosFallecimientos;Var min : registroDetalleFallecimientos);

Var 
  i,posMin : integer;
Begin
  posMin := 0;
  min.partidaNacimiento := valorAlto;
  For i := 1 To cantDetalles Do
    Begin
      If (registros[i].partidaNacimiento<min.partidaNacimiento) Then
        Begin
          posMin := i;
          min := registros[i];
        End;
    End;
  If (posMin <> 0) Then
    leerMue(detalles[posMin],registros[posMin]);
End;
//PROCESOS PARA PROBAR EL PROGRAMA
Procedure generarDatosDePrueba();

Var 
  detNac: archivoDetalleNacimientos;
  detFac: archivoDetalleFallecimientos;
  rn: registroDetalleNacimientos;
  rf: registroDetalleFallecimientos;
  i: integer;
  iStr: string;
Begin
  For i := 1 To cantDetalles Do
    Begin
      str(i, iStr);

    { Creamos los 50 de nacimientos y los 50 de fallecimientos }
      Assign(detNac, 'detalleNac' + iStr + '.dat');
      Rewrite(detNac);
      Assign(detFac, 'detalleFac' + iStr + '.dat');
      Rewrite(detFac);

      If (i = 1) Then
        Begin
      { CASO 1: Solo Nacimiento (Persona Viva) - Va por el MIN_NAC < MIN_MUE }
          rn.partidaNacimiento := 100;
          rn.nombre := 'Ana';
          rn.apellido := 'Perez';
          rn.direccion.calle := 'Calle 7';
          rn.direccion.numero := 123;
          rn.direccion.piso := 0;
          rn.direccion.depto := 0;
          rn.direccion.ciudad := 'La Plata';
          rn.matriculaNacimiento := 1111;
          rn.nomMadre := 'Maria';
          rn.apeMadre := 'Perez';
          rn.DNIMadre := 20000000;
          rn.nomPadre := 'Juan';
          rn.apePadre := 'Perez';
          rn.DNIPadre := 21000000;
          Write(detNac, rn);

      { CASO 2: Nacimiento y Fallecimiento - Va por el MIN_NAC = MIN_MUE }
          rn.partidaNacimiento := 200;
          rn.nombre := 'Luis';
          rn.apellido := 'Gomez';
          rn.direccion.calle := 'Av Mitre';
          rn.direccion.numero := 456;
          rn.direccion.piso := 1;
          rn.direccion.depto := 2;
          rn.direccion.ciudad := 'Avellaneda';
          rn.matriculaNacimiento := 2222;
          rn.nomMadre := 'Laura';
          rn.apeMadre := 'Diaz';
          rn.DNIMadre := 30000000;
          rn.nomPadre := 'Carlos';
          rn.apePadre := 'Gomez';
          rn.DNIPadre := 31000000;
          Write(detNac, rn);

          rf.partidaNacimiento := 200;
          rf.DNI := 40000000;
          rf.nombre := 'Luis';
          rf.apellido := 'Gomez';
          rf.matriculaDeceso := 9999;
          rf.fecha := '2026-04-10';
          rf.lugarDeceso := 'Hosp. Fito';
          Write(detFac, rf);

      { CASO 3: Solo Fallecimiento (No está en nacimientos) - Va por MIN_NAC > MIN_MUE }
          rf.partidaNacimiento := 300;
          rf.DNI := 15000000;
          rf.nombre := 'Marta';
          rf.apellido := 'Lopez';
          rf.matriculaDeceso := 8888;
          rf.fecha := '2026-04-15';
          rf.lugarDeceso := 'Clinica Centro';
          Write(detFac, rf);
        End;

      Close(detNac);
      Close(detFac);
    End;
End;

Procedure verificarMaestro();

Var 
  mae_print: archivoMaestro;
  rm: registroMaestro;
Begin
  writeln('--------------------------------------------------');
  writeln('ESTADO DEL ARCHIVO MAESTRO GENERADO:');
  Assign(mae_print, 'maestro.dat');
  reset(mae_print);
  While Not eof(mae_print) Do
    Begin
      read(mae_print, rm);
      write('> Partida: ', rm.partidaNacimiento, ' | ', rm.nombre, ' ', rm.apellido);
      If (rm.fallecio) Then
        writeln(' (FALLECIO el ', rm.fecha, ')')
      Else
        writeln(' (VIVO - Vive en ', rm.direccion.ciudad, ')');
    End;
  close(mae_print);
  writeln('--------------------------------------------------');
End;

Var 
  mae: archivoMaestro;
  registrosNacimientos: vectorRegistrosNacimientos;
  registrosFallecimientos: vectorRegistrosFallecimientos;
  archivosNacimientos: vectorDetallesNacimientos;
  archivosFallecimientos: vectorDetallesFallecimientos;
  i: integer;
  iStr: string;
  minNac: registroDetalleNacimientos;
  minMue: registroDetalleFallecimientos;
  regm: registroMaestro;
  direccionVacia: direcciones;
  txt: Text;
Begin
  generarDatosDePrueba();

  direccionVacia.calle := '-';
  direccionVacia.numero := 0;
  direccionVacia.piso := 0;
  direccionVacia.depto := 0;
  direccionVacia.ciudad := '-';
  Assign(txt,'personas.txt');
  Rewrite(txt);
  Assign(mae,'maestro.dat');
  Rewrite(mae);
  For i:=1 To cantDetalles Do
    Begin
      str(i, iStr);
      Assign(archivosNacimientos[i], 'detalleNac' + iStr + '.dat');
      reset(archivosNacimientos[i]);
      leerNac(archivosNacimientos[i], registrosNacimientos[i]);
      Assign(archivosFallecimientos[i], 'detalleFac' + iStr + '.dat');
      reset(archivosFallecimientos[i]);
      leerMue(archivosFallecimientos[i], registrosFallecimientos[i]);
    End;
  minimoNac(archivosNacimientos,registrosNacimientos,minNac);
  minimoMue(archivosFallecimientos,registrosFallecimientos,minMue);
  While (minNac.partidaNacimiento <> valorAlto) Or (minMue.partidaNacimiento <> valorAlto) Do
    Begin
      If (minNac.partidaNacimiento < minMue.partidaNacimiento) Then
        Begin
          regm.partidaNacimiento := minNac.partidaNacimiento;
          regm.nombre := minNac.nombre;
          regm.apellido := minNac.apellido;
          regm.direccion := minNac.direccion;
          regm.matriculaNacimiento := minNac.matriculaNacimiento;
          regm.nomMadre := minNac.nomMadre;
          regm.apeMadre := minNac.apeMadre;
          regm.DNIMadre := minNac.DNIMadre;
          regm.nomPadre := minNac.nomPadre;
          regm.apePadre := minNac.apePadre;
          regm.DNIPadre := minNac.DNIPadre;
          regm.fallecio := false;
          regm.matriculaDeceso := -1;
          regm.fecha := '-';
          regm.lugarDeceso := '-';
          minimoNac(archivosNacimientos,registrosNacimientos,minNac);
        End
      Else If (minNac.partidaNacimiento > minMue.partidaNacimiento) Then
             Begin
               regm.partidaNacimiento := minMue.partidaNacimiento;
               regm.nombre := minMue.nombre;
               regm.apellido := minMue.apellido;
               regm.direccion := direccionVacia;
               regm.matriculaNacimiento := -1;
               regm.nomMadre := '-';
               regm.apeMadre := '-';
               regm.DNIMadre := 0;
               regm.nomPadre := '-';
               regm.apePadre := '-';
               regm.DNIPadre := 0;
               regm.fallecio := true;
               regm.matriculaDeceso := minMue.matriculaDeceso;
               regm.fecha := minMue.fecha;
               regm.lugarDeceso := minMue.lugarDeceso;
               minimoMue(archivosFallecimientos,registrosFallecimientos,minMue);
             End
      Else
        Begin
          regm.partidaNacimiento := minMue.partidaNacimiento;
          regm.nombre := minMue.nombre;
          regm.apellido := minMue.apellido;
          regm.direccion := minNac.direccion;
          regm.matriculaNacimiento := minNac.matriculaNacimiento;
          regm.nomMadre := minNac.nomMadre;
          regm.apeMadre := minNac.apeMadre;
          regm.DNIMadre := minNac.DNIMadre;
          regm.nomPadre := minNac.nomPadre;
          regm.apePadre := minNac.apePadre;
          regm.DNIPadre := minNac.DNIPadre;
          regm.fallecio := true;
          regm.matriculaDeceso := minMue.matriculaDeceso;
          regm.fecha := minMue.fecha;
          regm.lugarDeceso := minMue.lugarDeceso;
          minimoNac(archivosNacimientos,registrosNacimientos,minNac);
          minimoMue(archivosFallecimientos,registrosFallecimientos,minMue);
        End;
      write(mae,regm);
      writeln(txt, regm.partidaNacimiento, ' ', regm.nombre, ' ', regm.apellido, ' ', regm.direccion.calle, ' ', regm.direccion.numero, ' ', regm.direccion.piso, ' ', regm.direccion.depto, ' ', regm.
              direccion.ciudad, ' ', regm.matriculaNacimiento, ' ', regm.nomMadre, ' ', regm.apeMadre, ' ', regm.DNIMadre, ' ', regm.nomPadre, ' ', regm.apePadre, ' ', regm.DNIPadre, ' ', regm.
              fallecio, ' '
              , regm.matriculaDeceso, ' ', regm.fecha, ' ', regm.lugarDeceso);

    End;
  close(mae);
  close(txt);
  For i:= 1 To cantDetalles Do
    Begin
      close(archivosFallecimientos[i]);
      close(archivosNacimientos[i]);
    End;
  verificarMaestro();

End.
