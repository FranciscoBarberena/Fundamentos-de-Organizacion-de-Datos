
Program ejercicio16;

Const 
  valorAltoString = 'zzzz';
  valorAlto = 9999;
  cantDetalles = 100;

Type 
  emision = Record
    fecha: string[10];
    code: integer;
    nombre: string[40];
    desc: string;
    precio: real;
    cantEjemplares: integer;
    ejemplaresVendidos: integer;
  End;
  registroDetalle = Record
    fecha: string[10];
    code: integer;
    ventas: integer;
  End;
  archivoMaestro = file Of emision;
  archivoDetalle = file Of registroDetalle;
  vectorArchivos = array[1..cantDetalles] Of archivoDetalle;
  vectorRegDetalles = array[1..cantDetalles] Of registroDetalle;


Procedure leer (Var det: archivoDetalle; Var regd: registroDetalle);
Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else
    Begin
      regd.fecha := valorAltoString;
      regd.code := valorAlto;
    End;
End;

Procedure leerMae (Var mae: archivoMaestro; Var regm: emision);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else
    Begin
      regm.fecha := valorAltoString;
      regm.code := valorAlto;
    End;
End;


Procedure minimo(Var registros: vectorRegDetalles; Var detalles: vectorArchivos; Var min: registroDetalle);

Var 
  i,posMin : integer;
Begin
  posMin := 0;
  min.fecha := valorAltoString;
  min.code := valorAlto;
  For i := 1 To cantDetalles Do
    Begin
      If (registros[i].fecha< min.fecha) Or ((registros[i].fecha = min.fecha) And (registros[i].code< min.code)) Then
        Begin
          min := registros[i];
          posMin := i;
        End;
    End;
  If (posMin <> 0) Then
    leer(detalles[posMin],registros[posMin]);
End;
Procedure crearDetalles(Var detalles: vectorArchivos; Var registros: vectorRegDetalles);

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
Procedure actualizarMaestro(Var mae: archivoMaestro; Var detalles: vectorArchivos; Var registros: vectorRegDetalles; Var min : registroDetalle);

Var 
  regm: emision;
  maxVentas,minVentas, i, maxCodigo,minCodigo : integer;
  maxFecha, minFecha : string[10];
  flag : boolean;
Begin
  maxVentas := -1;
  minVentas := valorAlto;
  maxCodigo := 0;
  minCodigo := 0;
  maxFecha := '';
  minFecha := '';
  reset(mae);
  leerMae(mae,regm);
  minimo(registros,detalles,min);

  While (regm.fecha <> valorAltoString) Do
    Begin
      flag := (min.fecha = regm.fecha) And (min.code = regm.code);
      While (min.fecha = regm.fecha) And (min.code = regm.code) Do
        Begin
          regm.cantEjemplares := regm.cantEjemplares - min.ventas;
          regm.ejemplaresVendidos := regm.ejemplaresVendidos + min.ventas;
          minimo(registros,detalles,min);
        End;
      If (regm.ejemplaresVendidos>maxVentas) Then
        Begin
          maxVentas := regm.ejemplaresVendidos;
          maxFecha := regm.fecha;
          maxCodigo := regm.code;
        End;
      If (regm.ejemplaresVendidos<minVentas) Then
        Begin
          minVentas := regm.ejemplaresVendidos;
          minFecha := regm.fecha;
          minCodigo := regm.code;
        End;
      If (flag) Then
        Begin
          seek(mae,filePos(mae)-1);
          write(mae,regm);
        End;
      leerMae(mae,regm);
    End;
  close(mae);
  For i := 1 To cantDetalles Do
    close(detalles[i]);
  writeln('La emision con mas ventas fue la ',maxCodigo,' el ',maxFecha,' con ',maxVentas,' ejemplares vendidos.');
  writeln('La emision con menos ventas fue la ',minCodigo,' el ',minFecha,' con ',minVentas,' ejemplares vendidos.');

End;

Var 
  registros: vectorRegDetalles;
  detalles: vectorArchivos;
  mae : archivoMaestro;
  min: registroDetalle;
Begin
  Assign(mae,'maestro.dat');
  crearDetalles(detalles,registros);
  actualizarMaestro(mae,detalles,registros,min);
End.
