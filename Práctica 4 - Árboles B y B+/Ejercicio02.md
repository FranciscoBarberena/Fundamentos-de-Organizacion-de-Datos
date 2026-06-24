# Ejercicio 2

a. Implementado en ejercicio2a.pas

b. Al reemplazar N = 512, A = 12, C = 4 y B = 4 (A es el string de 8 + el NRR de 4). Se obtiene M = 32. Esto significa que cada nodo tiene la información de 31 (M-1) claves, y 32 punteros a sus nodos hijos.

c. Implica que el árbol será más ancho y, por lo tanto, menos alto. Esto significa que en el peor de los casos en una búsqueda, la cantidad de accesos a disco es drásticamente menor.

d. El proceso consiste en buscar la clave en el arreglo de un nodo raíz del índice. Si no se encuentra, se baja por la rama que está entre medio de un valor menor y un valor mayor a ella. Este proceso se continúa hasta que se encuentra dicha clave o se comprueba que no existe. Una vez que eso sucede, se usa el NRR almacenado para acceder al registro completo en el archivo de datos desordenado. 

e. Para buscar un alumno por el legajo, no sirve el índice ordenado por DNI. Se tendría que construir otro índice ordenado por legajo. El uso de índices permite que, para obtener información ordenada por distintos criterios, no se tengan que almacenar múltiples veces los datos completos, sino que simplemente sus claves son las que están duplicadas (una vez en el archivo desordenado y otra vez en su índice correspondiente).

f. Para realizar eso, se debería recorrer el árbol usando un recorrido in-orden. Esto es terriblemente ineficiente en términos de acceso a disco, ya que requiere volver múltiples veces por la misma rama. La solución a esto son los árboles B+.