
Program ejercicio1a;

Const 
  valorAlto = 9999;

Type 
  producto = Record
    code: integer;
    nombre: string[40];
    precio: real;
    stockActual: integer;
    stockMinimo: integer;
  End;
  venta = Record
    code: integer;
    unidades: integer;
  End;
  archivoMaestro = file Of producto;
  archivoDetalle = file Of venta;
Procedure leerMae(Var mae: archivoMaestro; Var regm: producto);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else regm.code := valorAlto;
End;
Procedure leerDetalle(Var det: archivoDetalle; Var regd: venta);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else regd.code := valorAlto;
End;
Procedure actualizarMaestro(Var mae: archivoMaestro; Var det: archivoDetalle);

Var 
  regm: producto;
  regd: venta;
Begin
  reset(mae);
  reset(det);
  leerDetalle(det,regd);
  While (regd.code<> valorAlto) Do
    Begin
      leerMae(mae,regm);
      While (regm.code <> regd.code) Do
        leerMae(mae,regm);
      regm.stockActual := regm.stockActual - regd.unidades;
      seek(mae,filePos(mae)-1);
      write(mae,regm);
      seek(mae,0);
      leerDetalle(det,regd);
    End;
  close(mae);
  close(det);
End;
// Procesos para probar código
Procedure generarDatosDePrueba(Var mae: archivoMaestro; Var det: archivoDetalle);

Var 
  p: producto;
  v: venta;
Begin
  rewrite(mae);

  p.code := 15;
  p.nombre := 'Lavandina 1L';
  p.precio := 1200.0;
  p.stockActual := 100;
  p.stockMinimo := 20;
  write(mae, p);

  p.code := 8;
  p.nombre := 'Detergente';
  p.precio := 950.50;
  p.stockActual := 50;
  p.stockMinimo := 10;
  write(mae, p);

  p.code := 32;
  p.nombre := 'Escoba';
  p.precio := 3500.0;
  p.stockActual := 30;
  p.stockMinimo := 5;
  write(mae, p);

  p.code := 4;
  p.nombre := 'Desodorante Piso';
  p.precio := 1500.0;
  p.stockActual := 80;
  p.stockMinimo := 15;
  write(mae, p);

  close(mae);

  rewrite(det);

  v.code := 8;
  v.unidades := 5;
  write(det, v);

  v.code := 15;
  v.unidades := 10;
  write(det, v);

  v.code := 8;
  v.unidades := 2;
  write(det, v);

  close(det);
End;
Procedure imprimirMaestro(Var mae: archivoMaestro; titulo: String);

Var 
  p: producto;
Begin
  reset(mae);
  writeln('=== ', titulo, ' ===');
  While Not eof(mae) Do
    Begin
      read(mae, p);
      writeln('[Cod: ', p.code, '] ', p.nombre, ' | Stock: ', p.stockActual);
    End;
  writeln('=============================================');
  writeln();
  close(mae);
End;


Var 
  mae: archivoMaestro;
  det: archivoDetalle;
Begin
  Assign(mae,'maestro.dat');
  Assign(det,'detalle.dat');

  generarDatosDePrueba(mae, det);
  imprimirMaestro(mae, 'ESTADO INICIAL DEL STOCK');


  actualizarMaestro(mae, det);
  imprimirMaestro(mae, 'ESTADO FINAL DESPUES DE LAS VENTAS');
End.
