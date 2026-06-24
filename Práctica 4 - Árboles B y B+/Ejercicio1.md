# Ejercicio 1

a. Resuelto en ejercicio1a.pas

b. Al reemplazar N = 512, A = 64, C = 4 y B = 4 (porque B y C son enteros). Se obtiene M = 8. Esto significa que cada nodo tiene la información de 7 (M-1) alumnos, y 8 punteros a los siguientes alumnos.

c. Si para cada nodo tengo reservada una cantidad X de bytes, el espacio que estoy usando en guardar los datos completos es espacio que no puedo usar para almacenar punteros a mis hijos. Esto resulta en un valor de M drásticamente menor que si se almacenase únicamente la clave.

d. El nombre y el apellido no serían buenas claves, ya que se pueden repetir. Además, un string de 40 ocupa más espacio en memoria que uno de 8. Para solucionar esto, se podría usar tanto el DNI como el legajo, indistintamente.

e. El proceso consiste en buscar la clave en el arreglo del nodo. Si no se encuentra, se baja por la rama que está entre medio de un valor menor y un valor mayor a ella. En el mejor de los casos se requiere 1 solo acceso (es decir, el dato se encuentra en la raíz). En cambio, en el peor de los casos, se debe llegar a una hoja, realizando 1 acceso por cada nivel del árbol.

f. En ese caso, el orden establecido no nos ayudaría de nada. En el peor de los casos se tiene que recorrer el árbol completo.
