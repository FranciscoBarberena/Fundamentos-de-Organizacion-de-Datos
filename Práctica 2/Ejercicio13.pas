
Program ejercicio13;

Const 
  valorAlto = 9999;

Type 
  registroMaestro = Record
    numUsuario: integer;
    username: string[40];
    nombre: string[40];
    apellido: string[40];
    cantidadMails: integer;
  End;
  registroDetalle = Record
    numUsuario: integer;
    cuentaDestino: string[40];
    cuerpoMensaje: string;
  End;
  archivoMaestro = file Of registroMaestro;
  archivoDetalle = file Of registroDetalle;
Procedure leerMae(Var mae: archivoMaestro; Var regm: registroMaestro);
Begin
  If (Not(eof(mae))) Then
    read(mae,regm)
  Else regm.numUsuario := valorAlto;
End;
Procedure leerDet(Var det: archivoDetalle; Var regd: registroDetalle);

Begin
  If (Not(eof(det))) Then
    read(det,regd)
  Else regd.numUsuario := valorAlto;
End;
Procedure actualizarMaestro(Var mae: archivoMaestro; Var det: archivoDetalle);

Var 
  regd : registroDetalle;
  regm: registroMaestro;
Begin
  reset(det);
  reset(mae);
  leerDet(det,regd);
  While (regd.numUsuario <> valorAlto) Do
    Begin
      leerMae(mae,regm);
      While (regm.numUsuario<>regd.numUsuario) Do
        Begin
          leerMae(mae,regm);
        End;
      seek(mae,filePos(mae)-1);
      While (regd.numUsuario = regm.numUsuario) Do
        Begin
          regm.cantidadMails := regm.cantidadMails + 1;
          leerDet(det,regd);
        End;
      write(mae,regm);
    End;
  close(mae);
  close(det);
End;
Procedure generarInforme(Var txt : Text; Var det : archivoDetalle; Var mae : archivoMaestro);

Var 
  regd: registroDetalle;
  cantMails: integer;
  regm: registroMaestro;
Begin
  reset(det);
  rewrite(txt);
  reset(mae);
  leerMae(mae,regm);
  leerDet(det,regd);

  While (regm.numUsuario <> valorAlto) Do
    Begin
      
      cantMails := 0;
      While (regm.numUsuario = regd.numUsuario) Do
        Begin
          cantMails := cantMails + 1;
          leerDet(det,regd);
        End;
      writeln(txt,'num_usuario',regm.numUsuario,'.................',cantMails);
      leerMae(mae,regm);
    End;
  close(det);
  close(txt);
  close(mae);
End;

Var 
  mae: archivoMaestro;
  det: archivoDetalle;
  txt: Text;
Begin
  Assign(mae,'/Var/log/logmail.dat');
  Assign(det,'detalle.dat');
  Assign(txt,'informe.txt');
  actualizarMaestro(mae,det);
  generarInforme(txt,det,mae);
End.
