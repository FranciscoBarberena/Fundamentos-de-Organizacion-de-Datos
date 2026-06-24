
Program examen;

Const 
  ValorAlto = 30000;
  cantDetalles = 30;

Type 
  regMaestro = Record
    code: integer;
    nom: string[40];
    casos: integer;
  End;

  regDetalle = Record
    code: integer;
    casos: integer;
  End;

  archivoMaestro = file Of regMaestro;
  archivoDetalle = file Of regDetalle;

  vectorArchivos = array [1..cantDetalles] Of archivoDetalle;
  vectorRegistros = array [1..cantDetalles] Of regDetalle;

Procedure nombrarArchivos(Var mae: archivoMaestro; Var det: vectorArchivos);

Var 
  i: integer;
  nombre: string;
Begin
  readln(nombre);
  Assign(mae, nombre);

  For i := 1 To cantDetalles Do
    Begin
      readln(nombre);
      Assign(det[i], nombre);
    End;
End;

Procedure leerMae(Var mae: archivoMaestro; Var regm: regMaestro);
Begin
  If (Not EOF(mae)) Then
    read(mae, regm)
  Else
    regm.code := ValorAlto;
End;

Procedure leerDet(Var det: archivoDetalle; Var regD: regDetalle);
Begin
  If (Not EOF(det)) Then
    read(det, regD)
  Else
    regD.code := ValorAlto;
End;

Procedure minimo(Var v: vectorRegistros; Var min: regDetalle; Var det: vectorArchivos);

Var 
  i, posMin: integer;
Begin
  posMin := 0;
  min.code := ValorAlto;

  For i := 1 To cantDetalles Do
    Begin
      If (v[i].code < min.code) Then
        Begin
          posMin := i;
          min := v[i];
        End;
    End;

  If (posMin <> 0) Then
    leerDet(det[posMin], v[posMin]);
End;

Procedure actualizarMaestro(Var mae: archivoMaestro; Var det: vectorArchivos);

Var 
  resD: vectorRegistros;
  min: regDetalle;
  regm: regMaestro;
  i, casosPrevios: integer;
Begin
  For i := 1 To cantDetalles Do
    Begin
      reset(det[i]);
      leerDet(det[i], resD[i]);
    End;

  reset(mae);
  leerMae(mae, regm);
  minimo(resD, min, det);

  While (regm.code <> ValorAlto) Do
    Begin
      casosPrevios := regm.casos;

      While (regm.code = min.code) Do
        Begin
          regm.casos := min.casos + regm.casos;
          minimo(resD, min, det);
        End;

      If (casosPrevios <> regm.casos) Then
        Begin
          Seek(mae, FilePos(mae) - 1);
          write(mae, regm);
        End;

      If (regm.casos > 15) Then
        writeln(regm.nom, ' (', regm.code, ') tiene más de 15 casos');

      leerMae(mae, regm);
    End;

  close(mae);
  For i := 1 To cantDetalles Do
    Begin
      close(det[i]);
    End;
End;

Var 
  mae: archivoMaestro;
  det: vectorArchivos;
Begin
  nombrarArchivos(mae, det);
  actualizarMaestro(mae, det);
End.
