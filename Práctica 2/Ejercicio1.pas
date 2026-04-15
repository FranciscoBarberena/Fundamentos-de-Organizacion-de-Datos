
Program ejercicio1;

Const 
  valoralto = 30000;

Type 
  empleado = Record
    numero: integer;
    comisiones: real;
    nombre: string[30];
  End;
  archivo = file Of empleado;

Procedure leer( Var arch: archivo; Var dato: empleado);
Begin
  If (Not(EOF(arch))) Then
    read (arch, dato)
  Else
    dato.numero := valoralto;
End;

//Procesos para generar datos de ejemplo
Procedure GrabarEmpleado(Var arch: archivo; num: integer; com: real; nom: String);

Var 
  reg: empleado;
Begin
  reg.numero := num;
  reg.comisiones := com;
  reg.nombre := nom;
  Write(arch, reg);
End;
Procedure imprimirDetalle(Var det: archivo);

Var emp: empleado;
Begin
  reset(det);
  While Not(eof(det)) Do
    Begin
      read(det,emp);
      writeln('Nombre: ',emp.nombre);
      writeln('Numero: ',emp.numero);
      writeln('Total de comisiones: $',emp.comisiones:0:2);
    End;
End;

Var 
  mae, det: archivo;
  regm,regd: empleado;
  totalComisiones: real;
  numeroAct: integer;
  nombreAct : string[30];
Begin
  Assign(mae,'maestro.dat');
  //Datos de ejemplo para revisar que funcione
  rewrite(mae);
  GrabarEmpleado(mae, 100, 1500.50, 'Ana Lopez');
  GrabarEmpleado(mae, 100, 3200.00, 'Ana Lopez');
  GrabarEmpleado(mae, 102, 4500.00, 'Carlos Ruiz');
  GrabarEmpleado(mae, 105, 1200.00, 'Beatriz Silva');
  GrabarEmpleado(mae, 105, 800.75, 'Beatriz Silva');
  GrabarEmpleado(mae, 105, 2100.00, 'Beatriz Silva');
  GrabarEmpleado(mae, 110, 5000.00, 'Daniel Gomez');
  Close(mae);

  Assign(det,'detalle.dat');
  reset(mae);
  rewrite(det);
  leer(mae,regm);
  While (regm.numero <> valoralto) Do
    Begin
      nombreAct := regm.nombre;
      numeroAct := regm.numero;
      totalComisiones := 0;
      While (numeroAct = regm.numero) Do
        Begin
          totalComisiones := totalComisiones + regm.comisiones;
          leer(mae,regm);
        End;
      regd.numero := numeroAct;
      regd.comisiones := totalComisiones;
      regd.nombre := nombreAct;
      write(det,regd);
    End;
  imprimirDetalle(det);
  close(mae);
  close(det);

End.
