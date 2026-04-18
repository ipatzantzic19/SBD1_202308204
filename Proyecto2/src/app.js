const express = require('express');
const dotenv = require('dotenv');

// Cargar variables de entorno
dotenv.config();

const app = express();

// Middleware para parsear JSON en el body de las peticiones
app.use(express.json());

// Importar rutas
const departamentoRoutes = require('./routes/departamento');
const municipioRoutes    = require('./routes/municipio');
const centroRoutes       = require('./routes/centro');
const escuelaRoutes      = require('./routes/escuela');
const ubicacionRoutes    = require('./routes/ubicacion');
const registroRoutes     = require('./routes/registro');
const correlativoRoutes  = require('./routes/correlativo');
const examenRoutes       = require('./routes/examen');
const preguntasRoutes    = require('./routes/preguntas');
const preguntasPracticoRoutes = require('./routes/preguntasPractico');
const respuestaUsuarioRoutes  = require('./routes/respuestaUsuario');
const respuestaPracticoRoutes = require('./routes/respuestaPracticoUsuario');
const estadisticasRoutes      = require('./routes/estadisticas');

// Registrar rutas con prefijo /api
app.use('/api/departamentos',       departamentoRoutes);
app.use('/api/municipios',          municipioRoutes);
app.use('/api/centros',             centroRoutes);
app.use('/api/escuelas',            escuelaRoutes);
app.use('/api/ubicaciones',         ubicacionRoutes);
app.use('/api/registros',           registroRoutes);
app.use('/api/correlativos',        correlativoRoutes);
app.use('/api/examenes',            examenRoutes);
app.use('/api/preguntas',           preguntasRoutes);
app.use('/api/preguntas-practico',  preguntasPracticoRoutes);
app.use('/api/respuestas-usuario',  respuestaUsuarioRoutes);
app.use('/api/respuestas-practico', respuestaPracticoRoutes);
app.use('/api/estadisticas',        estadisticasRoutes);

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({ message: 'API Centros de Evaluación de Manejo - SBD1 2026' });
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});