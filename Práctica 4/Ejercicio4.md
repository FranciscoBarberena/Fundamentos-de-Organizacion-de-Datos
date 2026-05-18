# Ejercicio 4

a. posicionarYLeerNodo(A, nodo, NRR) busca en el archivo indice al elemento con el NRR enviado, y lo lee almacenándolo en "nodo". Implementración en Ejercicio4.pas

b. claveEncontrada(A, nodo, clave, pos, clave_encontrada) lo que hace es revisar si alguna de las claves dentro del arreglo del nodo recuperado coincide con el parámetro clave. Si lo hace, actualiza las variables pos con los datos correspondientes (posición en el arreglo si se encontró, y rama por la que debo bajar en caso contrario), y setea el booleano clave_encontrada en true o false dependiendo de si lo encontró o no. Implementración en Ejercicio4.pas

c. Sí. La condición que me dice que ya no hay elementos que buscar debería ser if (NRR = -1) en vez de (nodo = null). Esto se debe a que nodo inicialmente no tiene ningún valor asignado, sino que se usa para leer del archivo. Además, al ser un registro no se puede comprobar su valor directamente. En todo caso se tendría que revisar uno de sus campos.

d. A la condición de clave encontrada, se le tendría que agregar una "and esHoja". Además, si se encuentra la clave en un nodo interno, igualmente se debe continuar bajando por la rama correspondiente.