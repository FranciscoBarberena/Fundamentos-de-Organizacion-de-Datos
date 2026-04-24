
Program ejercicio14;

Const 
  valorAltoString = 'zzzz';
  valorAlto = 9999;

Type 

  vuelo = Record
    destino : string[30];
    fecha: string[10];
    horaSalida: string[10];
    asientosDisponibles: integer;
  End;
  lista = ^nodo;
  nodo = Record
    dato: vuelo;
    sig: lista;
  End;

  actualizacionVuelo = Record
    destino : string[30];
    fecha: string[10];
    horaSalida: string[10];
    asientosComprados: integer;
  End;
  archivoMaestro = file Of vuelo;
  archivoDetalle = file Of actualizacionVuelo;

Var 
  det1,det2: archivoDetalle;
  mae: archivoMaestro;

Procedure leer(Var det: archivoDetalle; Var regd: actualizacionVuelo);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else regd.destino := valorAltoString;
End;
Procedure minimo(Var regd1: actualizacionVuelo; Var regd2: actualizacionVuelo; Var min : actualizacionVuelo);
Begin
  If (regd1.destino<regd2.destino) Or
     ((regd1.destino = regd2.destino) And (regd1.fecha<regd2.fecha)) Or
     ((regd1.destino = regd2.destino) And (regd1.fecha = regd2.fecha) And (regd1.horaSalida < regd2.horaSalida))Then
    Begin
      min := regd1;
      leer(det1,regd1);
    End
  Else
    Begin
      min := regd2;
      leer(det2,regd2);
    End;
End;
Procedure agregarAdelante(Var l : lista; regm: vuelo);

Var aux : lista;
Begin
  new(aux);
  aux^.dato := regm;
  aux^.sig := l;
  l := aux;
End;
Procedure leerMae(Var mae: archivoMaestro; Var regm: vuelo);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else regm.destino := valorAltoString;
End;

//PROCESOS PARA PODER PROBAR EL CODIGO
Procedure generarDatosDePrueba(Var mae: archivoMaestro; Var det1, det2: archivoDetalle);

Var 
  v: vuelo;
  a: actualizacionVuelo;
Begin
  Rewrite(mae);
  Rewrite(det1);
  Rewrite(det2);

  { --- CARGA DEL MAESTRO --- }
  v.destino := 'Bariloche';
  v.fecha := '2026-05-01';
  v.horaSalida := '09:00';
  v.asientosDisponibles := 100;
  Write(mae, v);
  v.destino := 'Madrid';
  v.fecha := '2026-06-10';
  v.horaSalida := '20:00';
  v.asientosDisponibles := 40;
  Write(mae, v);
  v.destino := 'Miami';
  v.fecha := '2026-07-15';
  v.horaSalida := '10:00';
  v.asientosDisponibles := 50;
  Write(mae, v);

  { --- CARGA DEL DETALLE 1 --- }
  a.destino := 'Bariloche';
  a.fecha := '2026-05-01';
  a.horaSalida := '09:00';
  a.asientosComprados := 10;
  Write(det1, a);
  a.destino := 'Madrid';
  a.fecha := '2026-06-10';
  a.horaSalida := '20:00';
  a.asientosComprados := 5;
  Write(det1, a);

  { --- CARGA DEL DETALLE 2 --- }
  a.destino := 'Bariloche';
  a.fecha := '2026-05-01';
  a.horaSalida := '09:00';
  a.asientosComprados := 20;
  Write(det2, a);
  a.destino := 'Miami';
  a.fecha := '2026-07-15';
  a.horaSalida := '10:00';
  a.asientosComprados := 30;
  Write(det2, a);

  Close(mae);
  Close(det1);
  Close(det2);
End;

Procedure imprimirLista(l: lista; cantidadDeAsientos: integer);
Begin
  writeln('--------------------------------------------------');
  writeln('VUELOS CON MENOS ASIENTOS DISPONIBLES QUE ',cantidadDeAsientos);
  While (l <> Nil) Do
    Begin
      writeln('> Destino: ', l^.dato.destino, ' | Fecha: ', l^.dato.fecha, ' | Disp: ', l^.dato.asientosDisponibles);
      l := l^.sig;
    End;
  writeln('--------------------------------------------------');
End;

Var 
  min,regd1,regd2: actualizacionVuelo;
  regm: vuelo;
  cantidadDeAsientos,asientosDisponibles: integer;
  l : lista;
Begin
  l := Nil;
  Assign(mae,'maestro.dat');
  Assign(det1,'detalle1.dat');
  Assign(det2,'detalle2.dat');
  generarDatosDePrueba(mae, det1, det2);
  reset(mae);
  reset(det1);
  reset(det2);
  leer(det1,regd1);
  leer(det2,regd2);
  minimo(regd1,regd2,min);
  leerMae(mae,regm);
  write('Para buscar vuelos con menos de n asientos disponibles, ingrese n: ');
  readln(cantidadDeAsientos);
  While (regm.destino <> valorAltoString) Do
    Begin
      asientosDisponibles := regm.asientosDisponibles;
      While ((regm.destino = min.destino) And (regm.fecha = min.fecha) And (regm.horaSalida = min.horaSalida)) Do
        Begin
          asientosDisponibles := asientosDisponibles - min.asientosComprados;
          minimo(regd1,regd2,min);
        End;
      If (asientosDisponibles<> regm.asientosDisponibles) Then
        Begin
          regm.asientosDisponibles := asientosDisponibles;
          seek(mae,filePos(mae)-1);
          write(mae,regm);
        End;
      If (asientosDisponibles<cantidadDeAsientos) Then
        agregarAdelante(l,regm);
      leerMae(mae,regm);
    End;
  close(det1);
  close(det2);
  close(mae);
  imprimirLista(l,cantidadDeAsientos);
End.
