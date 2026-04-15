
Program ejercicio3;

Const 
  valorAlto = 'ZZZZ';

Type 
  provincia = Record
    nombre: string[50];
    cantAlfabetizados: integer;
    cantEncuestados: integer;
  End;
  encuesta = Record
    prov : string[50];
    localidad: string[50];
    cantAlfabetizados: integer;
    cantEncuestados: integer;
  End;
  archivoMaestro = file Of provincia;
  archivoDetalle = file Of encuesta;

Var 
  det1,det2: archivoDetalle;
  mae: archivoMaestro;

Procedure leer(Var arch: archivoDetalle; Var enc : encuesta);
Begin
  If (Not(eof(arch))) Then
    read(arch,enc)
  Else enc.prov := valorAlto;
End;
Procedure minimo (Var regd1: encuesta; Var regd2: encuesta; Var min: encuesta);
Begin
  If (regd1.prov<regd2.prov) Then
    Begin
      min := regd1;
      leer(det1,regd1);
    End
  Else
    Begin
      min := regd2;
      leer(det2,regd2);
    End;
End;
//Procesos para datos de ejemplo

Procedure imprimirMaestro();

Var p : provincia;
Begin
  Reset(mae);

  While Not eof(mae) Do
    Begin
      Read(mae, p);
      writeln('Provincia: ', p.nombre);
      writeln('  Alfabetizados: ', p.cantAlfabetizados);
      writeln('  Encuestados: ', p.cantEncuestados);
      writeln('--------------------------');
    End;
    writeln();

  Close(mae);
End;

Var 
  regd1,regd2,min : encuesta;
  regm: provincia;
Begin
  Assign(mae, 'maestro.dat');
  Assign(det1, 'detalle1.dat');
  Assign(det2, 'detalle2.dat');

  Rewrite(mae);
  Rewrite(det1);
  Rewrite(det2);

//Datos de ejemplo
  regm.nombre := 'Buenos Aires';
  regm.cantAlfabetizados := 5000;
  regm.cantEncuestados := 6000;
  Write(mae, regm);
  regm.nombre := 'Cordoba';
  regm.cantAlfabetizados := 3000;
  regm.cantEncuestados := 3500;
  Write(mae, regm);
  regm.nombre := 'Santa Fe';
  regm.cantAlfabetizados := 4000;
  regm.cantEncuestados := 4500;
  Write(mae, regm);
  Close(mae);

  regd1.prov := 'Buenos Aires';
  regd1.localidad := 'La Plata';
  regd1.cantAlfabetizados := 100;
  regd1.cantEncuestados := 150;
  Write(det1, regd1);
  regd1.prov := 'Cordoba';
  regd1.localidad := 'Capital';
  regd1.cantAlfabetizados := 50;
  regd1.cantEncuestados := 80;
  Write(det1, regd1);
  Close(det1);

  regd2.prov := 'Buenos Aires';
  regd2.localidad := 'Mar del Plata';
  regd2.cantAlfabetizados := 200;
  regd2.cantEncuestados := 250;
  Write(det2, regd2);
  regd2.prov := 'Santa Fe';
  regd2.localidad := 'Rosario';
  regd2.cantAlfabetizados := 300;
  regd2.cantEncuestados := 320;
  Write(det2, regd2);
  Close(det2);

  writeln('Maestro ANTES de la actualizacion: ');
  imprimirMaestro();

  //Resolucion del enunciado
  reset(det1);
  reset(det2);
  reset(mae);
  leer(det1,regd1);
  leer(det2,regd2);
  minimo(regd1,regd2,min);
  While (min.prov <> valorAlto) Do
    Begin
      read(mae,regm);
      While (regm.nombre< min.prov) Do
        read(mae,regm);
      seek(mae,filePos(mae)-1);
      While (min.prov = regm.nombre) Do
        Begin
          regm.cantAlfabetizados := regm.cantAlfabetizados + min.cantAlfabetizados;
          regm.cantEncuestados := regm.cantEncuestados + min.cantEncuestados;
          minimo(regd1,regd2,min);
        End;
      write(mae,regm);
    End;
  close(mae);
  close(det1);
  close(det2);
  writeln('Maestro DESPUES de la actualizacion: ');
  imprimirMaestro();

End.
