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
