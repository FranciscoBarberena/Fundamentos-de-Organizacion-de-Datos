
Program ejercicio4;

Type 
  reg_flor = Record
    nombre: String[45];
    codigo: integer;
  End;
  tArchFlores = file Of reg_flor;

Procedure agregarFlor (Var a: tArchFlores; nombre: String; codigo: integer);

Var 
  f,fBorrado,cabecera : reg_flor;
Begin
  reset(a);
  read(a,cabecera);
  f.codigo := codigo;
  f.nombre := nombre;
  If (cabecera.codigo = 0) Then
    Begin
      seek(a, fileSize(a));
      write(a,f);
    End
  Else
    Begin
      seek(a,-cabecera.codigo);
      read(a,fBorrado);
      cabecera.codigo := fBorrado.codigo;
      seek(a,FilePos(a)-1);
      write(a,f);
      seek(a,0);
      write(a,cabecera);
    End;
  close(a);
End;

Procedure imprimirArchivo(Var a : tArchFlores);

Var 
  f: reg_flor;
Begin
  reset(a);
  seek(a,1);
  While (Not(eof(a))) Do
    Begin
      read(a,f);
      If (f.codigo > 0) Then
        Begin
          writeln('Codigo: ',f.codigo);
          writeln('Nombre: ',f.nombre);
          writeln('----------------');
        End;
    End;
  close(a);
End;
Procedure eliminarFlor (Var a: tArchFlores; flor:reg_flor);

Var 
  regArch,viejaCabecera,nuevaCabecera: reg_flor;
  encontre: boolean;
  posBorrado: integer;
Begin
  encontre := false;
  reset(a);
  read(a,viejaCabecera);
  While ((Not(eof(a))) And (Not encontre)) Do
    Begin
      read(a,regArch);
      If (regArch.codigo = flor.codigo) And (regArch.nombre = flor.nombre) Then
        Begin
          encontre := true;
          posBorrado := -(filePos(a)-1);
          regArch.codigo := viejaCabecera.codigo;
          seek(a,filePos(a)-1);
          write(a,regArch);
          nuevaCabecera := viejaCabecera;
          nuevaCabecera.codigo := posBorrado;
          seek(a,0);
          write(a,nuevaCabecera);
        End;
    End;
  close(a);
  If (Not encontre) Then
    writeln('No se encontro la flor a borrar.');
End;
Procedure leerFlor(Var f : reg_flor);
Begin
  write('Ingresa codigo de la flor: ');
  readln(f.codigo);
  write('Ingresa nombre de la flor: ');
  readln(f.nombre);
End;

//Proceso para poder probar el programa
Procedure generarDatosDePrueba(Var a: tArchFlores);

Var 
  f: reg_flor;
Begin
  rewrite(a);

  f.codigo := 0;
  f.nombre := '--- CABECERA ---';
  write(a, f);

  f.codigo := 101;
  f.nombre := 'Rosa';
  write(a, f);

  f.codigo := 102;
  f.nombre := 'Margarita';
  write(a, f);

  f.codigo := 103;
  f.nombre := 'Orquidea';
  write(a, f);

  f.codigo := 104;
  f.nombre := 'Girasol';
  write(a, f);

  close(a);
End;

Var 
  a: tArchFlores;
  opc: byte;
  f: reg_flor;
Begin
  Assign(a,'flores.dat');
  generarDatosDePrueba(a);
  Repeat
    writeln('0. Terminar programa y reiniciar archivo.');
    writeln('1. Agregar flor');
    writeln('2. Listar archivo');
    writeln('3. Borrar flor');
    write('Ingrese la opcion elegida: ');
    readln(opc);
    If ((opc>0) And (opc<4)) Then
      Begin
        Case opc Of 
          1:
             Begin
               leerFlor(f);
               agregarFlor(a,f.nombre,f.codigo);
             End;
          2: imprimirArchivo(a);
          3:
             Begin
               leerFlor(f);
               eliminarFlor(a,f);
             End;
        End;
      End;
  Until opc = 0;

End.
