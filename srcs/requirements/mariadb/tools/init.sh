#!/bin/bash

# Definición de colores
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# 1. Crear la carpeta donde se creará el socket del servidor
mkdir -p /run/mysqld

# 2. Asignar como usuario y grupo mysql
chown mysql:mysql /run/mysqld

# 3. Comprobar si ya existe la base de datos
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo -e "${YELLOW}[INFO]${RESET} Primera ejecucion: inicializando MariaDB..."

	# Ejecutar el servidor de MariaDB en segundo plano
	mariadbd --user=mysql &

	# Esperar a que el servidor arranque
	echo -e "${YELLOW}[INFO]${RESET} Esperando al servidor de MariaDB..."

	n=0
	until mariadb-admin ping > /dev/null 2>&1
	do
		if [ $n -eq 30 ]; then
			echo -e "${RED}[ERROR]${RESET} Tiempo de espera agotado, el servidor no respondió a tiempo..."
			exit 1
		fi
		((n++))
		sleep 1
	done
	echo -e "${GREEN}[OK]${RESET} ¡Servidor de MariaDB listo!"

	# Obtener las contraseñas de secrets
	DB_PASSWORD=$(cat /run/secrets/db_password)
	DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

	# Crear la base de datos y el usuario con permisos
	mariadb -u root <<- EOF
		-- Crear la base de datos
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

		-- Crear usuario y darle permisos sobre la base de datos
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;

		-- Cambiar la contraseña del usuario root
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

	EOF

	# Detener el servidor temporal
	mariadb-admin -u root -p"${DB_ROOT_PASSWORD}" shutdown
	echo -e "${GREEN}[OK]${RESET} Configuración inicial completada"
fi

# 4. Iniciar MariaDB en PID 1
echo -e "${YELLOW}[INFO]${RESET} Iniciando servidor de MariaDB..."
exec mariadbd --user=mysql
