
Program ejercicio2;

Const 
  valorAlto = 9999;

Type 
  producto = Record
    code: integer;
    nombre: string[50];
    precio : real;
    stockActual: integer;
    stockMinimo : integer;
  End;
  venta = Record
    code: integer;
    unidades: integer;
  End;
  archivoMaestro = file Of producto;
  archivoDetalle = file Of venta;

Procedure leer(Var archivo: archivoDetalle; Var regd: venta);
Begin
  If (Not(EOF(archivo))) Then
    read(archivo,regd)
  Else regd.code := valorAlto;
End;

Procedure imprimirMaestro(Var mae : archivoMaestro);

Var 
  regm: producto;
Begin
  reset(mae);
  
  While Not eof(mae) Do
    Begin
      Read(mae, regm);
      writeln('Codigo: ', regm.code, ' | Producto: ', regm.nombre, ' | Stock Actual: ', regm.stockActual);
    End;
    writeln();

  close(mae);
End;

Var 
  mae : archivoMaestro;
  det : archivoDetalle;
  regm : producto;
  regd: venta;
  codActual,ventasTotales : integer;

  archTxt: Text;
Begin
  Assign(mae, 'maestro.dat');

  Rewrite(mae);
  //CREAR MAESTRO
  regm.code := 1;
  regm.nombre := 'Lavandina';
  regm.precio := 500.0;
  regm.stockActual := 100;
  regm.stockMinimo := 100;
  Write(mae, regm);

  regm.code := 2;
  regm.nombre := 'Detergente';
  regm.precio := 300.0;
  regm.stockActual := 50;
  regm.stockMinimo := 10;
  Write(mae, regm);

  regm.code := 5;
  regm.nombre := 'Desodorante de Piso';
  regm.precio := 400.0;
  regm.stockActual := 80;
  regm.stockMinimo := 15;
  Write(mae, regm);

  Close(mae);

  //CREAR DETALLE
  Assign(det, 'detalle.dat');
  Rewrite(det);

  //Lavandina 1
  regd.code := 1;
  regd.unidades := 5;
  Write(det, regd);
  //Lavandina 2
  regd.code := 1;
  regd.unidades := 10;
  Write(det, regd);
  //Desodorante de piso
  regd.code := 5;
  regd.unidades := 20;
  Write(det, regd);
  Close(det);

  writeln('-- Maestro ANTES de la actualizacion --');
  imprimirMaestro(mae);

  //Resolucion del enunciado

  reset(mae);
  reset(det);
  leer(det,regd);

  While (regd.code<>valorAlto) Do
    Begin
      codActual := regd.code;
      ventasTotales := 0;

      While (codActual = regd.code) Do
        Begin
          ventasTotales := ventasTotales + regd.unidades;
          leer(det,regd);
        End;
      read(mae,regm);
      While (regm.code<codActual) Do
        read(mae,regm);

      seek(mae,FilePos(mae)-1);
      regm.stockActual := regm.stockActual - ventasTotales;
      write(mae,regm);
    End;
  close(mae);
  close(det);
  writeln('-- Maestro DESPUES de la actualizacion --');
  imprimirMaestro(mae);
  Assign(archTxt,'stock_minimo.txt');
  rewrite(archTxt);
  reset(mae);
  While (Not(eof(mae))) Do
    Begin
      read(mae,regm);
      If (regm.stockActual<regm.stockMinimo) Then
        writeln(archTxt,regm.nombre,' ',regm.code,' ',regm.stockActual,' ',regm.stockMinimo,' $',regm.precio:0:2);
    End;
  close(mae);
  close(archTxt);
End.
