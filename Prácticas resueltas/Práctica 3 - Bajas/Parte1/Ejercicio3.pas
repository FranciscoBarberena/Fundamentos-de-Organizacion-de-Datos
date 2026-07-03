
Program ejercicio3;

Const 
  fin = -1;

Type 
  libro = Record
    code: integer;
    genero: string[30];
    titulo : string[30];
    autor : string[30];
    cantPaginas: integer;
    precio: real;
  End;
  archivoBinario = file Of libro;

Procedure leerLibro(Var l : libro; leerCodigo: boolean);
Begin
  If (leerCodigo) Then
    Begin
      write('Ingresar codigo de libro (-1 para terminar): ');
      readln(l.code);
    End;
  If (l.code <> fin) Then
    Begin
      write('Ingresar genero de libro: ');
      readln(l.genero);

      write('Ingresar titulo de libro: ');
      readln(l.titulo);

      write('Ingresar autor del libro: ');
      readln(l.autor);

      write('Ingresar cantidad de paginas del libro: ');
      readln(l.cantPaginas);

      write('Ingresar precio de libro: ');
      readln(l.precio);
    End;
End;
Procedure crearArchivo(Var arch : archivoBinario);

Var 
  l : libro;
Begin
  rewrite(arch);
  l.code := 0;
  l.autor := '';
  l.genero := '';
  l.precio := 0;
  l.titulo := '';
  l.cantPaginas := 0;
  write(arch,l);
  leerLibro(l,true);
  While (l.code <> fin)  Do
    Begin
      write(arch,l);
      leerLibro(l,true);
    End;
  close(arch);
End;
Procedure insertarLibro(Var arch: archivoBinario; l : libro);

Var 
  regArch: libro;
Begin
  seek(arch,0);
  If (Not(eof(arch))) Then
    Begin
      read(arch,regArch);
      If (regArch.code <> 0) Then
        Begin
          seek(arch,-regArch.code);
          read(arch,regArch);
          seek(arch,FilePos(arch)-1);
          write(arch,l);
          seek(arch,0);
          write(arch,regArch);
        End
      Else
        Begin
          seek(arch,fileSize(arch));
          write(arch,l);
        End;
    End;
End;

Procedure modificarLibro(Var arch: archivoBinario; l : libro);

Var 
  encontre: boolean;
  regArch: libro;
Begin
  encontre := false;
  seek(arch,1);
  While ((Not(eof(arch))) And (Not encontre)) Do
    Begin
      Read(arch,regArch);
      If (regArch.code = l.code) Then
        Begin
          encontre := true;
          leerLibro(l,false);
          seek(arch,filePos(arch)-1);
          write(arch,l);
        End;
    End;
  If (Not encontre) Then
    writeln('No se encontro el libro con el codigo ingresado.');
End;

Procedure eliminarLibro(Var arch: archivoBinario; l : libro);

Var 
  encontre: boolean;
  regArch,cabecera: libro;
  viejaCabecera,nuevaCabecera: integer;
Begin
  encontre := false;
  seek(arch,0);
  If (Not(eof(arch))) Then
    Begin
      read(arch,cabecera);
      viejaCabecera := cabecera.code;
    End;
  While ((Not(eof(arch))) And (Not encontre)) Do
    Begin
      Read(arch,regArch);
      If (regArch.code = l.code) Then
        Begin
          encontre := true;
          nuevaCabecera := -(filePos(arch)-1);
          regArch.code := viejaCabecera;
          seek(arch,filePos(arch)-1);
          write(arch,regArch);
          seek(arch,0);
          cabecera.code := nuevaCabecera;
          write(arch,cabecera);
        End;
    End;
  If (Not encontre) Then
    writeln('No se encontro el libro con el codigo ingresado.');
End;
Procedure mostrarSubOpciones(Var arch : archivoBinario);

Var 
  l : libro;
  opc: byte;

Begin
  Repeat
    writeln('---- OPCIONES ----');
    writeln('0. Volver');
    writeln('1. Dar de alta');
    writeln('2. Modificar libro');
    writeln('3. Eliminar libro');
    readln(opc);
    Case opc Of 
      1:
         Begin
           leerLibro(l,true);
           insertarLibro(arch,l);
         End;
      2:
         Begin
           Write('Ingresa el codigo del libro a modificar: ');
           readln(l.code);
           modificarLibro(arch,l)
         End;
      3:
         Begin
           Write('Ingresa el codigo del libro a eliminar: ');
           readln(l.code);
           eliminarLibro(arch,l)
         End;
    End;
  Until opc = 0;

End;
Procedure exportarTxt(Var arch: archivoBinario; Var txt: Text);

Var 
  l : libro;
Begin
  rewrite(txt);
  reset(arch);
  seek(arch,1);
  While (Not(eof(arch))) Do
    Begin
      read(arch,l);
      If (l.code>0) Then
        Begin
          writeln(txt,l.code, ' ',l.cantPaginas,' ',l.autor);
          writeln(txt,l.precio: 0: 2,' ',l.titulo);
          writeln(txt, l.genero);
        End;
    End;
  close(txt);
  close(arch);
End;

Var 
  arch: archivoBinario;
  opc: byte;
  nombreArchivo: String[30];
  txt: Text;
Begin

  Repeat
    writeln('---- OPCIONES ----');
    writeln('0. Terminar programa');
    writeln('1. Crear archivo');
    writeln('2. Abrir archivo');
    readln(opc);
    If ((opc > 0) And (opc<4)) Then
      Begin
        Write('Ingresa el nombre del archivo: ');
        readln(nombreArchivo);
        assign(arch,nombreArchivo);
        assign(txt,'libros.txt');
      End;
    Case opc Of 
      1: crearArchivo(arch);
      2:
         Begin
           reset(arch);
           mostrarSubOpciones(arch);
           close(arch);
         End;
      3: exportarTxt(arch,txt);

    End;
  Until opc = 0;

End.
