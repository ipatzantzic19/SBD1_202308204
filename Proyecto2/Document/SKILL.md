---
name: sbd1-proyecto2
description: >
  Skill para el Proyecto 2 de Sistemas de Bases de Datos 1 (SBD1) USAC 2026.
  Usar cuando el estudiante esté trabajando en la Dockerización de Oracle XE,
  API REST con Node.js/Express, consultas estadísticas SQL, o documentación
  del sistema de Centros de Evaluación de Manejo. Cubre: Docker/Docker Compose,
  Oracle XE, Node.js, Express, oracledb driver, Postman, DBeaver.
---

# Skill: SBD1 Proyecto 2 — Centros de Evaluación de Manejo

## Contexto del Proyecto

**Curso:** Sistemas de Bases de Datos 1, USAC — 1S 2026  
**Peso:** 35.72 pts  
**Entrega:** 30-04-2026 | Calificación: 02-05-2026 al 03-05-2026

### Base de datos: Modelo relacional

Tablas del modelo (Oracle XE):
- DEPARTAMENTO, MUNICIPIO, CENTRO, ESCUELA, UBICACION
- REGISTRO, CORRELATIVO, EXAMEN
- PREGUNTAS (teóricas), PREGUNTAS_PRACTICO
- RESPUESTA_USUARIO, RESPUESTA_PRACTICO_USUARIO

### Stack tecnológico
| Capa | Tecnología |
|------|-----------|
| Contenedor | Docker + Docker Compose |
| Base de datos | Oracle XE 21c |
| Backend | Node.js + Express |
| Driver BD | oracledb (npm) |
| Pruebas | Postman |
| Admin BD | DBeaver |

---

## Estructura de Archivos del Proyecto

```
SBD1B_1S2026_#carnet/
├── docker-compose.yml
├── .env
├── README.md
├── oracle-db/
│   └── init-scripts/
│       ├── 01_ddl.sql        ← Schema DDL completo
│       └── 02_dml.sql        ← Datos de prueba
└── src/
    ├── app.js                ← Entrada principal Express
    ├── config/
    │   └── db.js             ← Pool de conexión oracledb
    └── routes/
        ├── departamento.js
        ├── municipio.js
        ├── centro.js
        ├── escuela.js
        ├── ubicacion.js
        ├── registro.js
        ├── correlativo.js
        ├── examen.js
        ├── preguntas.js
        ├── preguntasPractico.js
        ├── respuestaUsuario.js
        ├── respuestaPracticoUsuario.js
        └── estadisticas.js   ← Las 3 consultas estadísticas
```

---

## Patrones de Código

### Conexión Oracle (db.js)
```javascript
const oracledb = require('oracledb');
require('dotenv').config();

// Modo thin: funciona sin Oracle Client instalado
// oracledb.initOracleClient(); // Descomenta solo si tienes Oracle Client

async function getConnection() {
  try {
    const connection = await oracledb.getConnection({
      user: process.env.DB_USER,        // EVALUACION
      password: process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING // localhost:1521/XEPDB1
    });
    return connection;
  } catch (err) {
    console.error('Error de conexión a Oracle:', err);
    throw err;
  }
}

module.exports = { getConnection };
```

### Patrón de ruta CRUD
```javascript
const router = require('express').Router();
const { getConnection } = require('../config/db');

// GET todos
router.get('/', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute('SELECT * FROM TABLA', [], { outFormat: oracledb.OUT_FORMAT_OBJECT });
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});
```

### Consultas estadísticas (SQL Oracle)

**Consulta 1 — Estadísticas por centro y escuela:**
```sql
SELECT 
  c.nombre AS centro,
  e.nombre AS escuela,
  COUNT(DISTINCT ex.id_examen) AS total_examenes,
  ROUND(AVG(teorico.punteo), 2) AS promedio_teorico,
  ROUND(AVG(practico.punteo), 2) AS promedio_practico,
  COUNT(CASE WHEN (teorico.punteo + practico.punteo) >= 60 THEN 1 END) AS aprobados
FROM EXAMEN ex
JOIN CENTRO c ON ex.registro_id_centro = c.id_centro
JOIN ESCUELA e ON ex.registro_id_escuela = e.id_escuela
LEFT JOIN (subquery teorico) ON ...
LEFT JOIN (subquery practico) ON ...
GROUP BY c.nombre, e.nombre
```

**Consulta 2 — Ranking de evaluados:**
```sql
SELECT 
  r.nombre_completo,
  SUM(teorico) + SUM(practico) AS puntaje_total,
  RANK() OVER (ORDER BY (SUM(teorico) + SUM(practico)) DESC) AS ranking
FROM REGISTRO r JOIN EXAMEN ex ON ...
GROUP BY r.nombre_completo
ORDER BY ranking
```

**Consulta 3 — Pregunta con menor aciertos:**
```sql
SELECT 
  p.pregunta_texto,
  COUNT(*) AS total_respuestas,
  SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) AS aciertos,
  ROUND(SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS porcentaje_aciertos
FROM PREGUNTAS p
JOIN RESPUESTA_USUARIO ru ON p.id_pregunta = ru.pregunta_id_pregunta
GROUP BY p.id_pregunta, p.pregunta_texto, p.respuesta_correcta
ORDER BY porcentaje_aciertos ASC
FETCH FIRST 1 ROW ONLY
```

---

## Docker Compose Pattern

```yaml
version: '3.8'
services:
  oracle-db:
    image: container-registry.oracle.com/database/express:21.3.0-xe
    environment:
      - ORACLE_PWD=${ORACLE_PWD}
      - ORACLE_CHARACTERSET=AL32UTF8
    ports:
      - "1521:1521"
    volumes:
      - oracle-data:/opt/oracle/oradata
      - ./oracle-db/init-scripts:/opt/oracle/scripts/startup
    healthcheck:
      test: ["CMD", "sqlplus", "-L", "sys/${ORACLE_PWD}@//localhost/XE as sysdba", "@/dev/null"]
      interval: 30s
      timeout: 10s
      retries: 10

  api:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
      - DB_CONNECT_STRING=oracle-db:1521/XE
    depends_on:
      oracle-db:
        condition: service_healthy

volumes:
  oracle-data:
```

---

## Endpoints API REST

### CRUD (por cada tabla)
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | /api/tabla | Listar todos |
| GET | /api/tabla/:id | Obtener uno |
| POST | /api/tabla | Crear |
| PUT | /api/tabla/:id | Actualizar |
| DELETE | /api/tabla/:id | Eliminar |

### Estadísticas
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | /api/estadisticas/por-centro | Consulta 1 |
| GET | /api/estadisticas/ranking | Consulta 2 |
| GET | /api/estadisticas/pregunta-menor-aciertos | Consulta 3 |

---

## Errores frecuentes y soluciones

| Error | Causa | Solución |
|-------|-------|----------|
| ORA-12541 | Oracle no levantado | Esperar healthcheck, `docker logs oracle-db` |
| ORA-01017 | Credenciales incorrectas | Verificar .env, mayúsculas en usuario |
| TNS:timeout | Red Docker | Usar nombre de servicio `oracle-db`, no `localhost` |
| NJS-006 | Tipo incorrecto en bind | Usar `:param` y pasar como objeto `{param: valor}` |
| ECONNREFUSED | API antes que BD | Revisar `depends_on` + healthcheck |

---

## Requisitos de entrega checklist

- [ ] `docker-compose.yml` funcional
- [ ] DDL se carga automáticamente al iniciar
- [ ] DML con datos de prueba cargados
- [ ] API CRUD para las 12 tablas
- [ ] 3 endpoints estadísticos funcionando
- [ ] Colección Postman exportada como JSON
- [ ] README.md con capturas de DBeaver y Postman
- [ ] Repositorio GitHub con tutor como colaborador