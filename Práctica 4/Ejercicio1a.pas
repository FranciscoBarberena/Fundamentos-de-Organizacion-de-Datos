
Program ejercicio1a;

Const 
  M = 5;


Type 
  alumno = Record
    nombre: string[40];
    apellido: string[40];
    DNI: string[8];
    legajo: string[8];
    anio: integer;
  End;

  nodoB = Record
    cantClaves: integer;
    datos: array[1..M-1] Of alumno;       
    hijos: array[1..M] Of integer; // NRR es integer.     
  End;

  archivo = file Of nodoB;


