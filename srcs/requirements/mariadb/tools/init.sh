#!/bin/bash

# 1. Crear la carpeta donde se creará el socket del servidor
mkdir -p /run/mysqld

# 2. Asignar como usuario y grupo mysql
chown mysql:mysql /run/mysqld

# 3. Ejecutar servidor temporal en segundo plano y crear la base de datos y el usuario
mariadbd --user=mysql &

# Esperar a que el servidor arranque
echo "Esperando a MariaDB..."
until mariadb-admin ping > /dev/null 2>&1
do
    sleep 1
done
echo " ¡Listo!"

# Crear la base de datos
mariadb -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"

# Obtener la contraseña del secret
DB_PASSWORD=$(cat /run/secrets/db_password)

# Crear usuario y darle permisos sobre la base de datos
mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mariadb -e "FLUSH PRIVILEGES;"

# 4. Detener el servidor temporal
mariadb-admin shutdown

# 5. Iniciar MariaDB en PID 1
exec mariadbd --user=mysql
