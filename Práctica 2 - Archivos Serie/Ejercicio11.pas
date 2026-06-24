
Program ejercicio11;

Const 
  valorAlto = 9999;
  cantCategorias = 15;

Type 
  empleado = Record
    depto : integer;
    division: integer;
    numero: integer;
    categoria: integer;
    horas: integer;
  End;
  categoriaHoras = array[1..cantCategorias] Of real;
  archivoMaestro = file Of empleado;


Var 
  mae: archivoMaestro;
  categoriasTxt: Text;

Procedure leer(Var mae: archivoMaestro; Var e: empleado);
Begin
  If (Not(eof(mae))) Then
    read(mae,e)
  Else e.depto := valorAlto;
End;
Procedure cargarVector(Var v: categoriaHoras; Var arch: Text);

Var 
  i,categoria : integer;
  valor: real;
Begin
  For i:= 1 To cantCategorias Do
    Begin
      read(arch,categoria,valor);
      v[categoria] := valor;
    End;
End;

//Proceso para datos de ejemplo
Procedure generarDatosDePrueba(Var mae: archivoMaestro; Var categoriasTxt: Text);

Var 
  e: empleado;
  i: integer;
Begin
  Rewrite(categoriasTxt);
  For i := 1 To cantCategorias Do
    Begin
      writeln(categoriasTxt, i, ' ', i * 1000.00:0:2);
    End;
  Close(categoriasTxt);

  Rewrite(mae);


  e.depto := 1;
  e.division := 1;

  e.numero := 100;
  e.categoria := 1;
  e.horas := 5;
  Write(mae, e);
  e.numero := 100;
  e.categoria := 1;
  e.horas := 3;
  Write(mae, e);

  e.numero := 102;
  e.categoria := 2;
  e.horas := 4;
  Write(mae, e);

  e.depto := 1;
  e.division := 2;

  e.numero := 105;
  e.categoria := 3;
  e.horas := 10;
  Write(mae, e);


  e.depto := 2;
  e.division := 1;

  e.numero := 200;
  e.categoria := 5;
  e.horas := 2;
  Write(mae, e);

  Close(mae);
End;

Var 
  v: categoriaHoras;
  empleadoActual,regm: empleado;
  horasEmpleado,horasDivision,horasDepto: integer;
  montoEmpleado, montoDivision, montoDepto: real;

Begin
  Assign(mae,'maestro.dat');
  Assign(categoriasTxt,'categorias.txt');
  generarDatosDePrueba(mae, categoriasTxt);
  reset(categoriasTxt);
  cargarVector(v,categoriasTxt);
  reset(mae);
  leer(mae,regm);

  While (regm.depto <> valorAlto) Do
    Begin
      horasDepto := 0;
      montoDepto := 0;
      empleadoActual.depto := regm.depto;
      writeln('------- Departamento ',empleadoActual.depto,' -------');
      While (regm.depto = empleadoActual.depto) Do
        Begin
          empleadoActual.division := regm.division;
          horasDivision := 0;
          montoDivision := 0;
          writeln('--- Division ',empleadoActual.division,' ---');
          While (regm.depto = empleadoActual.depto) And (empleadoActual.division = regm.division) Do
            Begin
              empleadoActual.numero := regm.numero;
              horasEmpleado := 0;
              montoEmpleado := 0;
              While (regm.depto = empleadoActual.depto) And (empleadoActual.division = regm.division) And (empleadoActual.numero = regm.numero) Do
                Begin
                  horasEmpleado := horasEmpleado + regm.horas;
                  montoEmpleado := montoEmpleado + regm.horas*v[regm.categoria];
                  leer(mae,regm);
                End;
              writeln('Empleado ',empleadoActual.numero,': ',horasEmpleado,'hs. ($',montoEmpleado: 0: 2,')');
              horasDivision := horasDivision + horasEmpleado;
              montoDivision := montoDivision + montoEmpleado;
            End;
          writeln('Total de horas por division: ',horasDivision);
          writeln('Monto total por division: $',montoDivision: 0: 2);
          horasDepto := horasDepto + horasDivision;
          montoDepto := montoDepto + montoDivision;
        End;
      writeln('Total de horas por departamento: ',horasDepto);
      writeln('Monto total por departamento: $',montoDepto:0:2);
    End;
  close(mae);
  close(categoriasTxt);
End.
