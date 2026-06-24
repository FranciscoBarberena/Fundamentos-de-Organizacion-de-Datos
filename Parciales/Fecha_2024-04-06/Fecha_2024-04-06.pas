
Program examen;

Const 
  valorAlto = 30000;

Type 
  Prestamo = Record
    numSucursal: integer;
    DNI: string[8];
    numPrestamo: integer;
    fecha: string[10];
    monto: real;
  End;

  tArchPres = file Of Prestamo;

Procedure leer(Var a: tArchPres; Var reg: Prestamo);
Begin
  If (Not EOF(a)) Then
    read(a, reg)
  Else
    reg.numSucursal := valorAlto;
End;

Procedure generarTxt(Var a: tArchPres; Var txt: Text);

Var 
  reg, PActual: Prestamo;
  ventasTotSu, ventasTotEmp, ventasTotAno, ventasTot: integer;
  montoTotSu, montoTotEmp, montoTotAno, montoTot: real;
  anoActual: string;
Begin
  reset(a);
  rewrite(txt);

  writeln(txt, 'Informe de ventas de la empresa');
  montoTot := 0;
  ventasTot := 0;

  leer(a, reg);

  While (reg.numSucursal <> valorAlto) Do
    Begin
      montoTotSu := 0;
      ventasTotSu := 0;
      PActual := reg;

      writeln(txt, 'Sucursal <', PActual.numSucursal, '>');

      While (reg.numSucursal = PActual.numSucursal) Do
        Begin
          PActual.DNI := reg.DNI;
          montoTotEmp := 0;
          ventasTotEmp := 0;

          writeln(txt, '    Empleado: DNI <', PActual.DNI, '>');
          writeln(txt, '    Año          Cantidad de ventas          Monto de ventas');

          While (reg.numSucursal = PActual.numSucursal) And (reg.DNI = PActual.DNI) Do
            Begin
              anoActual := extraerAño(reg.fecha);
              ventasTotAno := 0;
              montoTotAno := 0;

              While (reg.numSucursal = PActual.numSucursal) And
                    (reg.DNI = PActual.DNI) And
                    (extraerAño(reg.fecha) = anoActual) Do
                Begin

                  ventasTotAno := ventasTotAno + 1;
                  montoTotAno := montoTotAno + reg.monto;
                  leer(a, reg);
                End;

              writeln(txt, '    ', anoActual, '                 ', ventasTotAno, '                     ', montoTotAno:0:2);

              ventasTotEmp := ventasTotEmp + ventasTotAno;
              montoTotEmp := montoTotEmp + montoTotAno;
            End;

          writeln(txt, '    Totales          <', ventasTotEmp, '>                  <', montoTotEmp:0:2, '>');
          writeln(txt, '    Empleado: DNI <', PActual.DNI, '>');

          ventasTotSu := ventasTotSu + ventasTotEmp;
          montoTotSu := montoTotSu + montoTotEmp;
        End;

      writeln(txt, 'Cantidad total de ventas sucursal: ', ventasTotSu);
      writeln(txt, 'Monto total vendido por sucursal: ', montoTotSu:0:2);

      ventasTot := ventasTot + ventasTotSu;
      montoTot := montoTot + montoTotSu;
    End;

  writeln(txt, 'Cantidad de ventas de la empresa: ', ventasTot);
  writeln(txt, 'Monto total vendido por la empresa: ', montoTot:0:2);

  close(txt);
  close(a);
End;

Var 
  a: tArchPres;
  txt: Text;
Begin

End.
