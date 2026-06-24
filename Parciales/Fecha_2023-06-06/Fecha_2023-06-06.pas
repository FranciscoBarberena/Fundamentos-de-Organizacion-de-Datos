
Program examen;

Type 
  Producto = Record
    code: integer;
    nombre: string[40];
    desc: string;
    pCompra: real;
    pVenta: real;
    ubicacion: string;
  End;

  tArchProd = File Of Producto;

  // Function existeProducto (var a : archivo, code : integer) : boolean; ASUMO QUE DEVUELVE EL PUNTERO DEL ARCHIVO TAL CUAL LO RECIBIÓ

Procedure AgregarProducto (Var a: tArchProd);

Var 
  P, cabecera: Producto;
Begin
  reset(a);
  readln(P.code);
  If (Not(existeProducto(a, P.code))) Then
    Begin
      readln(P.nombre);
      readln(P.desc);
      readln(P.ubicacion);
      readln(P.pVenta);
      readln(P.pCompra);

      If (EOF(a)) Then
        Begin
          cabecera.code := 0;
          write(a, cabecera);
          write(a, P);
        End
      Else
        Begin
          Seek(a, 0);
          read(a, cabecera);

          If (cabecera.code >= 0) Then
            Begin
              Seek(a, FileSize(a));
              write(a, P);
            End
          Else
            Begin
              Seek(a, -cabecera.code);
              read(a, cabecera);
              Seek(a, FilePos(a)-1);
              write(a, P);
              Seek(a, 0);
              write(a, cabecera);
            End;
        End;
    End
  Else
    writeln('El producto ya existe');

  close(a);
End;

Procedure QuitarProducto (Var a: tArchProd);

Var 
  cabecera, P: Producto;
  code: integer;
  encontre: boolean;
Begin
  reset(a);
  If (Not(EOF(a))) Then
    Begin
      read(a, cabecera);
      readln(code);

      If (existeProducto(a, code)) Then
        Begin
          encontre := false;
          While (Not(EOF(a))) And (Not encontre) Do
            Begin
              read(a, P);
              If (P.code = code) Then
                Begin
                  P.code := cabecera.code;
                  Seek(a, FilePos(a)-1);
                  write(a, P);
                  cabecera.code := -(FilePos(a)-1);
                  encontre := true;
                  Seek(a, 0);
                  write(a, cabecera);
                End;
            End;
        End
      Else
        writeln('No existe el producto');
    End;
  close(a);
End;
