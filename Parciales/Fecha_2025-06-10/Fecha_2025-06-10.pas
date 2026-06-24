
Program examen_2025_06_10;

Const 
  ValorAlto = 30000;

Type 
  tArtista = Record
    code: integer;
    nombre: string[40];
  End;

  tEvento = Record
    code: integer;
    nombre: string[40];
  End;

  Presentacion = Record
    artista: tArtista;
    ano: integer;
    evento: tEvento;
    likes: integer;
    dislikes: integer;
    puntaje: real;
  End;

  tArchPres = file Of Presentacion;

  tResumenArtista = Record
    likes: integer;
    dislikes: integer;
    diferencia: integer;
    puntaje: real;
  End;

  Minimo = Record
    artista: tArtista;
    dislikes: integer;
    puntaje: real;
  End;

Procedure actualizarMinimo(R: tResumenArtista; Var min: Minimo; a: tArtista);
Begin
  If (R.puntaje < min.puntaje) Or ((R.puntaje = min.puntaje) And (R.dislikes > min.dislikes)) Then
    Begin
      min.artista := a;
      min.dislikes := R.dislikes;
      min.puntaje := R.puntaje;
    End;
End;

Procedure imprimirResumen(R: tResumenArtista);
Begin
  writeln('Likes: ', R.likes);
  writeln('Dislikes: ', R.dislikes);
  writeln('Diferencia: ', R.diferencia);
  writeln('Puntaje: ', R.puntaje:0:2);
End;

Procedure leer(Var a: tArchPres; Var reg: Presentacion);
Begin
  If (Not(EOF(a))) Then
    read(a, reg)
  Else
    Begin
      reg.ano := ValorAlto;
      reg.evento.code := ValorAlto;
      reg.artista.code := ValorAlto;
    End;
End;

Procedure generarInforme(Var a: tArchPres);

Var 
  cantPresAno: integer;
  min: Minimo;
  cantAnos: integer;
  cantPresTotal: integer;
  resumenArt: tResumenArtista;
  reg, presActual: Presentacion;
Begin
  reset(a);
  cantPresTotal := 0;
  cantAnos := 0;

  leer(a, reg);

  While (reg.ano <> ValorAlto) Do
    Begin
      presActual := reg;
      cantPresAno := 0;
      writeln('Año: ', presActual.ano);

      While (reg.ano = presActual.ano) Do
        Begin
          presActual.evento := reg.evento;
          writeln('Evento: ', presActual.evento.nombre);
          min.puntaje := ValorAlto;
          min.dislikes := -1;
          While (reg.ano = presActual.ano) And (reg.evento.code = presActual.evento.code) Do
            Begin
              presActual.artista := reg.artista;
              resumenArt.puntaje := 0;
              resumenArt.likes := 0;
              resumenArt.dislikes := 0;
              writeln('Artista: ', presActual.artista.nombre);

              While (reg.ano = presActual.ano) And (reg.evento.code = presActual.evento.code) And (reg.artista.code = presActual.artista.code) Do
                Begin
                  cantPresAno := cantPresAno + 1;
                  resumenArt.likes := resumenArt.likes + reg.likes;
                  resumenArt.dislikes := resumenArt.dislikes + reg.dislikes;
                  resumenArt.puntaje := resumenArt.puntaje + reg.puntaje;
                  leer(a, reg);
                End;

              resumenArt.diferencia := resumenArt.likes - resumenArt.dislikes;
              actualizarMinimo(resumenArt, min, presActual.artista);
              imprimirResumen(resumenArt);
            End;

          writeln('Menos influyente de ', presActual.evento.nombre, ' en ', presActual.ano, ': ', min.artista.nombre);
        End;

      writeln('En ', presActual.ano, ' hubo ', cantPresAno, ' presentaciones');
      cantAnos := cantAnos + 1;
      cantPresTotal := cantPresTotal + cantPresAno;
    End;

  If (cantAnos > 0) Then
    writeln('El promedio de presentaciones por año fue ', (cantPresTotal / cantAnos): 0: 2);

  close(a);
End;
