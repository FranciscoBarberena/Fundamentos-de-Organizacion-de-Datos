# Ejercicio 6

- **Saturación progresiva**
    - Una vez que se produce overflow en un bucket, se avanza en el archivo hasta encontrar el nodo más cercano que está libre. Se asigna ese nodo a la clave que produjo overflow.
    - *Problema:* genera áreas de overflow. Los buckets "al final" del archivo reciben más claves, porque, además de recibir sus claves nativas, pueden recibir claves nativas a cualquier otro bloque en el que se haya producido overflow. Esto hace que la distribución de claves no sea uniforme.
- **Saturación progresiva encadenada**
    - Similar al primer método, con una única diferencia. Una vez que la clave que produjo overflow se almacenó en el bucket más cercano, en el bucket "nativo" se almacena un enlace a dicho bucket cercano, para poder acceder a la clave sin tener que pasar por todos los buckets del medio. Es ligeramente mejor que la saturación progresiva, pero sigue tieniendo el mismo problema, ya que genera áreas de overflow también.
- **Saturación progresiva encadenada con área de desborde separada**
    - Se define el mayor número primo que sea menor a la cantidad de buckets.
    - *Ejemplo:* 2500 buckets, el mayor primo menor a 2500 es 2477.
        - La función de hash va a devolver siempre números entre 0 y 2476.
        - Los 23 buckets que sobran se quedan en un área separada, reservada para casos de overflow.
        - Cuando se inserta una clave, y su bucket nativo está lleno, lo almaceno en la primera dirección libre dentro de los buckets de overflow [2477..2499]. También, en el bucket nativo, almaceno un enlace al bucket de overflow en el que realmente inserté la clave.
    - *Ventaja:* Todas las claves almacenadas entre el 0 y el 2476 están en su bucket nativo, lo que significa que siempre puedo acceder a ellas en 1s solo acceso.
- **Dispersión doble**
    - Se definen 2 funciones de hash completamente independientes: $f_1(x)$ y $f_2(x)$.
        - *Nota:* que sean independientes significa que si $f_1(x)$ de las claves $X$, $Y$ dieron como resultado 50, y $f_2(x)$ de $X$ dio como resultado 20, esto **NO** significa que $f_2(x)$ de $Y$ también vaya a dar 20.
    - Inicialmente se usa únicamente $f_1(x)$. Una vez que al insertar una clave, se produce overflow, se aplica $f_2(x)$ a la clave. Esta nueva función va a devolver un número, que se va a usar como desplazamiento al resultado que había devuelto $f_1(x)$. El desplazamiento se sigue sumando hasta encontrar un bucket libre.
    - *Desventaja:* Las claves quedan alejadas físicamente entre sí, que puede ser un problema cuando se trae un bloque del disco a la caché, ya que rompe la lógica del prinicipio de localidad espacial.