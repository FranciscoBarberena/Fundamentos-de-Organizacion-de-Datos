
Program ejercicio5;

Const 
  valorAlto = 9999;

Type 
  prenda = Record
    code: integer;
    desc: string;
    colores: string[30];
    tipo: string[30];
    stock: integer;
    precio: real;
  End;
  archivoDetalle = file Of integer;
  archivoMaestro = file Of prenda;

Procedure leerDetalle(Var det: archivoDetalle; Var regDet: integer);
Begin
  If (Not(eof(det))) Then
    read(det,regDet)
  Else regDet := valorAlto;
End;
Procedure leerMae(Var mae: archivoMaestro; Var regMae: prenda);
Begin
  If (Not(eof(mae))) Then
    read(mae,regMae)
  Else regMae.code := valorAlto;
End;

Procedure borrarPrendas(Var det: archivoDetalle; Var mae: archivoMaestro);

Var 
  regDet: integer;
  regMae: prenda;
Begin
  reset(mae);
  reset(det);
  leerDetalle(det,regDet);
  While (regDet <> valorAlto) Do
    Begin
      leerMae(mae,regMae);
      While ((regMae.code <> valorAlto) And (regMae.code <> regDet)) Do
        Begin
          leerMae(mae,regMae);
        End;
      If (regMae.code = regDet) Then
        Begin
          seek(mae,filePos(mae)-1);
          regMae.stock := -1;
          write(mae,regMae);
        End;
      seek(mae,0);
      leerDetalle(det,regDet);
    End;
  close(mae);
  close(det);
End;
Procedure crearMaestroNuevo(Var mae: archivoMaestro; Var nuevoMae: archivoMaestro);

Var 
  p: prenda;
Begin
  reset(mae);
  rewrite(nuevoMae);
  leerMae(mae,p);
  While (p.code <> valorAlto) Do
    Begin
      If (p.stock >= 0) Then
        write(nuevoMae,p);
      leerMae(mae,p);
    End;
  close(mae);
  close(nuevoMae);
  rename(mae,'backup.dat'); // Si ya hay un archivo con este nombre va a dar error.
  rename(nuevoMae,'maestro.dat');
End;
//Procesos para poder probar el codigo
Procedure generarDatosDePrueba(Var mae: archivoMaestro; Var det: archivoDetalle);

Var 
  p: prenda;
  codBorrar: integer;
Begin
  rewrite(mae);

  p.code := 105;
  p.desc := 'Campera de Cuero';
  p.colores := 'Negro';
  p.tipo := 'Abrigo';
  p.stock := 15;
  p.precio := 85000.00;
  write(mae, p);

  p.code := 22;
  p.desc := 'Remera Lisa';
  p.colores := 'Blanco, Gris';
  p.tipo := 'Remera';
  p.stock := 50;
  p.precio := 12000.50;
  write(mae, p);

  p.code := 89;
  p.desc := 'Pantalon Oxford';
  p.colores := 'Azul';
  p.tipo := 'Pantalon';
  p.stock := 5;
  p.precio := 35000.00;
  write(mae, p);

  p.code := 45;
  p.desc := 'Buzo Canguro';
  p.colores := 'Rojo, Negro';
  p.tipo := 'Buzo';
  p.stock := 20;
  p.precio := 28000.00;
  write(mae, p);

  close(mae);

  rewrite(det);

  codBorrar := 22;
  write(det, codBorrar);

  codBorrar := 89;
  write(det, codBorrar);

  close(det);
End;
Procedure imprimirMaestro(Var mae: archivoMaestro; titulo: String);

Var 
  p: prenda;
Begin
  reset(mae);
  writeln('--- ', titulo, ' ---');
  leerMae(mae, p);
  If (p.code = valorAlto) Then
    writeln('El archivo esta vacio.')
  Else
    Begin
      While (p.code <> valorAlto) Do
        Begin
          writeln('[ID: ', p.code, '] ', p.desc, ' | Stock: ', p.stock, ' | Precio: $', p.precio:0:2);
          leerMae(mae, p);
        End;
    End;
  writeln('--------------------------------------------------');
  close(mae);
End;

Var 
  mae,nuevoMae: archivoMaestro;
  det: archivoDetalle;
Begin
  Assign(mae,'maestro.dat');
  Assign(det,'detalle.dat');
  Assign(nuevoMae,'nuevoMaestro.dat');

  generarDatosDePrueba(mae, det);
  imprimirMaestro(mae, 'ESTADO INICIAL');

  borrarPrendas(det, mae);
  imprimirMaestro(mae, 'ESTADO TRAS BAJA LOGICA');

  crearMaestroNuevo(mae, nuevoMae);
  imprimirMaestro(nuevoMae, 'ESTADO FINAL TRAS BORRADO FISICO');
End.
