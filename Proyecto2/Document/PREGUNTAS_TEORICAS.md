# 📝 Preguntas Teóricas - Proyecto 2 (10 puntos)

**Proyecto:** Centros de Evaluación de Manejo — SBD1 1S 2026  
**Sección:** Rúbrica - Habilidades - Preguntas Teóricas (10 pts)  
**Formato:** Respuestas esperadas

---

## Instrucciones

Estas preguntas forman parte de la calificación oral/escrita del proyecto. Debes estar preparado para responderlas durante la exposición. Las respuestas deben demostrar comprensión de los conceptos, no memorización.

---

## Grupo A: Docker y Contenedores (3 preguntas)

### 1. ¿Por qué es importante dockerizar la base de datos?

**Respuesta esperada:**

Dockerizar garantiza:
- **Portabilidad:** El contenedor funciona igual en cualquier máquina
- **Reproducibilidad:** Todos los desarrolladores usan la misma versión y configuración
- **Aislamiento:** La BD no interfiere con otros servicios del sistema
- **Escalabilidad:** Fácil de desplegar múltiples instancias
- **Consistencia:** Elimina el problema "funciona en mi máquina"

**Ejemplo en tu proyecto:**
"Cuando cargo docker-compose up, instantáneamente tengo Oracle XE iniciado, 12 tablas creadas, y datos insertados. Si alguien clona mi repositorio, obtiene exactamente el mismo estado."

---

### 2. ¿Qué contiene el archivo docker-compose.yml y por qué?

**Respuesta esperada:**

El `docker-compose.yml` define:
- **Service (oracle-db):** Qué imagen usar (Oracle 21.3.0), qué puertos exponer
- **Volumes:** Mapeo de `oracle-data:/opt/oracle/oradata` para persistencia
- **Environment:** Variables como `ORACLE_PWD`
- **Init-scripts:** Carpeta con 01_ddl.sql y 02_dml.sql se ejecuta al iniciar
- **Health check:** Verifica que Oracle esté listo antes de permitir conexiones
- **Restart policy:** Se reinicia automáticamente si falla

**Por qué:**
Esto asegura que cada vez que se levanta el contenedor, Oracle XE tiene exactamente el mismo estado.

---

### 3. ¿Qué es un volumen en Docker y qué pasa si no lo usas?

**Respuesta esperada:**

Un volumen es un mecanismo para persistir datos fuera del contenedor.

**Con volumen:**
```
docker-compose up -d
→ Crea BD, data se guarda en oracle-data/
docker-compose down
→ Contenedor se elimina, datos persisten
docker-compose up -d
→ Se levanta el contenedor y recupera los datos
```

**Sin volumen (problema):**
```
docker-compose up -d
→ Crea BD en memoria del contenedor
docker-compose down
→ Contenedor y TODOS los datos se eliminan
docker-compose up -d
→ Es una BD completamente nueva (vacía)
```

---

## Grupo B: Modelo Relacional y DDL (3 preguntas)

### 4. ¿Cuáles son las 12 tablas del modelo y qué relaciones tienen?

**Respuesta esperada:**

Las tablas son:

1. **DEPARTAMENTO** (id, nombre, codigo)
2. **MUNICIPIO** (id, nombre, codigo, FK: departamento)
3. **CENTRO** (id, nombre)
4. **ESCUELA** (id, nombre, direccion, acuerdo)
5. **UBICACION** (FK: escuela, FK: centro) — Relación M:M
6. **REGISTRO** (id, nombre, apellido, fecha_nac, li

cencia, FK: municipio)
7. **CORRELATIVO** (id, fecha, no_examen)
8. **EXAMEN** (id, puntaje_teórico, puntaje_práctico, resultado, FK: registro, FK: correlativo)
9. **PREGUNTAS** (id, pregunta_texto, resp_a-d, resp_correcta)
10. **PREGUNTAS_PRACTICO** (igual que PREGUNTAS pero para práctico)
11. **RESPUESTA_USUARIO** (id, respuesta, FK: examen, FK: pregunta)
12. **RESPUESTA_PRACTICO_USUARIO** (id, respuesta, FK: examen, FK: pregunta_practico)

**Relaciones:**
- DEPARTAMENTO ← 1:M → MUNICIPIO
- MUNICIPIO ← 1:M → REGISTRO
- ESCUELA ← M:M → CENTRO (vía UBICACION)
- REGISTRO ← 1:M → EXAMEN
- EXAMEN ← 1:M → RESPUESTA_USUARIO
- CORRELATIVO ← 1:M → EXAMEN

---

### 5. ¿Por qué UBICACION es una tabla intermedia y no solo una columna en ESCUELA?

**Respuesta esperada:**

Porque existe una relación **Muchos a Muchos (M:M)** entre ESCUELA y CENTRO:
- Una ESCUELA puede estar ubicada en varios CENTROS
- Un CENTRO puede tener varias ESCUELAS

**Si fuera columna (INCORRECTO):**
```
ESCUELA: nombre, direccion, centro_id
Problema: No hay lugar para más centros
```

**Solución (tabla UBICACION):**
```
UBICACION: escuela_id, centro_id
- (1, 1) Escuela AutoMaster → Centro Zona 12
- (1, 2) Escuela AutoMaster → Centro Antigua Guatemala
- ...
Solución: Permite N relaciones
```

---

### 6. ¿Qué es GENERATED ALWAYS AS IDENTITY y por qué lo usas?

**Respuesta esperada:**

Es una secuencia automática de Oracle para generar IDs únicos sin intervención.

**Antes (sin autoincrement):**
```sql
INSERT INTO DEPARTAMENTO (id, nombre, codigo)
VALUES (1, 'Guatemala', '01'); -- Debo calcular el ID
INSERT INTO DEPARTAMENTO (id, nombre, codigo)
VALUES (2, 'Sacatepéquez', '03'); -- Error: ID duplicado
```

**Ahora (con IDENTITY):**
```sql
INSERT INTO DEPARTAMENTO (nombre, codigo)
VALUES ('Guatemala', '01');
-- Oracle genera automáticamente id=1

INSERT INTO DEPARTAMENTO (nombre, codigo)
VALUES ('Sacatepéquez', '03');
-- Oracle genera automáticamente id=2
```

**Ventajas:**
- No colisión de IDs
- No necesito saber qué ID viene
- Mejor integridad

---

## Grupo C: API REST y Express (2 preguntas)

### 7. ¿Cuántos endpoints CRUD tienes y qué representa cada uno?

**Respuesta esperada:**

47 endpoints total:

**Grupos:**
- 🏢 DEPARTAMENTOS (5: GET-all, GET-id, POST, PUT, DELETE)
- 🏙️ MUNICIPIOS (5)
- 🏛️ CENTROS (2)
- 🎓 ESCUELAS (2)
- 📍 UBICACIONES (2)
- 👤 REGISTROS (2)
- 🔢 CORRELATIVOS (1)
- 📝 EXÁMENES (2)
- ❓ PREGUNTAS (1)
- ❓ PREGUNTAS PRÁCTICO (1)
- ✅ RESPUESTAS USUARIO (1)
- ✅ RESPUESTAS PRÁCTICO (1)

**Más:**
- 📊 ESTADÍSTICAS: 3 consultas complejas

**Patrón REST:**
- GET `/api/entidad` → Listar todas
- GET `/api/entidad/:id` → Una específica
- POST `/api/entidad` → Crear
- PUT `/api/entidad/:id` → Actualizar
- DELETE `/api/entidad/:id` → Eliminar

---

### 8. ¿Cómo maneja tu API la conexión a Oracle?

**Respuesta esperada:**

Mediante el archivo `src/config/db.js`:

```javascript
// Usa el driver oracledb
const oracledb = require('oracledb');

// Se conecta con credenciales del .env
const connection = await oracledb.getConnection({
  user: process.env.DB_USER,                    // EVALUACION
  password: process.env.DB_PASSWORD,            // Proyecto123
  connectionString: process.env.DB_CONNECT_STRING // localhost:1521/XEPDB1
});

// Luego cada ruta hace queries:
const result = await connection.execute(
  "SELECT * FROM EVALUACION.DEPARTAMENTO"
);
```

**Por qué es importante:**
- Variables en `.env` = credenciales no en el código
- Connection pooling = reutiliza conexiones
- Manejo de errores = si no hay BD, la API lo sabe

---

## Grupo D: Consultas Estadísticas SQL (2 preguntas)

### 9. ¿Cuál es la principal dificultad de la Consulta 1 (Estadísticas por Centro)?

**Respuesta esperada:**

Combinar datos de múltiples tablas CON agregación:

```sql
SELECT 
  CENTRO.nombre AS CENTRO,
  ESCUELA.nombre AS ESCUELA,
  COUNT(*) AS TOTAL_EXAMENES,                          -- Agregar exámenes
  ROUND(AVG(EXAMEN.puntaje_teorico), 2) AS PROMEDIO_TEORICO,
  ROUND(AVG(EXAMEN.puntaje_practico), 2) AS PROMEDIO_PRACTICO,
  COUNT(CASE WHEN resultado = 'APROBADO' THEN 1 END) AS APROBADOS
FROM CENTRO
JOIN UBICACION ON CENTRO.id_centro = UBICACION.centro_id_centro
JOIN ESCUELA ON UBICACION.escuela_id_escuela = ESCUELA.id_escuela
JOIN REGISTRO ON ... (relación con evaluados)
JOIN EXAMEN ON REGISTRO.id_registro = EXAMEN.registro_id_registro
GROUP BY CENTRO.nombre, ESCUELA.nombre;
```

**Dificultades:**
1. **Múltiples JOINs:** CENTRO → UBICACION → ESCUELA → REGISTRO → EXAMEN
2. **GROUP BY:** Agrupar por centro y escuela
3. **Agregación:** COUNT, AVG, CASE WHEN
4. **Resultado final fijo:** Exactamente la estructura de salida

---

### 10. ¿Qué significan los CASE WHEN en Consulta 3 (Pregunta Menor Aciertos)?

**Respuesta esperada:**

Son condicionales SQL para contar aciertos vs totales:

```sql
SELECT 
  PREGUNTAS.id_pregunta,
  PREGUNTAS.pregunta_texto,
  COUNT(*) AS TOTAL_RESPUESTAS,
  COUNT(CASE WHEN respuesta = respuesta_correcta THEN 1 END) AS ACIERTOS,
  ROUND(
    COUNT(CASE WHEN respuesta = respuesta_correcta THEN 1 END) * 100.0 
    / COUNT(*), 
    2
  ) AS PORCENTAJE_ACIERTOS
FROM PREGUNTAS
LEFT JOIN RESPUESTA_USUARIO ON PREGUNTAS.id_pregunta = RESPUESTA_USUARIO.pregunta_id
GROUP BY PREGUNTAS.id_pregunta
ORDER BY PORCENTAJE_ACIERTOS ASC
FETCH FIRST 1 ROW ONLY;
```

**Explicación:**
- `COUNT(*)` = Total de respuestas
- `COUNT(CASE WHEN ... THEN 1 END)` = Solo cuenta si condición es verdadera
- `Condición: respuesta = respuesta_correcta`
- Resultado: Pregunta con MENOR % (por eso ORDER BY ASC)

---

## 🎓 Tips para la Exposición

1. **Practica explicando cada sección de tu código**
2. **Dibuja el modelo relacional en papel** si te lo piden
3. **Sabe navegar tu código en el editor** (muestra live)
4. **Déjalo corriendo:** Docker levantado, API funcionando, Postman ahí
5. **Responde con ejemplos concretos** de tu proyecto
6. **Admite si no sabes** algo, pero intenta deducir
7. **Evita memorizar:** Entiende los conceptos

---

## Grading Criteria for this Section

- ✅ Responde correctamente 8-10 preguntas: **10/10**
- ✅ Responde correctamente 6-7 preguntas: **8/10**
- ✅ Responde correctamente 4-5 preguntas: **6/10**
- ⚠️ Responde correctamente 1-3 preguntas: **4/10**
- ❌ No responde o no entiende: **0/10**

---

## 📚 Materiales de Referencia

- ER Model Diagram: [Document/img/modeloRelacional.png](Document/img/modeloRelacional.png)
- DDL Script: [oracle-db/init-scripts/01_ddl.sql](oracle-db/init-scripts/01_ddl.sql)
- README: [README.md](README.md) - Secciones "Descripción de Endpoints" y "Estado del Proyecto"

