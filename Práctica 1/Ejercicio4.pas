
Program ejercicio4;

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
Function yaEstaCargado(numABuscar: integer; Var archivo: archivoEmp) : boolean;

Var e : empleado;
  encontro: boolean;
Begin
  reset(archivo);
  encontro := false;
  While ((Not eof(archivo)) And (Not encontro)) Do
    Begin
      read(archivo,e);
      If (e.numero = numABuscar) Then
        encontro := true;
    End;
  yaEstaCargado := encontro;
End;

Procedure leerEmpleado(Var e : empleado; Var archivo: archivoEmp);
Begin
  writeln('Ingrese un nombre: ');
  readln(e.nombre);
  writeln('Ingrese un numero de empleado: ');
  readln(e.numero);
  If (Not  yaEstaCargado(e.numero,archivo)) Then
    Begin
      writeln('Ingrese un DNI: ');
      readln(e.DNI);

      writeln('Ingrese una edad: ');
      readln(e.edad);
    End;
End;
Procedure leerApellido(Var a : String);
Begin
  writeln('Ingrese un apellido ("fin" para terminar): ');
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
      leerEmpleado(e, miArchivo);
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



Procedure agregarEmpleados(Var archivo: archivoEmp);

Var e: empleado;
Begin
  reset(archivo);
  seek( archivo, filesize(archivo));
  leerApellido(e.apellido);
  While (e.apellido <> 'fin') Do
    Begin
      leerEmpleado(e,archivo);
      If (Not yaEstaCargado(e.numero, archivo)) Then
        write(archivo, e)
      Else writeln('El empleado ',e.numero,' ya esta cargado.');
      leerApellido(e.apellido);
    End;
End;

Procedure modificarEdad(Var archivo: archivoEmp);

Var 
  encontre: boolean;
  e : empleado;
  numAModificar: Integer;
Begin
  writeln('Ingrese el numero del empleado cuya edad quiere cambiar');
  readln(numAModificar);
  encontre := false;
  reset(archivo);
  While ((Not eof(archivo)) And (Not encontre)) Do
    Begin
      read(archivo,e);
      If (e.numero = numAModificar) Then
        encontre := true
    End;
  If (encontre) Then
    Begin
      seek (archivo, filePos(archivo) - 1);
      writeln('Ingrese la nueva edad: ');
      readln(e.edad);
      write(archivo,e);
    End
  Else writeln('El empleado no esta cargado')
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
  writeln('Seleccione la operacion deseada:',#13#10,'1: Buscar un empleado.',#13#10,'2: Listar todos los empleados.',#13#10,'3: Listar todos los empleados mayores de 70 anios.',
          #13#10,'4: Agregar empleados.',#13#10,'5: Modficar una edad.');
  readln(opcionElegida);
  While (Not opcionValida) Do
    Begin
      Case opcionElegida Of 
        1:
           Begin
             opcionValida := true;
             writeln('Ingrese el nombre o apellido a buscar:');
             readln(nombreApellido);
             buscarEmpleado(archivo,nombreApellido);
           End;
        2:
           Begin
             opcionValida := true;
             imprimirArchivo(archivo);
           End;
        3:
           Begin
             opcionValida := true;

             imprimirMayores(archivo);
           End;
        4:
           Begin
             opcionValida := true;

             agregarEmpleados(archivo);
           End;
        5:
           Begin
             opcionValida := true;

             modificarEdad(archivo)
           End;

        Else
          Begin

            writeln('Ingrese un numero valido (entre 1 y 5).');
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
