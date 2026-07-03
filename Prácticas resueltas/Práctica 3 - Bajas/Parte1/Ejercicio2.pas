
Program ejercicio2;

Type 
  producto = Record
    code: integer;
    nombre: string[30];
    desc: string;
    precio: real;
    stock: integer;
  End;
  archivoBinario = file Of producto;
Procedure cargarProducto(Var p: producto);
Begin
  write('Ingrese codigo de producto (o -1 para terminar): ');
  readln(p.code);
  If (p.code <> -1) Then
    Begin
      write('Ingrese nombre: ');
      readln(p.nombre);
      write('Ingrese descripcion: ');
      readln(p.desc);
      write('Ingrese precio: ');
      readln(p.precio);
      write('Ingrese stock: ');
      readln(p.stock);
      writeln('-----------------------------------');
    End;
End;

Procedure generarArchivo(Var archivo: archivoBinario);

Var 
  p: producto;
Begin
  Assign(archivo, 'productos.dat');
  Rewrite(archivo);
  cargarProducto(p);
  While (p.code <> -1) Do
    Begin
      write(archivo, p);
      cargarProducto(p);
    End;
  close(archivo);
  writeln('Archivo generado exitosamente.');
End;
Procedure realizarBajasLogicas(Var archivo: archivoBinario);

Var 
  p : producto;
Begin
  reset(archivo);
  While (Not(eof(archivo))) Do
    Begin
      read(archivo, p);
      If (p.stock = 0) Then
        Begin
          p.nombre := '@'+p.nombre;
          seek(archivo, filePos(archivo)-1);
          write(archivo,p);
        End;
    End;
  close(archivo);
End;

Var 
  archivo : archivoBinario;
Begin
  generarArchivo(archivo);
  realizarBajasLogicas(archivo);
End.
