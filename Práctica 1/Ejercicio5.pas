
Program ejercicio5;

Var 
  celulares: Text;

Begin
  //Para crear el archivo dado en el ejemplo
  assign(celulares,'celulares.txt');
  rewrite(celulares);
  write(celulares,'101 250000 Samsung',#13#10,'15 5 Galaxy A15 128GB',#13#10,'Galaxy A15',#13#10,'102 320000 Motorola',#13#10,
        '3 6 Moto G84 256GB color azul',#13#10,'Moto G84',#13#10,'104 950000 Apple',#13#10,'2 4 iPhone 15 256GB negro',#13#10,'iPhone 15');
  close(celulares);
End.
