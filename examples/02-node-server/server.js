import express from 'express'

const app = express()

// ------- Variables de entorno -------
const PORT = process.env.PORT || 3000
const SALUDO = process.env.SALUDO || '¡Hola desde Node.js dentro de Docker! 🐳'

// ------- Rutas -------

// Endpoint raíz: devuelve un saludo y algunos datos del entorno
app.get('/', (req, res) => {
    console.log('[GET] /')

    res.json({
        mensaje: SALUDO,
        hostname: process.env.HOSTNAME,
        timestamp: new Date().toISOString(),
    })
})

// Endpoint para comprobar que el servidor está funcionando
app.get('/health', (req, res) => {
    console.log('[GET] /health')
    res.status(200).json({ status: 'ok' })
})

// Arranque del servidor
app.listen(PORT, () => {
    console.log(`🚀 Server listening on http://localhost:${PORT}`)
})
