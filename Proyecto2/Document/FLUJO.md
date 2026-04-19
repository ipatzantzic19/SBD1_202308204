# 🔄 Flujo Completo: Docker Compose → Oracle → DBeaver

**Guía detallada de cómo funciona todo el sistema desde el inicio hasta ver los datos en DBeaver**

---

## 📍 Índice

1. [Fase 1: Docker Compose Levanta el Contenedor](#fase-1-docker-compose-levanta-el-contenedor)
2. [Fase 2: Oracle Ejecuta Automáticamente los Scripts](#fase-2-oracle-ejecuta-automáticamente-los-scripts)
3. [Fase 3: Oracle Crea la Base de Datos](#fase-3-oracle-crea-la-base-de-datos)
4. [Fase 4: DBeaver Se Conecta](#fase-4-dbeaver-se-conecta-a-la-base-de-datos)
5. [Fase 5: DBeaver Muestra los Datos](#fase-5-dbeaver-muestra-los-datos)
6. [Diagrama General](#-diagrama-general-del-flujo-completo)
7. [Puntos Clave](#-puntos-clave-para-entender)
8. [Verificación Paso a Paso](#-verificación-paso-a-paso)

---

## Fase 1: Docker Compose Levanta el Contenedor

Cuando ejecutas:
```bash
docker compose up -d
```

Docker hace esto automáticamente:

```
1. Lee docker-compose.yml
   ↓
2. Descarga imagen Oracle XE (si no la tiene)
   ↓
3. Crea un contenedor llamado "oracle-xe-evaluacion"
   ↓
4. Monta los archivos del volumen
   ↓
5. Inicia Oracle dentro del contenedor
```

### ¿Qué hace el archivo docker-compose.yml?

En **docker-compose.yml**:
```yaml
services:
  oracle-db:
    image: container-registry.oracle.com/database/express:21.3.0-xe
    container_name: oracle-xe-evaluacion
    
    volumes:
      - oracle-data:/opt/oracle/oradata          
      - ./oracle-db/init-scripts:/opt/oracle/scripts/startup
```

**Explicación de los volúmenes:**

| Volumen | Origen (Tu PC) | Destino (Contenedor) | Propósito |
|---------|--|--|--|
| `oracle-data` | ~/.docker/volumes/ | `/opt/oracle/oradata` | Guarda los datos de la BD (persisten) |
| `init-scripts` | `./oracle-db/init-scripts/` | `/opt/oracle/scripts/startup` | Copia tus scripts SQL |

### Diagrama de Montaje

```
Tu PC                          Contenedor Docker
┌──────────────────────┐       ┌─────────────────────┐
│                      │       │                     │
│ oracle-db/           │       │ /opt/oracle/        │
│ init-scripts/        │──────→│ scripts/startup     │
│                      │ mount  │                     │
│ 00_create_user.sql   │       │ 00_create_user.sql  │
│ 01_ddl.sql           │       │ 01_ddl.sql          │
│ 02_dml.sql           │       │ 02_dml.sql          │
│                      │       │                     │
└──────────────────────┘       │ Oracle XE ejecuta   │
                                │ los scripts         │
                                │                     │
                                └─────────────────────┘
```

---

## Fase 2: Oracle Ejecuta Automáticamente los Scripts

Cuando Oracle XE inicia en Docker, **busca automáticamente** en `/opt/oracle/scripts/startup` y ejecuta todos los archivos `.sql` en **orden alfabético**:

```
Docker contenedor inicia
  ↓
Oracle XE inicializa
  ↓
Busca en /opt/oracle/scripts/startup
  ↓
Encuentra 3 archivos y los ordena:
  ├─ 00_create_user.sql       ← 1️⃣ Primero
  ├─ 01_ddl.sql               ← 2️⃣ Segundo
  └─ 02_dml.sql               ← 3️⃣ Tercero
  ↓
Oracle los ejecuta en ese orden
  ↓
Resultado final:
  ├─ Usuario EVALUACION creado ✅
  ├─ 12 tablas creadas ✅
  └─ Datos insertados en todas ✅
```

### ¿Por qué el orden es importante?

```sql
-- 00_create_user.sql
CREATE USER EVALUACION ...      ← Debe existir primero
GRANT CREATE TABLE TO EVALUACION;

-- 01_ddl.sql
CREATE TABLE EVALUACION.DEPARTAMENTO ...  ← Usuario debe existir

-- 02_dml.sql
INSERT INTO EVALUACION.DEPARTAMENTO ...   ← Tabla debe existir
```

Si cambiamos el orden, fallaría. Por eso usamos números: `00_`, `01_`, `02_`

---

## Fase 3: Oracle Crea la Base de Datos

Cuando Oracle ejecuta los scripts **en orden**:

### Paso 1️⃣: 00_create_user.sql

```sql
ALTER SESSION SET CONTAINER = XEPDB1;
CREATE USER EVALUACION IDENTIFIED BY "Proyecto123";
GRANT CREATE SESSION TO EVALUACION;
GRANT CONNECT TO EVALUACION;
GRANT RESOURCE TO EVALUACION;
GRANT CREATE TABLE TO EVALUACION;
GRANT UNLIMITED TABLESPACE TO EVALUACION;
COMMIT;
```

**Estructura creada en Oracle:**

```
📦 Oracle XE (Contenedor)
└─ CDB (Container Database - Nivel superior)
   │
   └─ XEPDB1 (Pluggable Database - Tu BD)
      │
      └─ Usuario: EVALUACION ✅
          ├─ Permisos:
          │  ├─ CREATE SESSION (puede conectarse)
          │  ├─ CREATE TABLE (puede crear tablas)
          │  ├─ CREATE SEQUENCE (puede crear secuencias)
          │  └─ UNLIMITED TABLESPACE (sin límite de espacio)
          │
          └─ Contraseña: Proyecto123
```

**Analogía:** Es como crear una nueva persona con permisos para crear muebles en su casa.

---

### Paso 2️⃣: 01_ddl.sql (Data Definition Language)

```sql
-- El DDL DEFINE la estructura:
CREATE TABLE EVALUACION.DEPARTAMENTO (
  id_departamento NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR2(100) NOT NULL,
  codigo VARCHAR2(10) NOT NULL UNIQUE
);

CREATE TABLE EVALUACION.MUNICIPIO (
  id_municipio NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre VARCHAR2(100) NOT NULL,
  codigo VARCHAR2(10) NOT NULL,
  departamento_id_departamento NUMBER NOT NULL,
  CONSTRAINT fk_mun_dep FOREIGN KEY (departamento_id_departamento)
    REFERENCES EVALUACION.DEPARTAMENTO(id_departamento)
);

-- ... y 10 tablas más ...
```

**Estructura creada:**

```
EVALUACION (Schema/Usuario)
├─ DEPARTAMENTO (12 filas posibles: vacío)
├─ MUNICIPIO
├─ CENTRO
├─ ESCUELA
├─ UBICACION
├─ REGISTRO
├─ CORRELATIVO
├─ EXAMEN
├─ PREGUNTAS
├─ PREGUNTAS_PRACTICO
├─ RESPUESTA_USUARIO
└─ RESPUESTA_PRACTICO_USUARIO
```

**Analogía:** Es como dibujar los planos de las habitaciones. Todavía están vacías.

---

### Paso 3️⃣: 02_dml.sql (Data Manipulation Language)

```sql
-- El DML LLENA de datos:
INSERT INTO EVALUACION.DEPARTAMENTO (nombre, codigo) 
VALUES ('Guatemala', '01');

INSERT INTO EVALUACION.DEPARTAMENTO (nombre, codigo) 
VALUES ('Sacatepéquez', '03');

INSERT INTO EVALUACION.DEPARTAMENTO (nombre, codigo) 
VALUES ('Escuintla', '05');

-- ... más inserciones en todas las tablas ...

INSERT INTO EVALUACION.MUNICIPIO (nombre, codigo, departamento_id_departamento) 
VALUES ('Guatemala', '01', 1);

-- ... etc para todas las tablas ...
```

**Datos dentro de las tablas:**

```
EVALUACION.DEPARTAMENTO (3 registros)
┌────────────────────┬──────────────┬────────┐
│ ID_DEPARTAMENTO    │ NOMBRE       │ CODIGO │
├────────────────────┼──────────────┼────────┤
│ 1                  │ Guatemala    │ 01     │
│ 2                  │ Sacatepéquez │ 03     │
│ 3                  │ Escuintla    │ 05     │
└────────────────────┴──────────────┴────────┘

EVALUACION.EXAMEN (5 registros)
┌──────────────────────┬──────────────────────┐
│ ID_EXAMEN            │ ESTADO               │
├──────────────────────┼──────────────────────┤
│ 1                    │ Aprobado             │
│ 2                    │ Reprobado            │
│ 3                    │ Aprobado             │
│ 4                    │ Aprobado             │
│ 5                    │ Reprobado            │
└──────────────────────┴──────────────────────┘

... Y así en todas las 12 tablas (>50 registros totales)
```

**Analogía:** Es como mudarse con muebles. Las casas ahora tienen datos.

---

## Fase 4: DBeaver Se Conecta a la Base de Datos

DBeaver **mira hacia adentro del contenedor** para ver qué hay:

```
Tu PC (DBeaver)
    ↓
    ↓ Conecta por red a localhost:1521
    ↓
Contenedor Docker
    ↓
    ↓ Oracle XE escucha en el puerto 1521
    ↓
Oracle XE (Puerto 1521)
    ↓
    ↓ Autentica con usuario EVALUACION
    ↓
XEPDB1 (PDB)
    ↓
    ↓ Autoriza acceso al schema EVALUACION
    ↓
DBeaver ve las 12 tablas ✅
```

### ¿Cómo se realiza la conexión?

Cuando ingresas en DBeaver:

| Campo | Valor |
|-------|-------|
| Host | localhost |
| Port | 1521 |
| Database | XEPDB1 |
| Username | EVALUACION |
| Password | Proyecto123 |

**Lo que sucede internamente:**

```java
// DBeaver ejecuta algo como esto (en Java):
Connection conn = DriverManager.getConnection(
  "jdbc:oracle:thin:@localhost:1521/XEPDB1",
  "EVALUACION",
  "Proyecto123"
);

// Oracle verifica:
// 1. ¿Existe localhost:1521? SÍ (el contenedor)
// 2. ¿Existe XEPDB1? SÍ (la PDB)
// 3. ¿Existe usuario EVALUACION? SÍ (lo creó 00_create_user.sql)
// 4. ¿Contraseña correcta? SÍ (es Proyecto123)
// 5. ¿Tiene permisos? SÍ (GRANT CREATE SESSION)

// Resultado: CONNECTED ✅
```

### Diagrama de Conexión

```
┌─────────────────────────────┐
│      Tu Computadora         │
├─────────────────────────────┤
│                             │
│  DBeaver Community          │
│  ┌─────────────────────┐   │
│  │ New Connection:     │   │
│  │ Host: localhost     │   │
│  │ Port: 1521          │   │
│  │ Database: XEPDB1    │   │
│  │ User: EVALUACION    │   │
│  └─────────────────────┘   │
│          ↓                  │
│    Conectando...            │
└─────────────────────────────┘
          ↓ TCP/IP PORT 1521
          ↓
┌─────────────────────────────┐
│   Docker Desktop            │
├─────────────────────────────┤
│                             │
│  Contenedor:                │
│  oracle-xe-evaluacion       │
│                             │
│  Oracle XE escucha:         │
│  Port 1521 ✅              │
│                             │
│  Valida credenciales:       │
│  ✅ Usuario EVALUACION existe│
│  ✅ Contraseña correcta     │
│  ✅ Permisos suficientes    │
│                             │
└─────────────────────────────┘
          ↓
  ✅ CONNECTED
```

---

## Fase 5: DBeaver Muestra los Datos

Una vez conectado, DBeaver hace queries SQL a Oracle:

### Query 1: Listar esquemas
```sql
-- DBeaver internamente ejecuta:
SELECT username FROM dba_users WHERE username = 'EVALUACION';

-- Oracle responde:
┌──────────────┐
│ USERNAME     │
├──────────────┤
│ EVALUACION   │
└──────────────┘
```

### Query 2: Listar tablas
```sql
-- DBeaver internamente ejecuta:
SELECT table_name FROM user_tables WHERE owner = 'EVALUACION';

-- Oracle responde:
┌──────────────────────────────┐
│ TABLE_NAME                   │
├──────────────────────────────┤
│ DEPARTAMENTO                 │
│ MUNICIPIO                    │
│ CENTRO                       │
│ ESCUELA                      │
│ UBICACION                    │
│ REGISTRO                     │
│ CORRELATIVO                  │
│ EXAMEN                       │
│ PREGUNTAS                    │
│ PREGUNTAS_PRACTICO           │
│ RESPUESTA_USUARIO            │
│ RESPUESTA_PRACTICO_USUARIO   │
└──────────────────────────────┘
```

### Query 3: Ver datos de una tabla
```sql
-- Cuando haces Click Derecho → Read Data en DEPARTAMENTO:
SELECT * FROM EVALUACION.DEPARTAMENTO;

-- Oracle responde:
┌──────────────────────┬──────────────┬────────┐
│ ID_DEPARTAMENTO      │ NOMBRE       │ CODIGO │
├──────────────────────┼──────────────┼────────┤
│ 1                    │ Guatemala    │ 01     │
│ 2                    │ Sacatepéquez │ 03     │
│ 3                    │ Escuintla    │ 05     │
└──────────────────────┴──────────────┴────────┘
```

Y DBeaver lo muestra en una tabla visual bonita. ✅

---

## 📊 Diagrama General del Flujo Completo

```
┌─────────────────────────────────────────────────────────────┐
│                        TU COMPUTADORA                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Tu Proyecto (Carpeta)                                    │
│  ├─ .env                                                  │
│  ├─ docker-compose.yml                                   │
│  ├─ oracle-db/init-scripts/                              │
│  │  ├─ 00_create_user.sql                                │
│  │  ├─ 01_ddl.sql          ← Archivos SQL               │
│  │  └─ 02_dml.sql                                        │
│  │                                                        │
│  └─ Corres: docker compose up -d                         │
│                ↓ (Docker Desktop)                         │
│                                                           │
├─────────────────────────────────────────────────────────────┤
│                    DOCKER DESKTOP                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Contenedor: oracle-xe-evaluacion                   │  │
│  │  ├─ Oracle XE 21.3.0                                │  │
│  │  ├─ Puerto expuesto: 1521                           │  │
│  │  ├─ Volumen: /opt/oracle/scripts/startup            │  │
│  │  │   (contiene tus 3 scripts SQL)                   │  │
│  │  │                                                  │  │
│  │  ├─ Ejecuta automáticamente [EN ORDEN]:            │  │
│  │  │  1️⃣ 00_create_user.sql                          │  │
│  │  │     └─ Crea usuario EVALUACION ✅               │  │
│  │  │                                                  │  │
│  │  │  2️⃣ 01_ddl.sql                                  │  │
│  │  │     └─ Crea 12 tablas (vacías) ✅               │  │
│  │  │                                                  │  │
│  │  │  3️⃣ 02_dml.sql                                  │  │
│  │  │     └─ Inserta 50+ registros ✅                 │  │
│  │  │                                                  │  │
│  │  └─ Resultado: Base de datos LISTA ✅              │  │
│  └──────────────────────────────────────────────────────┘  │
│                ↓ Network: localhost:1521                   │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  DBeaver Community (Cliente)                        │  │
│  │  ├─ New Connection → Oracle                         │  │
│  │  ├─ Host: localhost                                 │  │
│  │  ├─ Port: 1521                                      │  │
│  │  ├─ Database: XEPDB1                                │  │
│  │  ├─ Username: EVALUACION                            │  │
│  │  ├─ Password: Proyecto123                           │  │
│  │  │                                                  │  │
│  │  ├─ Test Connection ✅ CONNECTED                   │  │
│  │  │                                                  │  │
│  │  └─ Navegador muestra:                              │  │
│  │     XEPDB1 → Schemas → EVALUACION → Tables (12)    │  │
│  │     ├─ DEPARTAMENTO (3 filas) ✅                    │  │
│  │     ├─ CENTRO (3 filas) ✅                          │  │
│  │     ├─ EXAMEN (5 filas) ✅                          │  │
│  │     └─ ... (9 tablas más con datos) ✅              │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔑 Puntos Clave para Entender

### 1. Los Scripts se Ejecutan UNA SOLA VEZ

Primera vez que ejecutas Docker:
```bash
docker compose up -d    
# Oracle XE inicia → Ve los scripts → Los ejecuta
# Resultado: TODO se crea ✅
```

Segunda vez (si ejecutas el mismo comando):
```bash
docker compose up -d    
# El contenedor ya existe
# Los scripts NO se ejecutan de nuevo
# La BD sigue igual ✅
```

Para forzar que se ejecuten de nuevo:
```bash
docker compose down -v   # Elimina todo (-v = elimina volumen)
docker compose up -d     # Crea de nuevo → Ejecuta scripts de nuevo
```

### 2. Los Datos Persisten (No se Pierden)

El volumen `oracle-data` guarda los datos en tu PC:
```
Tu PC:
~/.docker/volumes/oracle-data/_data/   ← Datos físicos aquí
```

Aunque cierres Docker o reinicies:
```bash
docker compose down      # Para los contenedores
# Los datos siguen en el volumen

docker compose up -d     # Reinicia
# Los mismos datos están aquí ✅
```

Solo se pierden si ejecutas:
```bash
docker compose down -v   # El -v ELIMINA el volumen ⚠️
```

### 3. DBeaver no Entra al Contenedor

DBeaver **NO accede directamente** al contenedor.  
Se conecta como si Oracle fuera un servidor normal:

```
DBeaver → TCP/IP → Docker NAT Network → Oracle Port 1521 → Oracle XE
```

Por eso funciona desde cualquier cliente (DBeaver, SQL*Plus, Node.js, etc.)

### 4. Las Credenciales Vienen de los Scripts

- El usuario `EVALUACION` **no existía** antes
- Las tablas **no existían** antes
- Los datos **estaban vacíos** antes

Todo se crea por los scripts en orden:
```
00_create_user.sql  → Crea EVALUACION
01_ddl.sql          → Crea tablas (vacías)
02_dml.sql          → Llena de datos
```

### 5. El Orden de los Scripts es CRÍTICO

```sql
-- Si cambiamos el orden:

❌ 02_dml.sql primero
   INSERT INTO EVALUACION.DEPARTAMENTO ...
   Error: Tabla no existe aún

❌ 01_ddl.sql primero
   CREATE TABLE EVALUACION.DEPARTAMENTO ...
   Error: Usuario EVALUACION no existe aún

✅ 00_create_user.sql primero
   CREATE USER EVALUACION ...
   Luego 01_ddl.sql
   Luego 02_dml.sql
   TODO funciona
```

Por eso usamos números: `00_`, `01_`, `02_` (orden alfabético)

---

## ✅ Verificación Paso a Paso

### Paso 1: Levantar Docker

```bash
cd /home/isai/Documentos/Github/SBD1_202308204/Proyecto2
docker compose up -d
```

Resultado esperado:
```
[+] Running 1/1
 ✓ Container oracle-xe-evaluacion  Started
```

Oracle empieza a inicializar... (tarda 2-3 minutos)

---

### Paso 2: Ver que ejecutó los scripts

```bash
docker logs oracle-xe-evaluacion | grep -i "table created\|user created"
```

Resultado esperado (verás muchas líneas de):
```
Table created.
Table created.
Table created.
...
Table created.
```

O directamente:
```bash
docker logs oracle-xe-evaluacion | tail -50
```

Busca el mensaje:
```
DATABASE IS READY TO USE!
```

---

### Paso 3: Validar que los datos se crearon

```bash
docker exec -i oracle-xe-evaluacion sqlplus -s EVALUACION/Proyecto123@//localhost/XEPDB1 << 'EOF'
SELECT COUNT(*) as num_tablas FROM user_tables;
SELECT COUNT(*) as departamentos FROM EVALUACION.DEPARTAMENTO;
SELECT COUNT(*) as exams FROM EVALUACION.EXAMEN;
EXIT;
EOF
```

Resultado esperado:
```
NUM_TABLAS
----------
        12

DEPARTAMENTOS
-------------
            3

EXAMS
-----
    5
```

✅ Si ves estos números significa que TODO funcionó.

---

### Paso 4: Abre DBeaver

1. Abre DBeaver Community
2. **Database** → **New Database Connection**
3. Selecciona **Oracle**
4. Completa:
   - Host: `localhost`
   - Port: `1521`
   - Database: `XEPDB1`
   - Username: `EVALUACION`
   - Password: `Proyecto123`

---

### Paso 5: Test Connection

Haz clic en **Test Connection**.

**Si ves:** ✅ **Connected**
- El contenedor está corriendo ✅
- Oracle está escuchando en puerto 1521 ✅
- El usuario EVALUACION existe ✅
- La contraseña es correcta ✅

**Si ves error:**
```
ORA-01017: invalid username/password; logon denied
```
- Verifica que el usuario sea `EVALUACION` (sin `c##`)
- Verifica la contraseña sea `Proyecto123`
- Verifica que XEPDB1 sea el database

---

### Paso 6: Expande y ve las tablas

En el navegador izquierdo de DBeaver:

```
XEPDB1 (conectado como EVALUACION)
└─ Schemas
   └─ EVALUACION
      └─ Tables
         ├─ DEPARTAMENTO
         ├─ MUNICIPIO
         ├─ CENTRO
         ├─ ESCUELA
         ├─ UBICACION
         ├─ REGISTRO
         ├─ CORRELATIVO
         ├─ EXAMEN
         ├─ PREGUNTAS
         ├─ PREGUNTAS_PRACTICO
         ├─ RESPUESTA_USUARIO
         └─ RESPUESTA_PRACTICO_USUARIO
```

Deberías ver **12 tablas** ✅

---

### Paso 7: Ve los datos

Haz **Clic Derecho** en `DEPARTAMENTO` → **Read Data**

Deberías ver:
```
┌──────────────────────┬──────────────┬────────┐
│ ID_DEPARTAMENTO      │ NOMBRE       │ CODIGO │
├──────────────────────┼──────────────┼────────┤
│ 1                    │ Guatemala    │ 01     │
│ 2                    │ Sacatepéquez │ 03     │
│ 3                    │ Escuintla    │ 05     │
└──────────────────────┴──────────────┴────────┘
```

✅ Si ves esto significa que TODO funcionó correctamente.

---

## 📝 Resumen en Una Frase

> **Docker Compose levanta un contenedor con Oracle, ejecuta automáticamente tus 3 scripts SQL (en orden) que crean usuario+tablas+datos, y DBeaver se conecta a ese Oracle como si fuera un servidor normal para ver qué se creó.**

---

## 🎯 Siguientes Pasos

1. ✅ DCon Docker corriendo y DBeaver conectado
2. ⏳ Instalar dependencias Node.js: `npm install`
3. ⏳ Crear 13 rutas CRUD en `src/routes/`
4. ⏳ Probar en Postman
5. ⏳ Documentar en README

Ver: [PROXIMAS_FASES.md](PROXIMAS_FASES.md)

---

*Documento creado: 18 de abril de 2026*
