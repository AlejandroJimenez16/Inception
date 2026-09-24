# 01 - Hola Docker

## 🎯 Objetivo

Ejemplo básico para aprender Docker desde cero en el que construimos una imagen mínima y ejecutamos un contenedor que imprime un mensaje.

## 📁 Estructura

```
01-hola-docker/
├── Dockerfile
└── README.md
```

## 📄 Dockerfile

```dockerfile
# Imagen base: alpine, una distribución Linux muy ligera
FROM alpine

# Comando que se ejecuta al arrancar el contenedor
CMD ["echo", "Hola Docker"]
```

## 🧠 Qué aprendemos

- Qué es un **Dockerfile**: las instrucciones para construir una imagen.
- Diferencia entre **imagen** (la plantilla) y **contenedor** (esa imagen en ejecución).
- Un contenedor vive lo que dura su proceso principal: el `echo` termina y el contenedor se detiene.

## 🚀 Cómo probar este ejercicio

1. **Construir la imagen**

    ```bash
    docker build -t 01-hola-docker .
    ```

    > - `-t` le pone nombre a la imagen
    > - `.` indica que el Dockerfile está en el directorio actual

2. **Ejecutar el contenedor**

    ```bash
    docker run --rm 01-hola-docker
    ```

    > `--rm` elimina el contenedor automáticamente al terminar

## 📤 Salida

**Terminal:**

```text
Hola Docker
```
