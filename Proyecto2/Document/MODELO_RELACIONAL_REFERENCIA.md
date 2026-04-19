# 🗂️ Referencia Rápida: Modelo Relacional

**Sistema:** Centros de Evaluación de Manejo — SBD1 1S 2026  
**12 Tablas — 15 Relaciones**

---

## 🏗️ Estructura de Tablas

### 1️⃣ DEPARTAMENTO
```
id_departamento (PK)        GENERATED ALWAYS AS IDENTITY
├─ nombre                   VARCHAR2(100) NOT NULL
└─ codigo                   VARCHAR2(10) NOT NULL UNIQUE
```
**Datos:** Guatemala, Sacatepéquez, Escuintla

---

### 2️⃣ MUNICIPIO
```
id_municipio (PK)                       GENERATED ALWAYS AS IDENTITY
├─ nombre                               VARCHAR2(100) NOT NULL
├─ codigo                               VARCHAR2(10) NOT NULL
└─ departamento_id_departamento (FK) → DEPARTAMENTO(id_departamento)
```
**Relación:** 1 DEPARTAMENTO = M MUNICIPIOS

---

### 3️⃣ CENTRO
```
id_centro (PK)      GENERATED ALWAYS AS IDENTITY
└─ nombre           VARCHAR2(200) NOT NULL
```
**Datos:** Centro Zona 12, Centro Antigua, Centro Escuintla

---

### 4️⃣ ESCUELA
```
id_escuela (PK)     GENERATED ALWAYS AS IDENTITY
├─ nombre           VARCHAR2(200) NOT NULL
├─ direccion        VARCHAR2(300)
└─ acuerdo          VARCHAR2(50) NOT NULL UNIQUE
```
**Datos:** AutoMaster, GuateDrive, Instituto de Conducción Segura

---

### 5️⃣ UBICACION (Tabla de Relación M:M)
```
escuela_id_escuela (FK) → ESCUELA(id_escuela)
├─ PK: (escuela_id_escuela, centro_id_centro)
└─ centro_id_centro (FK) → CENTRO(id_centro)
```
**Propósito:** Una ESCUELA en múltiples CENTROS, un CENTRO con múltiples ESCUELAS

---

### 6️⃣ REGISTRO
```
id_registro (PK)                    GENERATED ALWAYS AS IDENTITY
├─ nombre                           VARCHAR2(100) NOT NULL
├─ apellido                         VARCHAR2(100) NOT NULL
├─ fecha_nacimiento                 DATE NOT NULL
├─ numero_licencia                  VARCHAR2(20) UNIQUE
└─ municipio_id_municipio (FK)  → MUNICIPIO(id_municipio)
```
**Propósito:** Datos de personas evaluadas

---

### 7️⃣ CORRELATIVO
```
id_correlativo (PK)             GENERATED ALWAYS AS IDENTITY
├─ fecha                        DATE NOT NULL
└─ no_examen                    NUMBER NOT NULL
```
**Propósito:** Control de secuencias de exámenes

---

### 8️⃣ EXAMEN
```
id_examen (PK)                          GENERATED ALWAYS AS IDENTITY
├─ puntaje_teorico                      NUMBER(3,0)
├─ puntaje_practico                     NUMBER(3,0)
├─ resultado                            VARCHAR2(12) [APROBADO|REPROBADO]
├─ registro_id_registro (FK)        → REGISTRO(id_registro)
└─ correlativo_id_correlativo (FK)  → CORRELATIVO(id_correlativo)
```
**Propósito:** Resultado del examen por persona

---

### 9️⃣ PREGUNTAS
```
id_pregunta (PK)                GENERATED ALWAYS AS IDENTITY
├─ pregunta_texto               VARCHAR2(500) NOT NULL
├─ respuesta_a                  VARCHAR2(200)
├─ respuesta_b                  VARCHAR2(200)
├─ respuesta_c                  VARCHAR2(200)
├─ respuesta_d                  VARCHAR2(200)
└─ respuesta_correcta           VARCHAR2(1) [A|B|C|D]
```
**Propósito:** Banco de preguntas teóricas

---

### 🔟 PREGUNTAS_PRACTICO
```
id_pregunta_practico (PK)       GENERATED ALWAYS AS IDENTITY
├─ pregunta_texto               VARCHAR2(500) NOT NULL
├─ respuesta_a                  VARCHAR2(200)
├─ respuesta_b                  VARCHAR2(200)
├─ respuesta_c                  VARCHAR2(200)
├─ respuesta_d                  VARCHAR2(200)
└─ respuesta_correcta           VARCHAR2(1) [A|B|C|D]
```
**Nota:** Igual estructura a PREGUNTAS pero para examen práctico

---

### 1️⃣1️⃣ RESPUESTA_USUARIO
```
id_respuesta_usuario (PK)               GENERATED ALWAYS AS IDENTITY
├─ respuesta_seleccionada               VARCHAR2(1)
├─ examen_id_examen (FK)            → EXAMEN(id_examen)
└─ pregunta_id_pregunta (FK)        → PREGUNTAS(id_pregunta)
```
**Propósito:** Respuesta de cada persona a cada pregunta teórica

---

### 1️⃣2️⃣ RESPUESTA_PRACTICO_USUARIO
```
id_respuesta_practico (PK)                  GENERATED ALWAYS AS IDENTITY
├─ respuesta_seleccionada                   VARCHAR2(1)
├─ examen_id_examen (FK)                → EXAMEN(id_examen)
└─ pregunta_practico_id_pregunta (FK)   → PREGUNTAS_PRACTICO(id_pregunta_practico)
```
**Propósito:** Respuesta de cada persona a cada pregunta práctica

---

## 🔗 Diagrama de Relaciones

```
DEPARTAMENTO (1)
       ↓  1:M
   MUNICIPIO (M)
       ↓  1:M
   REGISTRO (M) 
       ↓  1:M
     EXAMEN (M) ←──────── CORRELATIVO (1)
       ↓  1:M              (1 Correlativo por N exámenes)
       ├─ RESPUESTA_USUARIO (relación con PREGUNTAS)
       └─ RESPUESTA_PRACTICO_USUARIO (relación con PREGUNTAS_PRACTICO)

ESCUELA (M) ←──→ CENTRO (M)
    (Relación M:M vía UBICACION)
```

---

## 📊 Consultas Comunes

### Consulta 1: Estadísticas por Centro
```sql
SELECT 
  CENTRO.nombre,
  ESCUELA.nombre,
  COUNT(EXAMEN.id_examen) AS examenes,
  AVG(EXAMEN.puntaje_teorico) AS prom_teorico,
  AVG(EXAMEN.puntaje_practico) AS prom_practico,
  COUNT(CASE WHEN resultado = 'APROBADO' THEN 1 END) AS aprobados
FROM CENTRO
JOIN UBICACION ON CENTRO.id_centro = UBICACION.centro_id_centro
JOIN ESCUELA ON UBICACION.escuela_id_escuela = ESCUELA.id_escuela
JOIN REGISTRO ON ... 
JOIN EXAMEN ON REGISTRO.id_registro = EXAMEN.registro_id_registro
GROUP BY CENTRO.nombre, ESCUELA.nombre;
```

---

### Consulta 2: Ranking Top 10
```sql
SELECT 
  ROW_NUMBER() OVER (ORDER BY puntaje_total DESC) AS ranking,
  REGISTRO.nombre || ' ' || REGISTRO.apellido AS nombre_completo,
  EXAMEN.puntaje_teorico,
  EXAMEN.puntaje_practico,
  EXAMEN.puntaje_teorico + EXAMEN.puntaje_practico AS puntaje_total,
  EXAMEN.resultado
FROM REGISTRO
JOIN EXAMEN ON REGISTRO.id_registro = EXAMEN.registro_id_registro
ORDER BY puntaje_total DESC
FETCH FIRST 10 ROWS ONLY;
```

---

### Consulta 3: Pregunta con Menor % Aciertos
```sql
SELECT 
  PREGUNTAS.id_pregunta,
  PREGUNTAS.pregunta_texto,
  COUNT(*) AS total_respuestas,
  SUM(CASE WHEN respuesta_seleccionada = respuesta_correcta THEN 1 ELSE 0 END) AS aciertos,
  ROUND(
    SUM(CASE WHEN respuesta_seleccionada = respuesta_correcta THEN 1 ELSE 0 END) * 100.0
    / COUNT(*), 2
  ) AS porcentaje_aciertos
FROM PREGUNTAS
LEFT JOIN RESPUESTA_USUARIO ON PREGUNTAS.id_pregunta = RESPUESTA_USUARIO.pregunta_id_pregunta
GROUP BY PREGUNTAS.id_pregunta
ORDER BY porcentaje_aciertos ASC
FETCH FIRST 1 ROW ONLY;
```

---

## 📌 Restricciones Implementadas

### Primary Keys (PK)
- Todas las tablas tienen `id_*` como PK con `GENERATED ALWAYS AS IDENTITY`

### Foreign Keys (FK)
- MUNICIPIO → DEPARTAMENTO (ON DELETE CASCADE)
- UBICACION → ESCUELA (ON DELETE CASCADE)
- UBICACION → CENTRO (ON DELETE CASCADE)
- REGISTRO → MUNICIPIO (ON DELETE CASCADE)
- EXAMEN → REGISTRO (ON DELETE CASCADE)
- EXAMEN → CORRELATIVO (ON DELETE CASCADE)
- RESPUESTA_USUARIO → EXAMEN (ON DELETE CASCADE)
- RESPUESTA_USUARIO → PREGUNTAS (ON DELETE CASCADE)
- RESPUESTA_PRACTICO_USUARIO → EXAMEN (ON DELETE CASCADE)
- RESPUESTA_PRACTICO_USUARIO → PREGUNTAS_PRACTICO (ON DELETE CASCADE)

### Unique Constraints
- DEPARTAMENTO(codigo)
- ESCUELA(acuerdo)
- REGISTRO(numero_licencia)

### Not Null Constraints
- Todas las columnas de datos críticos

---

## 🗄️ Datos de Prueba Insertados

### DEPARTAMENTOS (3 registros)
```
1. Guatemala, código 01
2. Sacatepéquez, código 03
3. Escuintla, código 05
```

### MUNICIPIOS (5 registros por departamento)

### CENTROS (3 registros)

### ESCUELAS (3 registros)

### UBICACIONES (5 relaciones M:M)

### REGISTROS (5 personas evaluadas)

### CORRELATIVOS (3 secuencias)

### EXÁMENES (5 resultados)

### PREGUNTAS (2 teóricas)

### RESPUESTAS (asociadas a exámenes)

---

## 🚀 Scripts SQL

### Crear todas las tablas:
```bash
File: oracle-db/init-scripts/01_ddl.sql
Ejecutado automáticamente al: docker compose up -d
```

### Insertar datos de prueba:
```bash
File: oracle-db/init-scripts/02_dml.sql
Ejecutado automáticamente al: docker compose up -d
```

### Ver tablas desde dentro del contenedor:
```bash
docker exec -it oracle-xe-evaluacion sqlplus EVALUACION/Proyecto123@XEPDB1
SQL> SELECT table_name FROM user_tables;
```

---

## 📝 Convenciones Aplicadas

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| Tabla | Singular, MAYÚSCULAS | DEPARTAMENTO, EXAMEN |
| Columna | snake_case, puede ser FK | id_departamento, registro_id_registro |
| PK | id_[tabla] | id_departamento, id_examen |
| FK | [tabla]_id_[tabla] | departamento_id_departamento |
| M:M | [tabla1]_[tabla2] | ubicacion |

---

## 🔍 Verificación de Integridad

### Verificar tablas creadas:
```sql
SELECT COUNT(*) FROM user_tables;  -- Debe ser 12
```

### Verificar datos insertados:
```sql
SELECT COUNT(*) FROM DEPARTAMENTO;           -- 3
SELECT COUNT(*) FROM MUNICIPIO;              -- 5+
SELECT COUNT(*) FROM REGISTRO;               -- 5
SELECT COUNT(*) FROM EXAMEN;                 -- 5
```

### Verificar integridad referencial:
```sql
SELECT * FROM user_constraints WHERE constraint_type = 'R';
-- Debe mostrar 10 Foreign Keys
```

---

**Referencia Rápida — Para Consultas:** [Document/PREGUNTAS_TEORICAS.md](Document/PREGUNTAS_TEORICAS.md)  
**Para Levantar BD:** [README.md](README.md) — Paso 3  
**Para Implementar Endpoints:** [postman/SBD1_Evaluacion.postman_collection.json](postman/SBD1_Evaluacion.postman_collection.json)
