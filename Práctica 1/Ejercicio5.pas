
Program ejercicio5;

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

Var 
  celularesTxt: Text;
  archivoBinCelulares: archivoBinario;
  nombreArchivo: string;
  opc: Byte;
Begin
  //Para crear el archivo dado en el ejemplo
  assign(celularesTxt,'celulares.txt');
  rewrite(celularesTxt);
  write(celularesTxt,'101 250000 Samsung',#13#10,'15 5 Galaxy A15 128GB',#13#10,'Galaxy A15',#13#10,'102 320000 Motorola',#13#10,
        '3 6 Moto G84 256GB color azul',#13#10,'Moto G84',#13#10,'104 950000 Apple',#13#10,'2 4 iPhone 15 256GB negro',#13#10,'iPhone 15');
  close(celularesTxt);

  writeln('0. Terminar programa');
  writeln('1. Pasar a archivo binario');
  writeln('2. Imprimir celulares con stock por debajo del minimo');
  writeln('3. Imprimir celulares con descripcion escrita por el usuario');
  writeln('4. Exportar a un archivo de texto');
  Repeat
    write('Ingrese la opcion a elegir: ');
    readln(opc);
    If ((opc > 0) And (opc<5)) Then
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
    End;
  Until opc = 0;


End.
