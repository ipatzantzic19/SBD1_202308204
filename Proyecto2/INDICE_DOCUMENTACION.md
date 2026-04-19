# 📚 Índice de Documentación del Proyecto

**Proyecto:** Sistema de Centros de Evaluación de Manejo — SBD1 USAC 2026  
**Estado:** ✅ Base de datos configurada, API lista para desarrollar  
**Última actualización:** 18 de abril de 2026

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
