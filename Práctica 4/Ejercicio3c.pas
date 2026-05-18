
Program ejercicio3c;

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

  nodoIndiceB+ = Record
    cantClaves: integer;
    claves: array[1..M-1] Of integer;
    punteros: array[1..M] Of integer;
    //Si es interno, apuntan a NRR de otros nodos B+. Si es hoja: apuntan a NRR de los registros en "archivo"
    esHoja: boolean;
    hermanoDer: integer;
  End;


  archivo = file Of alumno;
  archivoIndice = file Of nodoIndiceB+;
