# Correcciones práctica de árboles

## Lecturas y escrituras (ejercicios 7 - 14)
- La manera correcta de hacerlas es como están hechas a partir del punto 15. En los puntos anteriores yo hacía las lecturas por un lado y las escrituras por otro, lo que está **MAL.**

## Cantidad mínima de claves por nodo (ejercicios 10 y 12)
- La fórmula es $(M / 2) - 1$. La división es entera así que se redondea para abajo. En el caso de orden 5 sería  $(5/2) - 1 = 1$. En los puntos 10 y 12, con orden 5, yo había redondeado para arriba y me quedó mínimo de claves = 2. Esto en su momento estaba **MAL** según la cátedra, aunque si los buscás en internet a veces aparece que se hace redondeando para arriba. **RECOMIENDO CONSULTARLE A SUS PROFES.**

## Redistribución con órdenes 5 y 6 (ejercicios 9 y 16)
- En 2026, la cátedra dictaba que al realizar una distribución con un hermano, las claves tienen que quedar repartidas de la manera *más equitativa posible*. Esto puede generar errores en los ejercicios con órdenes 5 y 6, en los que hay un caso de underflow, y el hermano con el que se redistribuye está lleno.
    - *Ejemplo orden 5*: Luego de una baja en un árbol de orden 5, el nodo A queda con 0 claves (*underflow*). Tiene que redistribuir con el hermano (nodo B). Si el nodo B tiene 4 claves, tendrían que quedar las claves equitativamente repartidas luego de la redistribución. Por lo tanto, quedarían 2 claves en el nodo A y 2 claves en el nodo B. Habría también que cambiar la clave separadora del padre para mantener el orden del árbol. 

    - *Ejemplo orden 6*: Luego de una baja en un árbol de orden 6, el nodo A queda con 1 sola clave (*underflow*). Tiene que redistribuir con el hermano (nodo B). Si el nodo B tiene 5 claves, las 6 claves (1 del A + 5 de B) tendrían que quedar equitativamente repartidas luego de la redistribución. Por lo tanto, quedarían 3 claves en el nodo A y 3 claves en el nodo B. Habría también que cambiar la clave separadora del padre para mantener el orden del árbol.
    
    - *Mi resolución*: En mis ejercicios subidos, el nodo que sufre underflow **siempre recibe una sola clave de su hermano** con el que redistribuyó. Esto está **MAL** según la cátedra, ya que en los 2 ejemplos mencionados, el nodo hermano le está "pasando" 2 claves al que sufrió underflow. Yo no sabía esto hasta el día del examen, así que de nuevo, **RECOMIENDO CONSULTARLE A SUS PROFES.**