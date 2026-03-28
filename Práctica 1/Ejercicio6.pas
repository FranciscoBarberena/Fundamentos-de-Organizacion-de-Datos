
Program ejercicio6;

Type 
  celular = Record
    codigo: integer;
    nombre: string;
    descripcion: string;
    marca: string;
    precio: real;
    stockMin: integer;
    stockDisp: integer;
  End;

  archivoBinario = file Of celular;

Procedure imprimirCelular(Var c: celular);
Begin
  writeln('--------------------');
  writeln(c.codigo,' ',c.precio:0:0,' ',c.marca);
  writeln(c.stockDisp,' ',c.stockMin,' ',c.stockMin,' ',c.descripcion);
  writeln(c.nombre);
End;

Procedure imprimirStockEnFalta(Var archivo: archivoBinario);

Var c: celular;
Begin
  reset(archivo);
  writeln('-- Celulares con stock por debajo del minimo --');
  While (Not eof(archivo)) Do
    Begin
      read(archivo,c);
      If (c.stockDisp<c.stockMin) Then
        Begin
          imprimirCelular(c);
        End;
    End;
  close(archivo);
End;

Procedure cargarBinario(Var archText: Text;Var archCelulares: archivoBinario);

Var 
  cel : celular;
Begin
  reset(archText);
  rewrite(archCelulares);
  While (Not eof(archText)) Do
    Begin
      readln(archText, cel.codigo, cel.precio, cel.marca);
      readln(archText, cel.stockDisp, cel.stockMin, cel.descripcion);
      readln(archText, cel.nombre);
      write(archCelulares,cel);
    End;
  close(archCelulares);
  close(archText);
End;

Procedure exportarAArchivoDeTexto(Var archText: Text;Var archCelulares: archivoBinario);

Var 
  cel : celular;
Begin
  rewrite(archText);
  reset(archCelulares);
  While (Not eof(archCelulares)) Do
    Begin
      read(archCelulares,cel);
      writeln(archText,cel.codigo,' ',cel.precio:0:0,' ',cel.marca);
      writeln(archText,cel.stockDisp,' ', cel.stockMin, ' ',cel.descripcion);
      writeln(archText,cel.nombre);
    End;
  close(archCelulares);
  close(archText);
End;

Function estaEnElArchivo(Var archivo: archivoBinario; codigo: integer) : boolean;

Var 
  cel: celular;
  encontre : boolean;
Begin
  reset(archivo);
  encontre := false;
  While ((Not eof(archivo)) And (Not encontre)) Do
    Begin
      Read(archivo,cel);
      If (cel.codigo = codigo) Then
        encontre := true;
    End;
  estaEnElArchivo := encontre;
End;

Procedure leerCelular(Var archivo: archivoBinario;Var cel: celular);
Begin
  write('Ingrese el codigo del celular (0 para terminar): ');
  readln(cel.codigo);
  If ((cel.codigo <>0) And (Not estaEnElArchivo(archivo, cel.codigo))) Then
    Begin
      write('Ingrese el nombre del celular: ');
      readln(cel.nombre);
      write('Ingrese el precio del celular: ');
      readln(cel.precio);
      write('Ingrese la marca del celular: ');
      readln(cel.marca);
      write('Ingrese el stock disponible del celular: ');
      readln(cel.stockDisp);
      write('Ingrese el stock minimo del celular: ');
      readln(cel.stockMin);
      write('Ingrese la descripcion del celular: ');
      readln(cel.descripcion);
    End
  Else
    Begin
      If (cel.codigo <> 0) Then
        writeln('Ese celular ya esta en el archivo');
    End;

End;

Procedure agregarCelulares(Var archCelulares: archivoBinario);

Var 
  cel : celular;
Begin
  reset(archCelulares);
  seek(archCelulares,fileSize(archCelulares));
  leerCelular(archCelulares,cel);
  While (cel.codigo<>0) Do
    Begin
      seek(archCelulares,fileSize(archCelulares));
      write(archCelulares,cel);
      leerCelular(archCelulares,cel);
    End;
  close(archCelulares);
End;

Var 
  celularesTxt: Text;
  archivoBinCelulares: archivoBinario;
  nombreArchivo: string;
  opc: Byte;
Begin
  //Para crear el archivo dado en el ejemplo
  assign(celularesTxt,'celulares.txt');
  rewrite(celularesTxt);
  write(celularesTxt,'101 250000 Samsung',sLineBreak,'15 5 Galaxy A15 128GB',sLineBreak,'Galaxy A15',sLineBreak,'102 320000 Motorola',sLineBreak,
        '3 6 Moto G84 256GB color azul',sLineBreak,'Moto G84',sLineBreak,'104 950000 Apple',sLineBreak,'2 4 iPhone 15 256GB negro',sLineBreak,'iPhone 15');
  close(celularesTxt);

  Repeat
    writeln('---- OPCIONES ----');
    writeln('0. Terminar programa');
    writeln('1. Pasar a archivo binario');
    writeln('2. Imprimir celulares con stock por debajo del mínimo');
    writeln('3. Imprimir celulares con descripcion escrita por el usuario');
    writeln('4. Exportar a un archivo de texto');
    writeln('5. Agregar celulares');

    write('Ingrese la opcion a elegir: ');
    readln(opc);
    If ((opc > 0) And (opc<6)) Then
      Begin
        write('Ingresa el nombre del archivo: ');
        readln(nombreArchivo);
        assign(archivoBinCelulares,nombreArchivo);
      End;
    Case opc Of 
      1: cargarBinario(celularesTxt,archivoBinCelulares);
      2: imprimirStockEnFalta(archivoBinCelulares);
      //3: ???
      4: exportarAArchivoDeTexto(celularesTxt,archivoBinCelulares);
      5: agregarCelulares(archivoBinCelulares);
    End;
  Until opc = 0;


End.
