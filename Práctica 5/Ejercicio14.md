# Ejercicio 14

- La opción válida es la D. El resto son inválidas.
    - **Opción A:** Al tener sufijo 00, la tabla indica que tiene que ir al bloque 0, no al 2.
    - **Opción B:** Mismo razonamiento que en la A, no tiene sentido que la clave vaya al bloque 2, ya que la haría imposible de encontrar.
    - **Opción C** Es necesario duplicar la tabla de direcciones porque, si no se hace, no habría sufijo posible para distinguir a Verde de Blanco y Rojo. Como los 3 comparten sus últimos 2 bits, necesariamente la tabla debe tener sufijos de longitud 3, y para eso es necesario duplicarla