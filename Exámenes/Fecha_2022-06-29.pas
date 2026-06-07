
Program examen;

Type 
  str40 = string[40];
  municipio = Record
    nombre: str40;
    desc: string;
    habit: integer;
    ext: real;
    ano: integer;
  End;

  tArchMun = file Of municipio;

Function existeMunicipio(Var a: tArchMun; nom: str40): boolean;

Var 
  encontre: boolean;
  pos: integer;
  mun: municipio;
Begin
  encontre := false;
  If (Not EOF(a)) Then
    Begin
      pos := FilePos(a);
      Seek(a, 1);
      While (Not EOF(a)) And (Not encontre) Do
        Begin
          read(a, mun);
          If (mun.nombre = nom) And (mun.habit > 0) Then
            encontre := true;
        End;
      Seek(a, pos);
    End;
  existeMunicipio := encontre;
End;

Procedure AltaMunicipio(Var a: tArchMun);

Var 
  mun, cabecera: municipio;
Begin
  //Asumo que existe cabecera con NRR en habit
  readln(mun.nombre);
  reset(a);
  If (Not existeMunicipio(a, mun.nombre)) Then
    Begin
      readln(mun.desc);
      readln(mun.habit);
      readln(mun.ext);
      readln(mun.ano);

      read(a, cabecera);

      If (cabecera.habit < 0) Then
        Begin
          Seek(a, -cabecera.habit);
          read(a, cabecera);
          Seek(a, FilePos(a) - 1);
          write(a, mun);
          Seek(a, 0);
          write(a, cabecera);
        End
      Else
        Begin
          Seek(a, FileSize(a));
          write(a, mun);
        End;
    End
  Else
    writeln('Ya existe el municipio');

  close(a);
End;

Procedure BajaMunicipio(Var a: tArchMun);

Var 
  mun, cabecera: municipio;
  encontre: boolean;
  nombre: str40;
Begin
  reset(a);
  readln(nombre);
  If (existeMunicipio(a, nombre)) Then
    Begin
      encontre := false;
      read(a, cabecera);

      While (Not encontre) Do
        Begin
          read(a, mun);
          If (mun.nombre = nombre) And (mun.habit > 0) Then
            Begin
              Seek(a, FilePos(a) - 1);
              mun.habit := cabecera.habit;
              write(a, mun);

              cabecera.habit := -(FilePos(a) - 1);
              Seek(a, 0);
              write(a, cabecera);

              encontre := true;
            End;
        End;
    End
  Else
    writeln('No existe ese municipio');

  close(a);
End;

Begin

End.
