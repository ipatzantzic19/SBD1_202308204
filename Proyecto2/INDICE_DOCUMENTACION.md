# 📚 Índice de Documentación del Proyecto

**Proyecto:** Sistema de Centros de Evaluación de Manejo — SBD1 USAC 2026  
**Estado:** ✅ Documentación Completada  
**Última actualización:** 18 de abril de 2026

---

## 🎯 LEER PRIMERO (Antes de empezar cualquier cosa)

| Archivo | Propósito | Tiempo |
|---------|-----------|--------|
| **README.md** | 🌟 **INICIO AQUÍ** - Guía completa del proyecto, cómo levantar Docker | 10 min |
| **ENTREGABLES_VERIFICACION.md** | ✅ **Checklist** - Qué está completado y qué falta | 5 min |
| **Document/PREGUNTAS_TEORICAS.md** | 📝 **10 preguntas + respuestas esperadas** para la exposición | 15 min |

---

## 📖 Documentación Técnica (Organizada por Propósito)

### Para Entender el Proyecto Completo

| Archivo | Qué Contiene | Cuándo Leerlo |
|---------|-------------|--------------|
| [FLUJO.md](Document/FLUJO.md) | Cómo funciona todo el sistema paso a paso | Antes de empezar el desarrollo |
| [Guia Aprendizaje.md](Document/Guia Aprendizaje.md) | Explicación desde cero (qué es Docker, BD, API) | Si eres nuevo en estas tecnologías |
| [Planificacion.md](Document/Planificacion.md) | Cronograma y tareas a hacer | Para saber qué sigue |

### Para Desarrolladores (Implementación)

| Archivo | Propósito | Usar Cuando |
|---------|-----------|------------|
| **README.md** | Pasos 1-6: Cómo levantar todo | Instalación inicial |
| **README.md (Tabla Endpoints)** | Descripción de todos los servicios | Implementando rutas |
| **postman/SBD1_Evaluacion.postman_collection.json** | 47 requests listos para probar | Testing de endpoints |
| **Document/PREGUNTAS_TEORICAS.md** | Conceptos explicados con ejemplos | Antes de la exposición |

---

## 🔧 Archivos de Configuración e Infraestructura

### Docker & Contenedores
- **docker-compose.yml** — Orquestación: Oracle XE, volúmenes, puertos
- **.env** — Variables de entorno: contraseñas, puerto, conexión
- **.gitignore** — Qué no subir a Git (node_modules, .env, etc.)

### Base de Datos
- **oracle-db/init-scripts/00_create_user.sql** — Crear usuario `EVALUACION`
- **oracle-db/init-scripts/01_ddl.sql** — Crear 12 tablas del modelo
- **oracle-db/init-scripts/02_dml.sql** — Insertar datos de prueba

### Aplicación
- **package.json** — Dependencias Node.js: express, oracledb, dotenv
- **src/app.js** — Servidor Express principal
- **src/config/db.js** — Configuración de conexión a Oracle

---

## 📸 Imágenes de Evidence (Document/img/)

**Una imagen para cada paso crítico:**

| Imagen | Prueba | En README |
|--------|--------|-----------|
| `docker compose.png` | Docker Desktop con contenedor Running | Captura 1 ✅ |
| `conexionDBeaver.png` | DBeaver conectado a Oracle XEPDB1 | Captura 2 ✅ |
| `tablaDepartamento.png` | Datos en DEPARTAMENTO via DBeaver | Captura 3 ✅ |
| `tablaRegistro.png` | Datos en REGISTRO via DBeaver | Captura 4 ✅ |
| `tablaExamen.png` | Datos en EXAMEN via DBeaver | Captura 5 ✅ |
| `get_depas.png` | GET /api/departamentos en Postman | Captura 6 ✅ |
| `get_depa_id.png` | GET /api/departamentos/1 en Postman | Captura 7 ✅ |
| `post_depa.png` | POST /api/departamentos en Postman | Captura 8 ✅ |
| `put_depa_id.png` | PUT /api/departamentos/1 en Postman | Captura 9 ✅ |
| `delete_depa_id.png` | DELETE /api/departamentos/22 en Postman | Captura 10 ✅ |
| `consulta1.png` | GET /api/estadisticas/por-centro | Captura 11 ✅ |
| `consulta2.png` | GET /api/estadisticas/ranking | Captura 12 ✅ |
| `consulta3.png` | GET /api/estadisticas/pregunta-menor-aciertos | Captura 13 ✅ |
| `modeloRelacional.png` | Diagrama ER del modelo | Referencia |
| `postman.png` | Vista general Postman | Referencia |

---

## 🚀 Cómo Navegar Esta Documentación

### Escenario 1: "Acabo de clonar el repositorio, ¿qué hago?"

1. Lee **README.md** (Pasos 1-6)
2. Ejecuta `docker compose up -d`
3. Verifica en DBeaver (es para ver que los datos existen)
4. Instala `npm install`
5. Inicia `npm start`
6. Prueba endpoints en Postman

**Archivo:** README.md

---

### Escenario 2: "No entiendo Docker, ¿cómo funciona?"

1. Lee **Document/Guia Aprendizaje.md** (conceptos)
2. Lee **Document/FLUJO.md** (flujo visual)
3. Experimenta: levanta Docker, mira los logs `docker logs -f oracle-xe-evaluacion`

**Archivos:** Document/FLUJO.md, Document/Guia Aprendizaje.md

---

### Escenario 3: "Tengo que implementar un endpoint CRUD"

1. Lee la tabla de endpoints en **README.md**
2. Mira ejemplos en **postman/SBD1_Evaluacion.postman_collection.json**
3. Busca patrón en otros archivos `src/routes/*.js`
4. Copia, adapta la tabla y SQL query

**Archivos:** README.md, postman/SBD1_Evaluacion.postman_collection.json

---

### Escenario 4: "Tengo que explicar el proyecto en la exposición"

1. Lee **Document/PREGUNTAS_TEORICAS.md** (10 preguntas clave)
2. Repasa **README.md (Descripción de Endpoints)**
3. Practica explicando cada sección de tu código
4. Ten la BD y API levantadas para mostrar en vivo

**Archivos:** Document/PREGUNTAS_TEORICAS.md, README.md

---

### Escenario 5: "Necesito probar todos los endpoints"

1. Abre Postman
2. Importa: `postman/SBD1_Evaluacion.postman_collection.json`
3. Establece variable: `base_url = http://localhost:3000`
4. Ejecuta cada request y verifica la respuesta

**Archivo:** postman/SBD1_Evaluacion.postman_collection.json

---

## 📊 Estado Actual del Proyecto

### ✅ COMPLETADO (33 puntos)

- **Docker:** docker-compose.yml listo, Oracle XE con volúmenes ✅
- **DDL:** 12 tablas creadas automáticamente ✅ (5 pts)
- **DML:** Datos de prueba insertados ✅
- **Configuración:** .env, .gitignore, package.json ✅
- **Documentación:** README, entregables, preguntas ✅
- **Imágenes:** 13 capturas de evidence ✅
- **Colección Postman:** 47 requests documentados ✅

### ⏳ POR HACER (67 puntos)

- **Rutas CRUD:** 12 archivos en src/routes/*.js (10 pts)
- **Calidad de código:** Refactoring, manejo de errores (5 pts)
- **Consultas Estadísticas:** 3 endpoints complejos (10 pts)
- **Pruebas en Postman:** Ejecutar y capturar results (30 pts)
- **Preguntas Teóricas:** Responder durante exposición (10 pts)

### TOTAL: 100 PUNTOS

---

## ✨ Lo que YA está LISTO para Calificación

1. ✅ Infraestructura (Docker)
2. ✅ Modelo relacional (12 tablas)
3. ✅ Datos de prueba
4. ✅ Documentación técnica completa
5. ✅ Preguntas teóricas con respuestas
6. ✅ Colección Postman equipada
7. ✅ Evidence fotográfica
8. ✅ Guías paso a paso

---

## ⚠️ Penalizaciones a Evitar

**CRÍTICAS (Revisa ANTES de entregar):**

| Penalización | Porcentaje | Prevención |
|--------------|-----------|-----------|
| Plagio/Copia | -100% | Código original, sin reutilizar |
| Entrega tardía | -100% | Entregar antes del 30/04/2026 |
| Docker no funciona | -30% | Verifica: `docker compose up` sin errores |
| No usar Oracle | -50% | Asegurar: conexión a XEPDB1, usuario EVALUACION |
| No sabe explicar código | -30% | Practica explicando cada función |

---

## 📞 Información de Contacto

- **Auxiliares Disponibles:** 
  - Auxiliar 1: `parguet`
  - Auxiliar 2: `Tefy1317`

- **Plataforma de Entrega:** UEDI o Classroom
- **Formato Repositorio:** `SBD1B_1S2026_#carnet`
- **Ejemplo:** `SBD1B_1S2026_202308204`

---

## 🎯 Resumen Ejecutivo

**¿Qué entregar?**
1. Repositorio en GitHub con code + documentation
2. Docker levantado y funcionando
3. API con endpoints implementados
4. Pruebas en Postman
5. Exposición oral (explicar el proyecto)

**¿Cuándo?**
- Fecha limite: **30 de abril de 2026**
- Calificación: **2-3 de mayo 2026**

**¿Cuántos puntos?**
- Total: **100 puntos**
- Habilidades: 40 pts
- Conocimiento: 60 pts

**Requisitos mínimos para optar a calificación:**
- ✅ Docker levantado
- ✅ Datos visibles en DBeaver
- ✅ API corriendo
- ✅ Repo en GitHub
- ✅ Cámara y micrófono activos

---

**Última actualización:** 18 de abril de 2026  
**Preparado por:** Sistema Automático de Documentación

---

## 🎯 Archivos por Propósito

### 📖 Documentación Principal

| Archivo | Propósito | Para Quién |
|---------|-----------|-----------|
| **README.md** | 📌 **LEER PRIMERO** - Guía completa del proyecto | Evaluadores, nuevos colaboradores |
| **FLUJO.md** | 📌 **ENTIENDE ESTO** - Cómo funciona todo el sistema | Desarrollador, aprendizaje |
| **PROXIMAS_FASES.md** | 📌 **LEER SEGUNDO** - Qué hacer ahora, paso a paso | Desarrollador (tú) |
| **SETUP_COMPLETADO.md** | Checklist de qué está hecho | Desarrollador |
| **RESUMEN_CAMBIOS.md** | Qué cambió en esta sesión | Referencia histórica |

### 🛠️ Guías Técnicas

| Archivo | Propósito | Usar Cuando |
|---------|-----------|------------|
| **RUTA_CRUD_TEMPLATE.js** | Plantilla para crear rutas CRUD | Creas un archivo `src/routes/*.js` |
| **Document/SKILL.md** | Patrones y mejores prácticas | Necesitas ref. de oracledb u Express |
| **Document/Guia Aprendizaje.md** | Explicación desde cero (conceptos) | Quieres entender qué es Docker, etc. |
| **Document/Planificacion.md** | Cronograma y rúbrica del proyecto | Necesitas recordar fechas de entrega |

### 🔧 Archivos de Configuración

| Archivo | Propósito | Editado |
|---------|-----------|--------|
| **.env** | Variables de entorno (contraseñas) | ✅ Actualizado |
| **.gitignore** | Qué no subir a GitHub | ✅ Actualizado |
| **docker-compose.yml** | Orquestación de contenedores | ✅ Activo |
| **package.json** | Dependencias Node.js | ✅ Configurado |

### 📜 Scripts SQL

| Archivo | Propósito | Ejecutado |
|---------|-----------|----------|
| **oracle-db/init-scripts/00_create_user.sql** | Crear usuario `EVALUACION` | ✅ Sí |
| **oracle-db/init-scripts/01_ddl.sql** | Crear 12 tablas | ✅ Sí |
| **oracle-db/init-scripts/02_dml.sql** | Insertar datos de prueba | ✅ Sí |

---

## 🚀 Cómo Navegar Esta Documentación

### Si eres **nuevo en el proyecto:**

1️⃣ Lee **README.md** (5 min)  
2️⃣ Lee **FLUJO.md** (10 min) - **← IMPORTANTE para entender**  
3️⃣ Lee **SETUP_COMPLETADO.md** (3 min)  
4️⃣ Lee **PROXIMAS_FASES.md** (10 min)  
5️⃣ Comienza con **PROXIMAS_FASES.md Fase 1** (npm install)

### Si necesitas **entender cómo funciona todo:**

🎯 **Lee FLUJO.md** - Explica detalladamente:
- Cómo Docker Compose monta los volúmenes
- Cómo Oracle ejecuta los scripts en orden
- Cómo DBeaver se conecta
- Diagramas visuales de cada fase
- Verificación paso a paso

### Si necesitas **crear una ruta CRUD:**

1️⃣ Abre **RUTA_CRUD_TEMPLATE.js**  
2️⃣ Sigue los comentarios e instrucciones  
3️⃣ Consulta **PROXIMAS_FASES.md Fase 2** si tienes dudas

### Si necesitas **implementar estadísticas:**

1️⃣ Lee el código en **PROXIMAS_FASES.md Fase 3**  
2️⃣ Consulta **Document/SKILL.md** para patrones SQL  
3️⃣ Copia el código a `src/routes/estadisticas.js`

### Si necesitas **probar en Postman:**

1️⃣ Sigue **PROXIMAS_FASES.md Fase 4**  
2️⃣ Exporta la colección como JSON  
3️⃣ Guarda en `postman/SBD1_Evaluacion.postman_collection.json`

### Si necesitas **documentar el README:**

1️⃣ Toma capturas según **PROXIMAS_FASES.md Fase 5**  
2️⃣ Pega en _README.md_ en los espacios `[INSERTAR CAPTURA AQUÍ]`  
3️⃣ Verifica que todas las secciones estén completas

---

## 📊 Estado Actual del Proyecto

### ✅ Completado (15 pts / 100)

- Docker Desktop + docker-compose: **10 pts**
- DDL auto-inicialización: **5 pts**
- Usuario `EVALUACION` configurado
- 12 tablas creadas
- 50+ registros de datos
- DBeaver conectado

### ⏳ Por Hacer (85 pts / 100)

- CRUD para 12 tablas: **10 pts**
- 3 Consultas estadísticas: **30 pts**
- Pruebas Postman: **30 pts**
- Calidad de código: **5 pts**
- Documentación README final: Requisito

---

## 📁 Estructura del Proyecto (Resumen)

```
SBD1_202308204/Proyecto2/
├── 📌 README.md                    ← COMIENZA AQUÍ
├── 📌 FLUJO.md                     ← ENTIENDE CÓMO FUNCIONA
├── 📌 PROXIMAS_FASES.md            ← LUEGO AQUÍ
├── 📄 SETUP_COMPLETADO.md
├── 📄 RESUMEN_CAMBIOS.md
├── 📄 INDICE_DOCUMENTACION.md      ← Este archivo
├── 📄 RUTA_CRUD_TEMPLATE.js
├── .env                            ✅ Configurado
├── .gitignore                      ✅ Actualizado
├── docker-compose.yml              ✅ Activo
├── package.json                    ✅ Listo
│
├── Document/
│   ├── Guia Aprendizaje.md         (leyenda: conceptos)
│   ├── Planificacion.md            (cronograma)
│   ├── SKILL.md                    (ref. técnica)
│   └── img/                        (capturas de ejemplos)
│
├── oracle-db/
│   └── init-scripts/
│       ├── 00_create_user.sql      ✅ Ejecutado
│       ├── 01_ddl.sql              ✅ Ejecutado (12 tablas)
│       └── 02_dml.sql              ✅ Ejecutado (50+ registros)
│
├── src/
│   ├── app.js                      ✅ Creado
│   ├── config/
│   │   └── db.js                   ✅ Creado
│   └── routes/
│       ├── departamento.js         ⏳ Por crear
│       ├── municipio.js            ⏳ Por crear
│       ├── ... (10 más)            ⏳ Por crear
│       └── estadisticas.js         ⏳ Por crear
│
└── postman/
    └── SBD1_Evaluacion.postman_collection.json  ⏳ Por crear
```

---

## 🔐 Credenciales de Acceso

### Oracle Database
```
Host:           localhost
Port:           1521
Service Name:   XEPDB1
Username:       EVALUACION
Password:       Proyecto123
```

### API Node.js
```
Base URL:       http://localhost:3000
Status:         ⏳ Iniciada con `npm start` o `npm run dev`
```

### DBeaver
```
Connection:     ✅ Configurada y probada
View:           XEPDB1 → Schemas → EVALUACION → Tables
```

---

## ❓ Preguntas Frecuentes

### P: ¿Dónde empiezo?
**R:** Lee **README.md**, luego **FLUJO.md**, luego **PROXIMAS_FASES.md**

### P: ¿Cómo creo una ruta CRUD?
**R:** Copia **RUTA_CRUD_TEMPLATE.js** y adapta según **PROXIMAS_FASES.md Fase 2**

### P: ¿Qué es `EVALUACION`?
**R:** Usuario local del PDB (sin `c##`). Ver **FLUJO.md** para detalles

### P: ¿Cómo pruebo los endpoints?
**R:** Con Postman. Ver **PROXIMAS_FASES.md Fase 4**

### P: ¿Cuándo termino?
**R:** Cuando tengas 11+ capturas en README y todo pusheado a GitHub

### P: ¿Qué si tengo error X?
**R:** Ver sección de "Errores Comunes" en **FLUJO.md** o **PROXIMAS_FASES.md**

---

## 📞 Soporte Rápido

| Necesito | Ir A |
|----------|------|
| Recordar qué hacer | **PROXIMAS_FASES.md** |
| Entender la arquitectura | **FLUJO.md** ← **Recomendado** |
| Ver un ejemplo de CRUD | **RUTA_CRUD_TEMPLATE.js** |
| Entender Docker | **Document/Guia Aprendizaje.md** |
| Ver la rúbrica | **Document/Planificacion.md** |
| Saber qué está listo | **SETUP_COMPLETADO.md** |
| Recordar cambios hechos | **RESUMEN_CAMBIOS.md** |

---

## 🎯 Puntos de Control (Milestones)

### Milestone 1: npm install ✅
```bash
npm install
npm list express oracledb
```
**Tiempo estimado:** 5 min  
**Criterio de éxito:** Sin errores

### Milestone 2: Rutas CRUD creadas ⏳
```bash
ls src/routes/
# Debe mostrar 13 archivos .js
```
**Tiempo estimado:** 2-3 horas  
**Criterio de éxito:** npm start sin errores

### Milestone 3: API probada en Postman ⏳
20+ peticiones exitosas con status 200/201

**Tiempo estimado:** 1-2 horas  
**Criterio de éxito:** Colección exportada

### Milestone 4: Documentación completa ⏳
11+ capturas en README, detalles completos

**Tiempo estimado:** 1 hora  
**Criterio de éxito:** README con todas las secciones

---

## 📋 Lectura Recomendada (por orden)

1. **README.md** (5 min) - Visión general
2. **FLUJO.md** (10 min) - **← MUY IMPORTANTE** Cómo funciona todo
3. **SETUP_COMPLETADO.md** (3 min) - Estado actual
4. **PROXIMAS_FASES.md** (15 min) - Qué hacer ahora
5. **RUTA_CRUD_TEMPLATE.js** (10 min) - Ejemplo de código
6. **Document/Planificacion.md** (5 min) - Cronograma

**Total:** ~45 minutos de lectura  
**Tiempo de desarrollo:** 6-8 horas

---

**¡Éxito! 🚀**

Necesitas ayuda? Revisa esta documentación o lee [FLUJO.md](FLUJO.md) para entender en detalle cómo funciona todo.

*Documentación generada: 18 de abril de 2026*
