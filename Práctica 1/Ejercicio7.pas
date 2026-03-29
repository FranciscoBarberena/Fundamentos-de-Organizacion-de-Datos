
Program ejercicio7;

Type 
  novela = Record
    codigo: integer;
    precio: real;
    genero: string;
    titulo: string;
  End;
  archivoBinario = file Of novela;

Procedure cargarBinario(Var binario: archivoBinario; Var txt: Text);

Var 
  nov: novela;
Begin
  reset(txt);
  rewrite(binario);
  While (Not eof(txt)) Do
    Begin
      readln(txt,nov.codigo,nov.precio,nov.genero);
      readln(txt,nov.titulo);
      write(binario,nov);
    End;
  close(txt);
  close(binario);
End;

Procedure leerNovela(Var nov: novela);
Begin
  write('Ingrese el precio de la novela: ');
  readln(nov.precio);
  write('Ingrese el genero de la novela: ');
  readln(nov.genero);
  write('Ingrese el titulo de la novela: ');
  readln(nov.titulo);

End;

Function estaEnElArchivo(Var archivoNovelas: archivoBinario; code: integer) : boolean;

Var 
  encontre : boolean;
  nov: novela;
Begin
  reset(archivoNovelas);
  encontre := false;
  While ((Not eof(archivoNovelas)) And (Not encontre)) Do
    Begin
      read(archivoNovelas,nov);
      If (nov.codigo = code) Then
        encontre := true;
    End;
  estaEnElArchivo := encontre;
End;

Procedure agregarNovela(Var archivoNovelas: archivoBinario; nov: novela);
Begin
  If (Not estaEnElArchivo(archivoNovelas,nov.codigo)) Then
    Begin
      write(archivoNovelas,nov);
    End
  Else writeln('La novela ya estaba agregada.');
End;

Procedure modificarNovela(Var archivoNovelas: archivoBinario);

Var 
  nov: novela;

Begin
  write('Ingrese el codigo de la novela: ');
  readln(nov.codigo);
  If (estaEnElArchivo(archivoNovelas,nov.codigo)) Then
    Begin
      writeln('Ingresa los datos actualizados de la novela: ');
      leerNovela(nov);
      seek(archivoNovelas, FilePos(archivoNovelas)-1);
      write(archivoNovelas,nov);
    End
  Else
    writeln('La novela no se puede modificar porque no se encuentra en el archivo.');

End;

Procedure mostrarSubOpciones(Var archivoNovelas: archivoBinario);

Var 
  opc: byte;
  nov: novela;
Begin
  Repeat
    writeln('--- OPCIONES ---');
    writeln('0. Cerrar archivo');
    writeln('1. Agregar una novela');
    writeln('2. Modificar una novela');
    write('Ingresa la opcion a elegir: ');
    readln(opc);
    Case opc Of 
      1:
         Begin
           write('Ingrese el codigo de la novela: ');
           readln(nov.codigo);
           If (Not estaEnElArchivo(archivoNovelas,nov.codigo)) Then
             leerNovela(nov);
           agregarNovela(archivoNovelas,nov);
         End;
      2: modificarNovela(archivoNovelas);
    End;

  Until opc = 0;

End;

Var 
  novelasTxt: Text;
  opc: Byte;
  archivoNovelas: archivoBinario;
  nombreArchivo: string;
Begin
  //Crea el archivo de carga
  assign(novelasTxt,'novelas.txt');
  rewrite(novelasTxt);
  write(novelasTxt,'100 30000 Ficcion',sLineBreak,'Rayuela',sLineBreak,'22 25000 Suspenso',sLineBreak,'La Furia');
  close(novelasTxt);
  Repeat
    writeln('--- OPCIONES ---');
    writeln('0. Terminar programa');
    writeln('1. Crear archivo binario');
    writeln('2. Abrir archivo binario');
    write('Ingresa la opcion a elegir: ');
    readln(opc);
    If ((opc > 0) And (opc < 3)) Then
      Begin
        write('Ingresa el nombre del archivo: ');
        readln(nombreArchivo);
        assign(archivoNovelas,nombreArchivo);
      End;
    Case opc Of 
      1: cargarBinario(archivoNovelas,novelasTxt);
      2: mostrarSubOpciones(archivoNovelas);
    End;
  Until opc = 0;
End.
