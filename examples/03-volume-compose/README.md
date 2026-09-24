# 03 - Volume Compose

## 🎯 Objetivo

Ejemplo en el que levantamos el mismo servidor web básico en Node.js del ejercicio anterior, pero esta vez levantando el contenedor mediante `docker-compose` y usando `bind mount` para que los cambios en el código se reflejen al instante, sin tener que reconstruir la imagen cada vez.

## 📁 Estructura

```
03-volume-compose/
├── .dockerignore
├── docker-compose.yml
├── Dockerfile
├── package-lock.json
├── package.json
├── README.md
└── server.js
```

## 📄 Dockerfile

```dockerfile
FROM node:26-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

USER node

CMD ["node", "server.js"]
```

## 📄 docker-compose.yml

```yaml
# Definición de los servicios (los contenedores de la aplicación)
services:
  server:                                 # Nombre del servicio
    build: .                              # Ruta donde buscar el Dockerfile ('.' -> ruta actual)
    ports:                                # Enlace de puertos
      - "3000:3000"
    command: node --watch server.js       # Sobrescribir comando por defecto (`CMD`)
    volumes:                              # Volúmenes que usa (en este caso bind mount)
      - ./server.js:/app/server.js
```

## 🧠 Qué aprendemos

- Qué es un **bind mount**: vincular un archivo del host (`./server.js`) con uno del contenedor (`/app/server.js`), así los cambios se reflejan sin reconstruir la imagen.
- Diferencia entre `CMD` (comando por defecto en el Dockerfile) y `command` en compose (lo sobrescribe en tiempo de ejecución).
- Qué hace `node --watch`: reinicia el proceso automáticamente al detectar cambios en el archivo.
- Diferencia entre **build time** (`COPY . .` copia el código al construir la imagen) y **run time** (`volumes:` lo sobrescribe solo mientras el contenedor está corriendo).
- Qué es `docker-compose.yml`: archivo en el que indicamos cómo se van a construir y levantar nuestros contenedores (imágenes, puertos, volúmenes, redes y variables de entorno) de forma automatizada.

## 🚀 Cómo probar este ejercicio

1. **Levantar el contenedor**

    ```bash
    docker compose up
    ```

2. **Probarlo**

    Abre `http://localhost:3000` en el navegador, o desde otra terminal:

    ```bash
    curl localhost:3000
    ```

3. **Comprobar el bind mount**

    Con el contenedor corriendo, edita `server.js` (por ejemplo, cambia un mensaje del JSON) y guarda. Deberías ver en la terminal que el proceso se reinicia solo:

    ```text
    server-1  | Change detected in '/app/server.js'
    server-1  | Restarting 'server.js'
    server-1  | 🚀 Server listening on http://localhost:3000
    ```

    Vuelve a probar con `curl localhost:3000` y comprueba que el cambio ya está aplicado.

## 📤 Salida

**Terminal:**

```text
Attaching to server-1
server-1  | 🚀 Server listening on http://localhost:3000
server-1  | [GET] /
```

**Navegador o con curl:**

```json
{
  "mensaje": "¡Hola desde Node.js dentro de Docker! 🐳",
  "hostname": "38901124a80d",
  "timestamp": "2026-09-22T18:44:33.803Z"
}
```
