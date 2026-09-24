# 02 - Node Server

## 🎯 Objetivo

Ejemplo en el que levantamos un servidor web básico en `Node.js` dentro de un contenedor y accedemos a él desde nuestro navegador.

## 📁 Estructura

```
02-node-server/
├── .dockerignore
├── Dockerfile
├── package-lock.json
├── package.json
├── README.md
└── server.js
```

## 📄 Dockerfile

```dockerfile
FROM node:26-alpine

# Le indicamos el directorio en el que va a trabajar dentro del contenedor
WORKDIR /app

# Copiamos primero las dependencias para aprovechar la caché de Docker
COPY package*.json ./

# Instalamos las dependencias
RUN npm install

# Copiamos el resto del código fuente desde nuestra máquina a /app
COPY . .

# Documentamos el puerto en el que escucha la aplicación
EXPOSE 3000

# Por seguridad, cambiamos al usuario 'node'
USER node

CMD ["node", "server.js"]
```

## 🧠 Qué aprendemos

- Qué es la **caché de capas**: al copiar primero `package*.json`, evitamos volver a descargar dependencias si solo cambia el código.
- Para qué sirve `WORKDIR`: define el **directorio de trabajo** dentro del contenedor, donde se ejecutan las instrucciones siguientes.
- Uso de `.dockerignore`: evita copiar **archivos innecesarios** a la imagen, manteniéndola más ligera.
- La importancia de la **seguridad**: usamos `USER` para ejecutar la app como un usuario estándar en lugar de superusuario (`root`).
- Cómo funciona el **enlace de puertos**: usamos `-p` para conectar nuestro ordenador con el puerto interno del contenedor.
- Un servidor web no termina: el contenedor sigue en marcha esperando peticiones (a diferencia del `echo` del 01).

## 🚀 Cómo probar este ejercicio

1. **Construir la imagen**

    ```bash
    docker build -t 02-node-server .
    ```

2. **Ejecutar el contenedor**

    ```bash
    docker run --rm -p 5002:3000 02-node-server
    ```

    > El puerto `3000` es el interno del contenedor; desde nuestra máquina accedemos por el `5002`

3. **Probarlo**

    Abre `http://localhost:5002` en el navegador, o desde otra terminal:

    ```bash
    curl localhost:5002
    ```

## 📤 Salida

**Terminal:**

```text
🚀 Server listening on http://localhost:3000
[GET] /
```

**Navegador o con curl:**

```json
{
  "mensaje": "¡Hola desde Node.js dentro de Docker! 🐳",
  "hostname": "64e71f5446e6",
  "timestamp": "2026-09-21T11:22:27.430Z"
}
```
