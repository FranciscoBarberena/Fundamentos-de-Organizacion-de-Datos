
Program ejercicio2a;

Const 
  M = 5;


Type 
  clave = Record
    DNI: string[8];
    NRR: integer;
  End;
  alumno = Record
    nombre: string[40];
    apellido: string[40];
    DNI: string[8];
    legajo: string[8];
    anio: integer;
  End;


  nodoIndice = Record
    cantClaves: integer;
    datos: array[1..M-1] Of clave;
    hijos: array[1..M] Of integer;
  End;


  archivo = file Of alumno;
  archivoIndice = file Of nodoIndice;
