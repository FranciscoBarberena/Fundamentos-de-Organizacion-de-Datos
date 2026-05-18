# Ejercicio 3

a. Las claves se organizan de la misma manera que en un árbol B (menores a la izquierda ymayores a la derecha). La diferencia radica en que, en los árboles B+, en las hojas se encuentran todos los datos del árbol, mientras que en los nodos internos se almacenan copias de sus claves para usar como separadores.

b. Además de contener el puntero al dato correspondiente a su clave, almacenan un puntero a su hermano de la derecha para facilitar el acceso ordenado. Esto significa que, además de la raíz, se guarda un puntero a la hoja de más a la izquierda.

c. Implementado en Ejercicio3c.pas 

d. Imaginemos un DNI x. Para encontrar a x, se va a comparar primero con las claves de la raíz, y en base a eso se decidirá por cuál rama bajar. Esto es igual que en un árbol B, con la importante diferencia de que si encuentro el DNI x en un nodo interno, **aún no encontré el registro**. Tengo que asegurarme de que dicho DNI esté en una hoja. Esto se debe a que, a la hora de realizar una baja, el registro se elimina de las hojas. SIn embargo, si su clave fue usada como separador en un nodo interno, esta permanece ahí (aunque el registro con los datos de esa clave haya sido borrado).

e. Igual que en el punto d, se bajaría por ramas hasta encontrar al menor DNI mayor o igual a 40000000. Una vez hecho eso, el proceso se facilita, ya que puedo usar el puntero de cada nodo a su hermano derecho para recorrer todos los siguientes (hasta encontrar uno mayor a 45000000).


f. Pros y contras:
### Pros
- Facilita el acceso ordenado (inciso e).
- Facilita las bajas, ya que siempre se realizan en una hoja.
### Contras
- La cantidad de accesos en una búsqueda que antes se daba en el peor de los casos, ahora se da *siempre*, ya que siempre tengo que llegar a una hoja.
- Ocupa ligeramente más memoria al almacenar copias de algunas claves para usar como separadores.






