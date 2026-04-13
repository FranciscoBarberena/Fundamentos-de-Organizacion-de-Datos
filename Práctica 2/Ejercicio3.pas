
Program ProgramName;

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
  arcvivoDetalle = file Of encuesta;

Var 
  det1,det2: archivoDetalle;
  mae: archivoMaestro;
  regd1,regd2,min : encuesta;
Begin
  leer(det1,regd1);
  leer(det2,regd2);
End.
