import express, { json } from 'express'; 
import { config } from 'dotenv';    

// Cargar variables de entorno
config();

// Crear instancia de Express
const app = express();

// Middleware para parsear JSON en el body de las peticiones
app.use(json());

// Importar rutas
import departamentoRoutes from './routes/departamento.js';
import municipioRoutes from './routes/municipio.js';
import centroRoutes from './routes/centro.js';
import escuelaRoutes from './routes/escuela.js';
import ubicacionRoutes from './routes/ubicacion.js';
import registroRoutes from './routes/registro.js';
import correlativoRoutes from './routes/correlativo.js';
import examenRoutes from './routes/examen.js';
import preguntasRoutes from './routes/preguntas.js';
import preguntasPracticoRoutes from './routes/preguntasPractico.js';
import respuestaUsuarioRoutes from './routes/respuestaUsuario.js';
import respuestaPracticoRoutes from './routes/respuestaPracticoUsuario.js';
import estadisticasRoutes from './routes/estadisticas.js';

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
app.get('/', (_req, res) => {
  res.json({ message: 'API Centros de Evaluación de Manejo - SBD1 2026' });
});

// Iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});