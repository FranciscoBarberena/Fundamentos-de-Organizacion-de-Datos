
Program ejercicio4;

Const 
  cantDetalles = 30;
  valorAlto = 9999;

Type 
  producto = Record
    code: integer;
    nombre: string[30];
    descripcion: string;
    stockDisponible: integer;
    stockMinimo: integer;
    precio: real;
  End;
  venta = Record
    code: integer;
    unidades: integer;
  End;
  archivoDetalle = file Of venta;
  archivoMaestro = file Of producto;
  vectorDetalles = array[1..cantDetalles] Of archivoDetalle;
  vectorRegDetalles = array[1..cantDetalles] Of venta;

Var 
  mae: archivoMaestro;
  detalles: vectorDetalles;
  regDetalles : vectorRegDetalles;
  archTxt: text;
Procedure leer (Var det: archivoDetalle; Var regd: venta);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else regd.code := valorAlto;
End;
Procedure minimo(Var min: venta);

Var i , posMin: integer;
Begin
  posMin := 0;
  min.code := valorAlto;
  For i:=1 To cantDetalles  Do
    Begin
      If (regDetalles[i].code < min.code) Then
        Begin
          min := regDetalles[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(detalles[posMin],regDetalles[posMin]);
End;
Procedure crearTxt;

Var regm: producto;
Begin
  reset(mae);

  rewrite(archTxt);
  While (Not(eof(mae))) Do
    Begin
      read(mae,regm);
      If (regm.stockDisponible < regm.stockMinimo) Then
        writeln(archTxt, regm.code,' ',regm.nombre,' ',regm.descripcion,' ',regm.stockDisponible,' ',regm.stockMinimo,' $',regm.precio:0:2);

    End;

  close(mae);
  close(archTxt);

End;
Procedure crearDetalles;

Var 
  i : integer;
  numStr: string;
  regd: venta;
Begin
  For i := 1 To cantDetalles Do
    Begin
      Str(i, numStr);
      //Sino no se puede concatenar para nombrar los archivos
      Assign(detalles[i], 'Detalle ' + numStr + '.dat');
      Rewrite(detalles[i]);

    {Solo pruebo con 3 detalles }
      If (i = 1) Then
        Begin
          regd.code := 1;
          regd.unidades := 10;
          Write(detalles[i], regd);
          regd.code := 5;
          regd.unidades := 20;
          Write(detalles[i], regd);
        End;
      If (i = 2) Then
        Begin
          regd.code := 1;
          regd.unidades := 50;
          Write(detalles[i], regd);
        End;

      If (i = 30) Then
        Begin
          regd.code := 5;
          regd.unidades := 10;
          Write(detalles[i], regd);
        End;
      Close(detalles[i]);
    End;

End;
Procedure imprimirMaestro(Var mae: archivoMaestro);

Var 
  regm: producto;
Begin
  reset(mae);
  { Recorremos hasta el final }
  While Not eof(mae) Do
    Begin
      read(mae, regm);
      writeln('Codigo: ', regm.code);
      writeln('  Producto: ', regm.nombre, ' (', regm.descripcion, ')');
      writeln('  Stock Disponible: ', regm.stockDisponible);
      writeln('  Stock Minimo: ', regm.stockMinimo);
      writeln('  Precio: $', regm.precio:0:2);
      writeln('----------------------------------');
    End;
  writeln();

  close(mae);
End;

Var 
  regm: producto;
  min: venta;
  i: integer;
Begin
  { --- CREAR MAESTRO --- }
  Assign(mae, 'maestro.dat');
  Rewrite(mae);
  regm.code := 1;
  regm.nombre := 'Hamburguesas';
  regm.descripcion := 'Caja x4';
  regm.stockDisponible := 100;
  regm.stockMinimo := 50;
  regm.precio := 1500.0;
  Write(mae, regm);
  regm.code := 2;
  regm.nombre := 'Papas Fritas';
  regm.descripcion := 'Bolsa 1kg';
  regm.stockDisponible := 40;
  regm.stockMinimo := 60;
  regm.precio := 2000.0;
  Write(mae, regm); { Ya está por debajo del mínimo }
  regm.code := 5;
  regm.nombre := 'Helado Menta';
  regm.descripcion := 'Pote 1kg';
  regm.stockDisponible := 80;
  regm.stockMinimo := 30;
  regm.precio := 3500.0;
  Write(mae, regm);
  Close(mae);
  //Crea detalles de ejemplo
  crearDetalles;
  writeln('Maestro ANTES de la actualizacion: ');
  imprimirMaestro(mae);
  //Resolución del enunciado

  reset(mae);



  For i:= 1 To cantDetalles Do
    Begin
      reset(detalles[i]);
      leer(detalles[i],regDetalles[i]);
    End;
  minimo(min);
  While (min.code <> valorAlto) Do
    Begin
      Read(mae,regm);
      While (regm.code<min.code) Do
        read(mae,regm);
      seek(mae,filePos(mae)-1);
      While (min.code = regm.code) Do
        Begin
          regm.stockDisponible := regm.stockDisponible - min.unidades;
          minimo(min);
        End;
      write(mae,regm);
    End;
  close(mae);
  For i:=1 To cantDetalles Do
    close(detalles[i]);
  writeln('Maestro DESPUES de la actualizacion: ');
  imprimirMaestro(mae);
  Assign(archTxt,'stockFaltante.txt');
  crearTxt;
  //Es mejor crearlo despues. Si lo creas mientras actualizas el maestro, aquellos archivos que estén en el maestro pero no en los detalles se van a saltear

End.
