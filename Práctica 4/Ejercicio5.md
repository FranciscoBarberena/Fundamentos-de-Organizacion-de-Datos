# Ejercicio 5

- **Overflow:** Sucede cuando se intenta insertar una clave en un nodo con M-1 elementos. Ya que M-1 es el límite máximo de claves que se pueden almacenar, cuando hay overflow se recurre a la división del nodo.
- **Underflow:**  Sucede luego de una baja, cuando un nodo queda con menos de ⌊ M/2 -1 ⌋ claves. Si esto sucede, se recurre a la redistribución y, si eso falla, a la fusión.
- **Redistribución:** Sucede luego de una baja, cuando un nodo queda en underflow y se intenta evitar eso. Lo que se hace es: 
    - Se revisa si el hermano (o hermanos, dependiendo de la política de underflow) tienen más de la mínima cantidad de claves. Si ese es el caso, el hermano sube uno de sus datos al padre, y el padre le da uno de sus datos al hijo en el que se había producido underflow. Esta rotación se hace para mantener la propiedad de orden del árbol.
- **Fusión/concatenación:** Sucede cuando falla una redistribución, porque los hermanos adyacentes no tenían la suficiente cantidad de claves para realizarla (es decir, tenían la cantidad mínima). 
    - Cuando pasa esto, ambos nodos se juntan, formando uno solo. En cuanto al padre, el dato que servía como separador para ambos nodos debe bajar al nuevo nodo producto de la fusión. Esto podría generar underflow en el padre, propagando el problema hacia arriba.