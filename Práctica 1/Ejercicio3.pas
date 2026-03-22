
Program ejercicio3;

Type 

  str20 = string[20];
  empleado = Record
    apellido: str20;
    nombre: str20;
    numero: integer;
    edad: integer;
    DNI: integer;
  End;
  lista = ^nodo;
  nodo = Record
    dato: empleado;
    sig: lista;
  End;
  archivoEmp = file Of empleado;
Procedure leerEmpleado(Var e : empleado);
Begin
  writeln('Ingrese un nombre: ');
  readln(e.nombre);
  writeln('Ingrese un DNI: ');
  readln(e.DNI);
  writeln('Ingrese un numero de empleado: ');
  readln(e.numero);
  writeln('Ingrese una edad: ');
  readln(e.edad);
End;
Procedure leerApellido(Var a : String);
Begin
  writeln('Ingrese un apellido: ');
  readln(a);

End;
Procedure nombrarArchivo(Var archivo: archivoEmp);

Var 
  nombre: string;
Begin
  writeln('Ingresa el nombre del archivo: ');
  readln(nombre);
  assign(archivo,nombre);
End;
Procedure crearArchivo(Var miArchivo: archivoEmp);

Var 
  e : empleado;
Begin
  rewrite(miArchivo);
  leerApellido(e.apellido);
  While (e.apellido <> 'fin') Do
    Begin
      leerEmpleado(e);
      write(miArchivo, e);
      leerApellido(e.apellido);
    End;
End;
Procedure agregarAdelante(Var l: lista; e: empleado);

Var 
  aux : lista;
Begin
  new(aux);
  aux^.dato := e;
  aux^.sig := l;
  l := aux;
End;
Procedure imprimirEmpleado(e: empleado);
Begin
  writeln(e.apellido, ' ',e.nombre,' ', e.edad,' ',e.numero,' ',e.DNI);
End;
Procedure imprimirListaBuscada(l: lista);
Begin
  While (l<>Nil) Do
    Begin
      imprimirEmpleado(l^.dato);
      l := l^.sig;
    End;
End;
Procedure buscarEmpleado (Var archivo: archivoEmp; nombreApellido: str20);

Var 
  e: empleado;
  listaBuscada: lista;
Begin
  listaBuscada := Nil;
  reset(archivo);
  While (Not EOF(archivo)) Do
    Begin
      read(archivo,e);
      If ((e.apellido = nombreApellido) Or (e.nombre = nombreApellido)) Then
        agregarAdelante (listaBuscada, e);
    End;
  If (listaBuscada<>Nil) Then
    imprimirListaBuscada(listaBuscada)
  Else writeln('Empleado no encontrado.');
  close(archivo);
End;
Procedure imprimirArchivo(Var archivo: archivoEmp);

Var e : empleado;
Begin
  reset(archivo);
  While (Not eof(archivo)) Do
    Begin
      read(archivo,e);
      imprimirEmpleado(e);
    End;
  close(archivo);
End;
Procedure imprimirMayores(Var archivo: archivoEmp);

Var 
    e : empleado;
    listaBuscada: lista;

Begin
  listaBuscada := Nil;
  reset(archivo);
  While (Not EOF(archivo)) Do
    Begin
      read(archivo,e);
      If (e.edad > 70) Then
        agregarAdelante (listaBuscada, e);
    End;
  If (listaBuscada<>Nil) Then
    imprimirListaBuscada(listaBuscada)
  Else writeln('No hay empleados mayores de 70.');
  close(archivo);
End;

Procedure mostrarSubOpciones(Var archivo: archivoEmp);

Var 
  opcionElegida: integer;
  opcionValida: boolean;
  nombreApellido: str20;
  nombre: string;
Begin
  reset(archivo);
  opcionValida := false;
  writeln('Seleccione la operacion deseada:',#13#10,'1: Buscar un empleado.',#13#10,'2: Listar todos los empleados.',#13#10,'3: Listar todos los empleados mayores de 70 anios.');
  readln(opcionElegida);
  While (opcionValida = false) Do
    Begin
      Case opcionElegida Of 
        1:
           Begin
             opcionValida := True;
             writeln('Ingrese el nombre o apellido a buscar:');
             readln(nombreApellido);
             buscarEmpleado(archivo,nombreApellido);
           End;
        2:
           Begin
             opcionValida := True;
             imprimirArchivo(archivo);
           End;
        3:
           Begin
             opcionValida := True;
             imprimirMayores(archivo);
           End;
        Else
          Begin
            writeln('Ingrese un número entre 1 y 3.');
            readln(opcionElegida);
          End;
      End;

    End;
End;

Var 
  miArchivo: archivoEmp;
  opcionElegida: integer;
  opcionValida: boolean;
Begin
  nombrarArchivo(miArchivo);
  opcionValida := false;
  writeln('---- MENU ----');
  writeln('Seleccione la opcion deseada:',#13#10,'1: Crear archivo.',#13#10,'2: Abrir archivo.');
  readln(opcionElegida);
  While (opcionValida = false) Do
    Begin
      Case opcionElegida Of 
        1:
           Begin
             opcionValida := True;
             crearArchivo(miArchivo);
           End;
        2:
           Begin
             opcionValida := True;
             mostrarSubOpciones(miArchivo);
           End;
        Else
          Begin
            writeln('Ingrese un número entre 1 y 2');
            readln(opcionElegida);
          End;
      End;
    End;

End.
