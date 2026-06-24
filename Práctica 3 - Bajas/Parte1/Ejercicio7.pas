
Program ejercicio7;

Type 
  str40 = string[40];
  distribucion = Record
    nombre: str40;
    anio: integer;
    kernel: integer;
    cantDesarrolladores: integer;
    desc: string;
  End;
  archivoMaestro = file Of distribucion;
Procedure BuscarDistribucion(Var mae: archivoMaestro; nombre: str40; Var pos: integer);

Var 
  regm: distribucion;
Begin
  reset(mae);
  seek(mae,1);
  pos := -1;
  While (Not(eof(mae))) And (pos = -1) Do
    Begin
      read(mae,regm);
      If (regm.cantDesarrolladores>0) And (regm.nombre = nombre) Then
        pos := filePos(mae)-1;
    End;
  close(mae);
End;
Procedure AltaDistribucion(Var mae: archivoMaestro; Var regm: distribucion);

Var 
  cabecera, regBasura : distribucion;
  pos: integer;
Begin
  BuscarDistribucion(mae,regm.nombre,pos);
  If (pos <> -1) Then
    writeln('Ya existe la distribucion.')
  Else
    Begin
      reset(mae);
      read(mae,cabecera);
      If (cabecera.cantDesarrolladores = 0) Then
        Begin
          seek(mae,fileSize(mae));
          write(mae,regm);
        End
      Else
        Begin
          seek(mae,-cabecera.cantDesarrolladores);
          read(mae,regBasura);
          cabecera.cantDesarrolladores := regBasura.cantDesarrolladores;
          seek(mae,filePos(mae)-1);
          write(mae,regm);
          seek(mae,0);
          write(mae,cabecera);
        End;
      close(mae);
    End;
End;
Procedure BajaDistribucion(Var mae: archivoMaestro; nombre: str40);

Var 
  pos : integer;
  registroBorrado,cabecera: distribucion;
Begin
  BuscarDistribucion(mae,nombre,pos);
  If (pos = -1) Then
    writeln('Distribución no existente.')
  Else
    Begin
      reset(mae);
      read(mae,cabecera);
      seek(mae,pos);
      read(mae,registroBorrado);
      seek(mae,FilePos(mae)-1);
      registroBorrado.cantDesarrolladores := cabecera.cantDesarrolladores;
      write(mae,registroBorrado);
      seek(mae,0);
      cabecera.cantDesarrolladores := -pos;
      write(mae,cabecera);
      close(mae);
    End;
End;
Procedure leerDistribucion(Var dis: distribucion);
Begin
  write('Ingrese el nombre de la distribucion: ');
  readln(dis.nombre);
  write('Ingrese el anio de la distribucion: ');
  readln(dis.anio);
  write('Ingrese el kernel de la distribucion: ');
  readln(dis.kernel);
  write('Ingrese la cantidad de desarrolladores de la distribucion: ');
  readln(dis.cantDesarrolladores);
  write('Ingrese la descripcion de la distribucion: ');
  readln(dis.desc);

End;

//Procesos para probar el codigo
Procedure generarDatosDePrueba(Var mae: archivoMaestro);

Var 
  dis: distribucion;
Begin
  rewrite(mae);

  dis.nombre := '--- CABECERA ---';
  dis.anio := 0;
  dis.kernel := 0;
  dis.cantDesarrolladores := 0;
  dis.desc := 'Registro control lista invertida';
  write(mae, dis);

  dis.nombre := 'Ubuntu';
  dis.anio := 2004;
  dis.kernel := 6;
  dis.cantDesarrolladores := 600;
  dis.desc := 'Basada en Debian, muy popular.';
  write(mae, dis);

  dis.nombre := 'Debian';
  dis.anio := 1993;
  dis.kernel := 6;
  dis.cantDesarrolladores := 1000;
  dis.desc := 'El sistema operativo universal.';
  write(mae, dis);

  dis.nombre := 'Arch Linux';
  dis.anio := 2002;
  dis.kernel := 6;
  dis.cantDesarrolladores := 300;
  dis.desc := 'Rolling release para usuarios avanzados.';
  write(mae, dis);

  dis.nombre := 'Fedora';
  dis.anio := 2003;
  dis.kernel := 6;
  dis.cantDesarrolladores := 450;
  dis.desc := 'Patrocinada por Red Hat.';
  write(mae, dis);

  close(mae);
End;
Procedure imprimirArchivo(Var mae: archivoMaestro);

Var 
  dis: distribucion;
  pos: integer;
Begin
  reset(mae);
  writeln();
  writeln('=== ESTADO FISICO DEL ARCHIVO ===');
  While Not eof(mae) Do
    Begin
      pos := filePos(mae);
      read(mae, dis);

      If (pos = 0) Then
        writeln('[POS ', pos, '] CABECERA ---> Apunta a: ', dis.cantDesarrolladores)

      Else If (dis.cantDesarrolladores < 0) Then
             writeln('[POS ', pos, '] ', dis.nombre, ' (BORRADO, apunta a: ', dis.cantDesarrolladores, ')')

      Else If (dis.cantDesarrolladores = 0) Then
             writeln('[POS ', pos, '] ', dis.nombre, ' (BORRADO Y FIN DE LA LISTA INVERTIDA: ', dis.cantDesarrolladores, ')')
      Else
        writeln('[POS ', pos, '] ', dis.nombre, ' (Devs: ', dis.cantDesarrolladores, ')');
    End;
  writeln('=================================');
  writeln();
  close(mae);
End;

Var 
  mae: archivoMaestro;
  dis: distribucion;
  opc: Byte;
Begin
  Assign(mae,'maestro.dat');
  generarDatosDePrueba(mae);
  Repeat
    writeln('0. Terminar programa y reiniciar archivo.');
    writeln('1. Agregar distribucion');
    writeln('2. Borrar distribucion');
    writeln('3. Imprimir archivo de la misma manera que se encuentra almacenado (para probar el codigo)');
    write('Ingrese la opcion elegida: ');
    readln(opc);
    If ((opc>0) And (opc<4)) Then
      Begin
        Case opc Of 
          1:
             Begin
               leerDistribucion(dis);
               AltaDistribucion(mae,dis);
             End;
          2:
             Begin
               write('Ingrese nombre de la distribucion a borrar: ');
               readln(dis.nombre);
               BajaDistribucion(mae,dis.nombre);
             End;
          3: imprimirArchivo(mae);
        End;
      End;
  Until opc = 0;
End.
