
Program ejercicio4;
//Todo este punto es pseudocódigo

Const 
  M = 5;
Procedure posicionarYLeerNodo(Var A: archivo, Var nodo: nodoIndice, NRR: integer);
Begin
  seek(A, NRR);
  read(A, nodo);
End;
Procedure claveEncontrada(Var A: archivo, nodo: nodoIndice, clave: integer, Var pos: integer,Var clave_encontrada: boolean);

Var 
  i: integer;
Begin
  i := 1;
  clave_encontrada := false;
  While (i <= nodo.cantClaves) And (clave > nodo.datos[i]) Do
    i := i + 1;
  If (i <= nodo.cantClaves) And (clave = nodo.datos[i]) Then
    Begin
      clave_encontrada := true;
      pos := i;
    End
  Else
    Begin
      clave_encontrada := false;
      pos := i;
    End;
End;
