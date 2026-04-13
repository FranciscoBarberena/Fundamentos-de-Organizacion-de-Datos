
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

Procedure leer(Var archivo: archivoDetalle; Var v: venta);
Begin
  If (Not(EOF(archivo))) Then
    read(archivo,v)
  Else v.code := valorAlto;
End;

Procedure imprimirMaestro(Var mae : archivoMaestro);

Var 
  p: producto;
Begin
  writeln('--- ESTADO DEL MAESTRO ---');
  While Not eof(mae) Do
    Begin
      Read(mae, p);
      writeln('Codigo: ', p.code, ' | Producto: ', p.nombre, ' | Stock Actual: ', p.stockActual);
    End;
End;

Var 
  mae : archivoMaestro;
  det : archivoDetalle;
  regm : producto;
  regd: venta;
  codActual,ventasTotales : integer;
  p : producto;
  v: venta;
  archTxt: Text;
Begin
  Assign(mae, 'maestro.dat');

  Rewrite(mae);
  //CREAR MAESTRO
  p.code := 1;
  p.nombre := 'Lavandina';
  p.precio := 500.0;
  p.stockActual := 100;
  p.stockMinimo := 100;
  Write(mae, p);

  p.code := 2;
  p.nombre := 'Detergente';
  p.precio := 300.0;
  p.stockActual := 50;
  p.stockMinimo := 10;
  Write(mae, p);

  p.code := 5;
  p.nombre := 'Desodorante de Piso';
  p.precio := 400.0;
  p.stockActual := 80;
  p.stockMinimo := 15;
  Write(mae, p);

  Close(mae);

  //CREAR DETALLE
  Assign(det, 'detalle.dat');
  Rewrite(det);

  //Lavandina 1
  v.code := 1;
  v.unidades := 5;
  Write(det, v);
  //Lavandina 2
  v.code := 1;
  v.unidades := 10;
  Write(det, v);
  //Desodorante de piso
  v.code := 5;
  v.unidades := 20;
  Write(det, v);
  Close(det);

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
  reset(mae);
  imprimirMaestro(mae);
  Close(mae);
  Assign(archTxt,'stock_minimo.txt');
  rewrite(archTxt);
  reset(mae);
  While (Not(eof(mae))) Do
    Begin
      read(mae,regm);
      If (regm.stockActual<regm.stockMinimo) Then
        writeln(archTxt,regm.nombre,' ',regm.code,' ',regm.stockActual,' ',regm.stockMinimo,' $',regm.precio:0:20);
    End;
  close(mae);
  close(archTxt);
End.
