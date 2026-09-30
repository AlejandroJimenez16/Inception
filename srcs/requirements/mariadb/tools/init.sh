#!/bin/bash

# 1. Creo la carpeta donde creara el socket del servidor
mkdir -p /run/mysqld

# 2. Le asigno como usuario y grupo mysql
chown mysql:mysql /run/mysqld

# 3. Ejecutamos el servidor de mysql
exec mariadbd --user=mysql
