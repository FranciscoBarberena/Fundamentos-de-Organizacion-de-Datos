
Program ejercicio6;

Type 
  especie = Record
    code: integer;
    nombre: string[40];
    familia: string[40];
    desc: string;
    zonaGeografica: string[40];
  End;
  archivoMaestro = file Of especie;
Procedure borradoLogicoAve(Var mae: archivoMaestro; code : integer);

Var 
  ave: especie;
  encontre: boolean;
Begin
  reset(mae);
  encontre := false;
  While (Not(eof(mae))) And (Not encontre) Do
    Begin
      read(mae,ave);
      If (ave.code = code) Then
        Begin
          encontre := true;
          ave.code := -1;
          seek(mae,filePos(mae)-1);
          write(mae,ave);
        End;
    End;
  close(mae);
  If (Not encontre) Then
    Begin
      writeln('No se encontro el ave con codigo ',code);
    End;
End;

Procedure borradoFisicoAve(Var mae: archivoMaestro);

Var 
  ave: especie;
  encontre: boolean;
  posAReemplazar: integer;
Begin
  reset(mae);
  encontre := false;
  While (Not(eof(mae))) And (Not encontre) Do
    Begin
      read(mae,ave);
      If (ave.code < 0) Then
        Begin
          encontre := true;
          posAReemplazar := filePos(mae)-1;
          seek(mae,fileSize(mae)-1);
          read(mae,ave);
          seek(mae,posAReemplazar);
          write(mae,ave);
          seek(mae,fileSize(mae)-1);
          truncate(mae);
        End;
    End;
  close(mae);
  If (Not encontre) Then
    Begin
      writeln('No hay ningún ave para borrar definitivamente.');
    End;
End;
Procedure compactacionVariante(Var mae: archivoMaestro);

Var 
  aveActual, aveUltima: especie;
  posActual, posUltima: integer;
Begin
  reset(mae);
  posActual := 0;
  posUltima := fileSize(mae) - 1;

  { Mientras los punteros no se crucen }
  While (posActual <= posUltima) Do
    Begin
      seek(mae,posActual);
      read(mae,aveActual);
      If (aveActual.code < 0) Then
        Begin
          seek(mae,posUltima);
          read(mae,aveUltima);
          posUltima := posUltima -1;
          seek(mae,posActual);
          write(mae,aveUltima);
        End
      Else
        posActual := posActual + 1;
    End;
  seek(mae,posUltima+1);
  truncate(mae);
  close(mae);
End;
Procedure generarDatosDePrueba(Var mae: archivoMaestro);

Var 
  ave: especie;
Begin
  rewrite(mae);

  ave.code := 10;
  ave.nombre := 'Aguila Mora';
  ave.familia := 'Accipitridae';
  ave.desc := 'Ave rapaz de gran tamano.';
  ave.zonaGeografica := 'Sudamerica';
  write(mae, ave);

  ave.code := 25;
  ave.nombre := 'Condor Andino';
  ave.familia := 'Cathartidae';
  ave.desc := 'El ave no marina de mayor envergadura.';
  ave.zonaGeografica := 'Cordillera de los Andes';
  write(mae, ave);

  ave.code := 33;
  ave.nombre := 'Maca Tobiano';
  ave.familia := 'Podicipedidae';
  ave.desc := 'Ave acuatica endemica de la Patagonia.';
  ave.zonaGeografica := 'Santa Cruz';
  write(mae, ave);

  ave.code := 42;
  ave.nombre := 'Loro Vinoso';
  ave.familia := 'Psittacidae';
  ave.desc := 'Loro de pecho color vino tinto.';
  ave.zonaGeografica := 'Selva Paranaense';
  write(mae, ave);

  ave.code := 50;
  ave.nombre := 'Cardenal Amarillo';
  ave.familia := 'Thraupidae';
  ave.desc := 'Ave cantora de plumaje amarillo.';
  ave.zonaGeografica := 'Espinal y Monte';
  write(mae, ave);

  close(mae);
End;

Procedure imprimirArchivo(Var mae: archivoMaestro; titulo: String);

Var 
  ave: especie;
Begin
  reset(mae);
  writeln('--- ', titulo, ' ---');
  If (eof(mae)) Then
    writeln('El archivo esta vacio.')
  Else
    Begin
      While (Not(eof(mae))) Do
        Begin
          read(mae, ave);
          writeln('[ID: ', ave.code, '] ', ave.nombre, ' - ', ave.zonaGeografica);
        End;
    End;
  writeln('--------------------------------------------------');
  close(mae);
End;

Var 
  mae: archivoMaestro;
  codigoABorrar: integer;

Begin
  Assign(mae,'maestro.dat');

  generarDatosDePrueba(mae);
  imprimirArchivo(mae, 'ESTADO INICIAL');

  write('Ingrese el codigo del ave que quiere borrar (0 PARA TERMINAR): ');
  readln(codigoABorrar);


{Implementacion haciendo el borrado fisico de a uno}
  While (codigoABorrar > 0) Do
    Begin
      borradoLogicoAve(mae,codigoABorrar);
      borradoFisicoAve(mae);
      write('Ingrese el codigo del ave que quiere borrar (0 PARA TERMINAR): ');
      readln(codigoABorrar);
    End;
  imprimirArchivo(mae, 'DESPUES DE LAS BAJAS LOGICAS SEGUIDAS INMEDIATAMENTE DE BAJAS FISICAS');

{--- Implementacion haciendo un solo truncate ---
  While (codigoABorrar > 0) Do
    Begin
      borradoLogicoAve(mae,codigoABorrar);
      write('Ingrese el codigo del ave que quiere borrar (0 PARA TERMINAR): ');
      readln(codigoABorrar);
    End;
  imprimirArchivo(mae, 'DESPUES DE LAS BAJAS LOGICAS');
  compactacionVariante(mae);
  imprimirArchivo(mae, 'DESPUES DE LAS BAJAS FISICAS');}
End.
