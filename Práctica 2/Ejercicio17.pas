
Program ejercicio17;

Const 
  valorAlto = 9999;
  cantDetalles = 10;

Type 
  moto = Record
    code: integer;
    nombre: string[30];
    desc: string;
    modelo : string[30];
    marca: string[30];
    stockActual: integer;
  End;
  venta = Record
    code: integer;
    precio: real;
    fecha: string[10];
  End;
  archivoMaestro = file Of moto;
  archivoDetalle = file Of venta;
  vectorVentas = array[1..cantDetalles] Of venta;
  vectorDetalles = array[1..cantDetalles] Of archivoDetalle;
Procedure leer (Var det: archivoDetalle; Var regd: venta);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else
    regd.code := valorAlto;
End;

Procedure leerMae (Var mae: archivoMaestro; Var regm: moto);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else
    regm.code := valorAlto;
End;


Procedure minimo(Var registros: vectorVentas; Var detalles: vectorDetalles; Var min: venta);

Var 
  i,posMin : integer;
Begin
  posMin := 0;
  min.code := valorAlto;
  For i := 1 To cantDetalles Do
    Begin
      If (registros[i].code< min.code) Then
        Begin
          min := registros[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(detalles[posMin],registros[posMin]);
End;
Procedure crearDetalles(Var detalles: vectorDetalles; Var registros: vectorVentas);

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

//PROCESOS PARA PODER PROBAR EL PROGRAMA
Procedure generarDatosDePrueba();

Var 
  mae_gen: archivoMaestro;
  det_gen: archivoDetalle;
  rm: moto;
  rd: venta;
  i: integer;
  iStr: string;
Begin
  Assign(mae_gen, 'maestro.dat');
  Rewrite(mae_gen);

  { Moto 10: Honda Titan - Arranca con 15 de stock }
  rm.code := 10;
  rm.nombre := 'Titan 150';
  rm.desc := 'Motor 150cc';
  rm.modelo := '2023';
  rm.marca := 'Honda';
  rm.stockActual := 15;
  Write(mae_gen, rm);

  { Moto 20: Yamaha YBR - Arranca con 8 de stock (Será la más vendida) }
  rm.code := 20;
  rm.nombre := 'YBR 125';
  rm.desc := 'Motor 125cc';
  rm.modelo := '2022';
  rm.marca := 'Yamaha';
  rm.stockActual := 8;
  Write(mae_gen, rm);

  { Moto 30: Bajaj Rouser - Arranca con 5 de stock }
  rm.code := 30;
  rm.nombre := 'Rouser NS200';
  rm.desc := 'Motor 200cc';
  rm.modelo := '2024';
  rm.marca := 'Bajaj';
  rm.stockActual := 5;
  Write(mae_gen, rm);

  Close(mae_gen);

  { Generamos los 10 archivos de ventas de los empleados }
  For i := 1 To cantDetalles Do
    Begin
      str(i, iStr);
      Assign(det_gen, 'detalle' + iStr + '.dat');
      Rewrite(det_gen);

    { Empleado 1: Vende una Honda (Cod 10) y dos Yamaha (Cod 20) }
      If (i = 1) Then
        Begin
          rd.code := 10;
          rd.precio := 1500000;
          rd.fecha := '2026-04-10';
          Write(det_gen, rd);
          rd.code := 20;
          rd.precio := 1200000;
          rd.fecha := '2026-04-12';
          Write(det_gen, rd);
          rd.code := 20;
          rd.precio := 1200000;
          rd.fecha := '2026-04-15';
          Write(det_gen, rd);
        End
    { Empleado 2: Vende una Yamaha (Cod 20) y una Bajaj (Cod 30) }
      Else If (i = 2) Then
             Begin
               rd.code := 20;
               rd.precio := 1200000;
               rd.fecha := '2026-04-05';
               Write(det_gen, rd);
               rd.code := 30;
               rd.precio := 2100000;
               rd.fecha := '2026-04-20';
               Write(det_gen, rd);
             End;
      Close(det_gen);
    End;
  writeln('--- Archivos de prueba generados en el disco ---');
End;

Procedure imprimirMaestroActualizado();

Var 
  mae_print: archivoMaestro;
  rm: moto;
Begin
  writeln('--------------------------------------------------');
  writeln('ESTADO FINAL DEL STOCK (ARCHIVO MAESTRO):');
  Assign(mae_print, 'maestro.dat');
  reset(mae_print);
  While Not eof(mae_print) Do
    Begin
      read(mae_print, rm);
      writeln('> Cod: ', rm.code, ' | ', rm.marca, ' ', rm.nombre, ' | Stock restante: ', rm.stockActual);
    End;
  close(mae_print);
  writeln('--------------------------------------------------');
End;

Procedure actualizarMaestro(Var mae: archivoMaestro; Var detalles: vectorDetalles; Var ventas: vectorVentas; Var min: venta);

Var 
  regm: moto;
  maxVentas,maxCode, ventasMoto : integer;

Begin
  reset(mae);
  leerMae(mae,regm);
  maxVentas := -1;
  maxCode := 0;
  While (min.code <> valorAlto) Do
    Begin
      While (regm.code <> min.code) Do
        leerMae(mae,regm);
      seek(mae,FilePos(mae)-1);
      ventasMoto := 0;
      While (min.code = regm.code) Do
        Begin
          regm.stockActual := regm.stockActual - 1;
          ventasMoto := ventasMoto + 1;
          minimo(ventas,detalles,min);
        End;
      If (ventasMoto > maxVentas) Then
        Begin
          maxVentas := ventasMoto;
          maxCode := regm.code;
        End;
      write(mae,regm);
    End;
  close(mae);
  writeln('La moto mas vendida fue ',maxCode,' con ',maxVentas,' ventas.');
End;

Var 
  mae: archivoMaestro;
  detalles: vectorDetalles;
  ventas: vectorVentas;
  min: venta;
  i: integer;
Begin
  generarDatosDePrueba();
  Assign(mae,'maestro.dat');
  crearDetalles(detalles,ventas);
  minimo(ventas,detalles,min);
  actualizarMaestro(mae,detalles,ventas,min);
  For i := 1 To cantDetalles Do
    close(detalles[i]);
  imprimirMaestroActualizado();

End.
