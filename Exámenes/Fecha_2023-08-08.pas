
Program examen;

Const 
  valorAlto = 30000;
  cantDetalles = 20;

Type 
  registroMaestro = Record
    code: integer;
    nombre: string[30];
    precio: real;
    stockAct: integer;
    stockMin: integer;
  End;

  registroDetalle = Record
    code: integer;
    ventas: integer;
  End;

  archivoMaestro = file Of registroMaestro;
  archivoDetalle = file Of registroDetalle;
  vectorDetalles = array [1..cantDetalles] Of archivoDetalle;
  vectorRegistros = array [1..cantDetalles] Of registroDetalle;

Procedure leerDet(Var det: archivoDetalle; Var reg: registroDetalle);
Begin
  If (Not EOF(det)) Then
    read(det, reg)
  Else
    reg.code := valorAlto;
End;

Procedure minimo(Var res: vectorRegistros; Var min: registroDetalle; Var det: vectorDetalles);

Var 
  i, posMin: integer;
Begin
  posMin := 0;
  min.code := valorAlto;
  For i := 1 To cantDetalles Do
    Begin
      If (res[i].code < min.code) Then
        Begin
          posMin := i;
          min := res[i];
        End;
    End;

  If (posMin <> 0) Then
    leerDet(det[posMin], res[posMin]);
End;

Procedure actualizarMaestro(Var mae: archivoMaestro; Var det: vectorDetalles; Var txt: Text);

Var 
  res: vectorRegistros;
  i: integer;
  montoDia: real;
  min: registroDetalle;
  regm: registroMaestro;
Begin
  reset(mae);
  rewrite(txt);

  For i := 1 To cantDetalles Do
    Begin
      reset(det[i]);
      leerDet(det[i], res[i]);
    End;

  minimo(res, min, det);

  While (min.code <> valorAlto) Do
    Begin
      read(mae, regm);

      While (regm.code <> min.code) Do
        Begin
          read(mae, regm);
        End;

      montoDia := 0;

      While (min.code = regm.code) Do
        Begin
          montoDia := montoDia + (min.ventas * regm.precio);
          regm.stockAct := regm.stockAct - min.ventas;
          minimo(res, min, det);
        End;

      If (montoDia > 10000) Then
        Begin
          writeln(txt, regm.code, ' ', regm.precio:0:2, ' ', regm.stockAct, ' ', regm.stockMin, ' ', regm.nombre);
        End;

      Seek(mae, FilePos(mae)-1);
      write(mae, regm);
    End;

  close(mae);
  close(txt);
  For i := 1 To cantDetalles Do
    Begin
      close(det[i]);
    End;
End;

Begin
End.
