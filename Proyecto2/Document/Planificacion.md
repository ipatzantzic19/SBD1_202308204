# 📋 Planificación por Fases — Proyecto 2 SBD1

**Proyecto:** Backend y Exposición de Servicios — Centros de Evaluación de Manejo  
**Curso:** Sistemas de Bases de Datos 1, USAC 1S 2026  
**Peso:** 35.72 pts | **Entrega:** 30 de abril de 2026

---

## Resumen de Fases

| Fase | Nombre | Días estimados | Puntos en juego |
|------|--------|---------------|-----------------|
| 0 | Preparación del entorno | Día 1 | Base de todo |
| 1 | Docker + Oracle XE | Días 1–2 | 10 + 5 = 15 pts |
| 2 | DML y validación con DBeaver | Día 3 | Prerequisito pruebas |
| 3 | Backend Node.js/Express (CRUD) | Días 4–7 | 10 pts |
| 4 | Consultas estadísticas SQL | Días 7–9 | 30 pts |
| 5 | Pruebas Postman | Días 8–10 | 30 pts |
| 6 | Documentación README | Días 9–10 | Requisito calificación |

---

## FASE 0 — Preparación del entorno (Día 1)

### Objetivo
Tener instaladas todas las herramientas antes de escribir una sola línea de código.

### Qué instalar
1. **Docker Desktop** → https://www.docker.com/products/docker-desktop/
2. **Node.js LTS** (v20+) → https://nodejs.org/
3. **DBeaver Community** → https://dbeaver.io/download/
4. **Postman** → https://www.postman.com/downloads/
5. **Git** → https://git-scm.com/

### Qué configurar
- Crear cuenta en GitHub si no tienes
- Crear repositorio privado con nombre: `SBD1B_1S2026_#tucarnet`
- Agregar al tutor como colaborador (parguet o Tefy1317)
- Clonar el repositorio vacío en tu computadora

### Verificación
```bash
docker --version        # Docker version 24+
node --version          # v20+
npm --version           # 10+
git --version           # 2+
```

---

## FASE 1 — Docker + Oracle XE (Días 1–2)

### Objetivo
Tener Oracle XE corriendo en un contenedor Docker, con el esquema DDL cargado automáticamente.

### Conceptos que aprenderás
- **Docker:** programa que crea "cajas" aisladas (contenedores) donde corre software
- **Docker Compose:** herramienta para definir y correr múltiples contenedores con un archivo
- **Imagen Docker:** plantilla de un sistema (como Oracle XE empaquetado)
- **Volumen:** carpeta que persiste datos aunque el contenedor se reinicie
- **Variables de entorno (.env):** forma segura de guardar contraseñas sin escribirlas en el código

### Archivos a crear
```
├── docker-compose.yml     ← Orquesta los servicios
├── .env                   ← Credenciales (nunca subir a GitHub)
├── .gitignore             ← Ignora .env y node_modules
└── oracle-db/
    └── init-scripts/
        ├── 01_ddl.sql     ← Tablas y restricciones
        └── 02_dml.sql     ← Datos de prueba
```

### Puntos de rúbrica
- Docker y Docker Compose configurados correctamente: **10 pts**
- DDL se inicializa automáticamente: **5 pts**

---

## FASE 2 — Validación con DBeaver (Día 3)

### Objetivo
Conectar DBeaver al contenedor Oracle y verificar que las tablas y datos existen.

### Conceptos que aprenderás
- **DBeaver:** cliente visual para explorar bases de datos (como un explorador de archivos para BD)
- **JDBC:** protocolo de conexión a bases de datos desde Java/herramientas externas
- **SID vs Service Name:** dos formas de identificar una BD Oracle (`XE` es el service name)

### Qué verificar
- Todas las tablas del modelo existen
- Las restricciones (FK, PK, NOT NULL) están aplicadas
- Los datos del DML se ven en las tablas

---

## FASE 3 — Backend Node.js/Express CRUD (Días 4–7)

### Objetivo
Crear una API REST que permita crear, leer, actualizar y eliminar registros en cada tabla.

### Conceptos que aprenderás
- **Node.js:** entorno que permite correr JavaScript fuera del navegador
- **Express:** librería que facilita crear servidores HTTP con rutas
- **API REST:** interfaz estándar para que aplicaciones se comuniquen por HTTP
- **CRUD:** Create, Read, Update, Delete (las 4 operaciones básicas)
- **JSON:** formato de datos que usa la API para enviar y recibir información
- **oracledb:** driver npm para conectar Node.js a Oracle

### Estructura del backend
```
src/
├── app.js              ← Servidor Express, registra rutas
├── config/
│   └── db.js           ← Función de conexión a Oracle
└── routes/
    ├── departamento.js ← CRUD departamentos
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
    └── estadisticas.js ← Las 3 consultas
```

### Métodos HTTP y lo que significan
| Método | Acción | Ejemplo |
|--------|--------|---------|
| GET | Leer/consultar | Obtener todos los departamentos |
| POST | Crear nuevo | Agregar un departamento |
| PUT | Actualizar | Modificar nombre de departamento |
| DELETE | Eliminar | Borrar un departamento |

### Puntos de rúbrica
- CRUD para todas las tablas: **10 pts**
- Calidad de código: **5 pts**

---

## FASE 4 — Consultas estadísticas SQL (Días 7–9)

### Objetivo
Implementar 3 endpoints con consultas SQL complejas sobre la base de datos.

### Consulta 1: Estadísticas por centro y escuela
**Endpoint:** `GET /api/estadisticas/por-centro`

Debe retornar por cada combinación centro-escuela:
- Total de exámenes realizados
- Promedio del examen teórico (respuestas correctas)
- Promedio del examen práctico (suma de notas prácticas)
- Cantidad de aprobados

### Consulta 2: Ranking de evaluados
**Endpoint:** `GET /api/estadisticas/ranking`

Ordena a todos los evaluados por su puntaje final (teórico + práctico) de mayor a menor, asignando número de posición.

### Consulta 3: Pregunta con menor aciertos
**Endpoint:** `GET /api/estadisticas/pregunta-menor-aciertos`

Identifica la pregunta teórica donde menos personas respondieron correctamente. La salida debe incluir el porcentaje de aciertos.

### Puntos de rúbrica
- Consulta 1: **10 pts**
- Consulta 2: **10 pts**
- Consulta 3: **10 pts**

---

## FASE 5 — Pruebas con Postman (Días 8–10)

### Objetivo
Documentar y probar todos los endpoints con Postman, y exportar la colección como JSON.

### Conceptos que aprenderás
- **Postman:** herramienta para hacer peticiones HTTP y documentar APIs
- **Colección:** grupo organizado de peticiones en Postman
- **Request body:** datos que envías al crear/actualizar (en formato JSON)
- **Status codes:** 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Error

### Qué cubrir en la colección
Para cada tabla:
- GET all (listar todos)
- GET by id (obtener uno)
- POST (crear) con body de ejemplo
- PUT (actualizar) con body de ejemplo
- DELETE (eliminar)

Para estadísticas:
- GET consulta 1
- GET consulta 2
- GET consulta 3

### Puntos de rúbrica
- Pruebas en Postman: **30 pts**

---

## FASE 6 — Documentación README (Días 9–10)

### Objetivo
Escribir un README.md claro que permita a cualquier persona levantar el sistema desde cero.

### Secciones del README
1. Descripción del proyecto
2. Tecnologías usadas
3. Pre-requisitos
4. Guía de despliegue paso a paso (Docker)
5. Guía de conexión desde DBeaver (con capturas)
6. Descripción de endpoints
7. Capturas de Postman como evidencia

### Imágenes requeridas (capturas de pantalla)
- Docker Desktop mostrando contenedores activos
- DBeaver conectado mostrando las tablas
- DBeaver mostrando datos en al menos 3 tablas
- Postman: al menos 2 peticiones CRUD exitosas
- Postman: las 3 consultas estadísticas con resultado

---

## Cronograma sugerido

```
Día 1:  Instalar herramientas + crear docker-compose.yml + .env
Día 2:  Levantar Oracle + crear DDL en init-scripts + verificar
Día 3:  Conectar DBeaver + insertar DML + validar datos
Día 4:  Inicializar proyecto Node.js + configurar db.js
Día 5:  CRUD departamento, municipio, centro, escuela
Día 6:  CRUD ubicacion, registro, correlativo, examen
Día 7:  CRUD preguntas, preguntasPractico, respuestas (ambas)
Día 8:  Consultas estadísticas SQL (las 3)
Día 9:  Pruebas Postman de todo + exportar colección
Día 10: README final + capturas + revisión + push a GitHub
```

---

## Criterios de evaluación resumidos

| Área | Pts |
|------|-----|
| Docker + Compose (levantamiento y persistencia) | 10 |
| Inicialización automática DDL | 5 |
| Calidad de código API | 5 |
| CRUD todas las tablas | 10 |
| Preguntas teóricas (oral en calificación) | 10 |
| Consulta 1 (estadísticas por centro) | 10 |
| Consulta 2 (ranking evaluados) | 10 |
| Consulta 3 (pregunta menor aciertos) | 10 |
| Pruebas Postman | 30 |
| **TOTAL** | **100** |