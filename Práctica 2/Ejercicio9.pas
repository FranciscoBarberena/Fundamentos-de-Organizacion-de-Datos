
Program ejercicio9;

Const 
  valorAlto = 9999;

Type 
  clientes = Record
    code : integer;
    nombre: string[40];
    apellido: string[40];
  End;
  date = Record
    year: integer;
    month: integer;
    day: integer;
  End;
  venta = Record
    cliente : clientes;
    fecha : date;
    monto : real;
  End;
  archivoMaestro = file Of venta;
Procedure leer (Var mae: archivoMaestro; Var v: venta);
Begin
  If (Not(eof(mae))) Then
    read(mae,v)
  Else v.cliente.code := valorAlto;
End;
//Proceso para generar datos y poder probar el codigo
Procedure generarDatosDePrueba(Var mae: archivoMaestro);

Var 
  v: venta;
Begin
  Rewrite(mae);

  v.cliente.code := 100;
  v.cliente.nombre := 'Carlos';
  v.cliente.apellido := 'Perez';

  v.fecha.year := 2025;
  v.fecha.month := 1;
  v.fecha.day := 10;
  v.monto := 1500.00;
  Write(mae, v);
  v.fecha.year := 2025;
  v.fecha.month := 1;
  v.fecha.day := 25;
  v.monto := 500.00;
  Write(mae, v);

  v.fecha.year := 2025;
  v.fecha.month := 3;
  v.fecha.day := 15;
  v.monto := 3000.00;
  Write(mae, v);

  v.fecha.year := 2026;
  v.fecha.month := 1;
  v.fecha.day := 5;
  v.monto := 4000.00;
  Write(mae, v);

  v.cliente.code := 200;
  v.cliente.nombre := 'Maria';
  v.cliente.apellido := 'Gonzales';

  v.fecha.year := 2025;
  v.fecha.month := 5;
  v.fecha.day := 12;
  v.monto := 8000.00;
  Write(mae, v);

  Close(mae);
End;

Var 
  mae: archivoMaestro;
  regm: venta;
  clienteActual: clientes;
  fechaActual: date;
  montoAnual, montoMensual,montoTotal : real;
Begin
  Assign(mae,'maestro.dat');
  generarDatosDePrueba(mae);
  reset(mae);
  leer(mae,regm);
  montoTotal := 0;

  While (regm.cliente.code <> valorAlto) Do
    Begin
      clienteActual := regm.cliente;
      writeln('Informacion del cliente:');
      writeln('Codigo: ',clienteActual.code);
      writeln('Nombre: ',clienteActual.nombre);
      writeln('Apellido: ',clienteActual.apellido);
      writeln('---------------------------------------');

      While (regm.cliente.code = clienteActual.code)  Do
        Begin
          montoAnual := 0;
          fechaActual.year := regm.fecha.year;
          While (regm.cliente.code = clienteActual.code) And (fechaActual.year = regm.fecha.year) Do
            Begin
              fechaActual.month := regm.fecha.month;
              montoMensual := 0;
              While (regm.cliente.code = clienteActual.code) And (fechaActual.year = regm.fecha.year) And (fechaActual.month = regm.fecha.month) Do
                Begin
                  montoMensual := montoMensual + regm.monto;
                  leer(mae,regm);
                End;
              writeln('     Recaudado en el mes ',fechaActual.month,' del anio ',fechaActual.year,': $',montoMensual: 0: 2);
              montoAnual := montoAnual + montoMensual;
            End;
          writeln('     Total del ',fechaActual.year,': $',montoAnual: 0: 2);
          writeln('---------------------------------------');

          montoTotal := montoTotal + montoAnual;
        End;

    End;
  writeln('Total recaudado por la empresa: $',montoTotal:0:2);
  close(mae);
End.
