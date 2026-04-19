# 📚 Guía de Aprendizaje Detallada — Proyecto 2 SBD1

> Esta guía explica cada concepto desde cero y te lleva paso a paso.  
> No necesitas saber Docker, Node.js ni Express para comenzar.

---

# FASE 0 — Instalación de herramientas

## ¿Qué es Docker y por qué lo necesitamos?

Imagina que tienes una receta de cocina. Docker es como una "caja mágica" donde metes la receta y todos los ingredientes exactos, y cualquier persona puede abrir esa caja y preparar el mismo plato idéntico, sin importar si su cocina es diferente.

En términos técnicos: Docker empaqueta software (como Oracle XE) junto con todo lo que necesita para funcionar, dentro de un **contenedor**. Esto significa que Oracle correrá igual en tu computadora, en la de tu auxiliar y en cualquier otra.

### Pasos de instalación

**1. Docker Desktop**
```
https://www.docker.com/products/docker-desktop/
```
- Descarga el instalador para tu sistema operativo (Windows/Mac)
- Instala y abre Docker Desktop
- Espera a que el ícono de la ballena aparezca en la barra de tareas ✅

**2. Node.js**
```
https://nodejs.org/
```
- Descarga la versión LTS (Long Term Support) — la recomendada
- Instala con todas las opciones por defecto

**3. DBeaver Community**
```
https://dbeaver.io/download/
```
- Descarga la versión Community (gratuita)
- Instala normalmente

**4. Postman**
```
https://www.postman.com/downloads/
```
- Descarga e instala
- Puedes crear cuenta gratuita o saltar ese paso

**5. Verificar instalación**

Abre una terminal (cmd en Windows, Terminal en Mac) y escribe:
```bash
docker --version
node --version
npm --version
git --version
```
Si ves números de versión en cada línea, todo está correcto ✅

---

# FASE 1 — Docker + Oracle XE

## Conceptos clave antes de empezar

### ¿Qué es un archivo docker-compose.yml?
Es un archivo de texto que le dice a Docker: "quiero levantar estos servicios, con estas configuraciones". Como dar instrucciones escritas en lugar de escribir comandos largos cada vez.

### ¿Qué es un volumen?
Cuando un contenedor se apaga, sus datos desaparecen. Un volumen es una carpeta especial que Docker guarda en tu computadora para que los datos persistan aunque apagues y vuelvas a encender el contenedor.

### ¿Qué es el archivo .env?
Es un archivo donde guardas contraseñas y configuraciones sensibles. **Nunca** se sube a GitHub. El archivo `docker-compose.yml` lo lee automáticamente.

---

## Paso 1.1 — Crear el repositorio de GitHub

```bash
# En tu terminal, ve a donde quieres guardar el proyecto
cd Documents

# Clona el repositorio que creaste en GitHub
git clone https://github.com/TU_USUARIO/SBD1B_1S2026_TUCARNET.git

# Entra a la carpeta
cd SBD1B_1S2026_TUCARNET
```

## Paso 1.2 — Crear el archivo .gitignore

Crea un archivo llamado `.gitignore` en la raíz del proyecto:
```
.env
node_modules/
*.log
```
Este archivo le dice a Git qué NO subir a GitHub (contraseñas, librerías enormes, etc.)

## Paso 1.3 — Crear el archivo .env

Crea `.env` en la raíz:
```env
ORACLE_PWD=Proyecto123
DB_USER=EVALUACION
DB_PASSWORD=Proyecto123
DB_CONNECT_STRING=localhost:1521/XEPDB1
PORT=3000
```
> ⚠️ Usa una contraseña que tenga mayúsculas, minúsculas y números. Oracle XE la requiere así.  
> ✅ `EVALUACION` es un usuario local del PDB (sin prefijo `c##`)

## Paso 1.4 — Crear el docker-compose.yml

Crea `docker-compose.yml` en la raíz:

```yaml
version: '3.8'

services:
  oracle-db:
    image: container-registry.oracle.com/database/express:21.3.0-xe
    container_name: oracle-xe-evaluacion
    environment:
      - ORACLE_PWD=${ORACLE_PWD}
      - ORACLE_CHARACTERSET=AL32UTF8
    ports:
      - "1521:1521"
      - "5500:5500"
    volumes:
      - oracle-data:/opt/oracle/oradata
      - ./oracle-db/init-scripts:/opt/oracle/scripts/startup
    healthcheck:
      test: ["CMD-SHELL", "echo 'SELECT 1 FROM DUAL;' | sqlplus -S EVALUACION/${ORACLE_PWD}@//localhost/XEPDB1"]
      interval: 30s
      timeout: 10s
      retries: 15
      start_period: 120s

volumes:
  oracle-data:
```

**¿Qué significa cada parte?**
- `image`: la imagen de Oracle XE que descargará Docker automáticamente
- `environment`: variables de configuración del contenedor (usa las de .env)
- `ports`: "1521:1521" significa que el puerto 1521 de tu PC se conecta al 1521 del contenedor
- `volumes`: monta la carpeta de scripts SQL para que se ejecuten al iniciar
- `healthcheck`: verifica que Oracle esté listo antes de continuar

## Paso 1.5 — Crear el script DDL (01_ddl.sql)

Crea la carpeta `oracle-db/init-scripts/` y dentro el archivo `01_ddl.sql`:

```sql
-- ============================================
-- DDL - Centros de Evaluación de Manejo
-- SBD1 Proyecto 2 - USAC 2026
-- ============================================

-- Eliminar tablas si existen (en orden inverso a dependencias)
BEGIN
  FOR t IN (SELECT table_name FROM user_tables ORDER BY table_name) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- DEPARTAMENTO
CREATE TABLE DEPARTAMENTO (
  id_departamento NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre          VARCHAR2(100) NOT NULL,
  codigo          VARCHAR2(10)  NOT NULL UNIQUE
);

-- MUNICIPIO
CREATE TABLE MUNICIPIO (
  id_municipio                  NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre                        VARCHAR2(100) NOT NULL,
  codigo                        VARCHAR2(10)  NOT NULL,
  departamento_id_departamento  NUMBER        NOT NULL,
  CONSTRAINT fk_mun_dep FOREIGN KEY (departamento_id_departamento)
    REFERENCES DEPARTAMENTO(id_departamento)
);

-- CENTRO
CREATE TABLE CENTRO (
  id_centro NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre    VARCHAR2(200) NOT NULL
);

-- ESCUELA
CREATE TABLE ESCUELA (
  id_escuela NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre     VARCHAR2(200) NOT NULL,
  direccion  VARCHAR2(300),
  acuerdo    VARCHAR2(50)  NOT NULL UNIQUE
);

-- UBICACION (relación entre ESCUELA y CENTRO)
CREATE TABLE UBICACION (
  escuela_id_escuela NUMBER NOT NULL,
  centro_id_centro   NUMBER NOT NULL,
  CONSTRAINT pk_ubicacion PRIMARY KEY (escuela_id_escuela, centro_id_centro),
  CONSTRAINT fk_ub_esc FOREIGN KEY (escuela_id_escuela) REFERENCES ESCUELA(id_escuela),
  CONSTRAINT fk_ub_cen FOREIGN KEY (centro_id_centro)   REFERENCES CENTRO(id_centro)
);

-- REGISTRO
CREATE TABLE REGISTRO (
  id_registro                           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ubicacion_escuela_id_escuela          NUMBER        NOT NULL,
  ubicacion_centro_id_centro            NUMBER        NOT NULL,
  municipio_id_municipio                NUMBER        NOT NULL,
  municipio_departamento_id_departamento NUMBER       NOT NULL,
  fecha                                 DATE          NOT NULL,
  tipo_tramite                          VARCHAR2(100) NOT NULL,
  tipo_licencia                         CHAR(1)       NOT NULL,
  nombre_completo                       VARCHAR2(200) NOT NULL,
  genero                                CHAR(1)       NOT NULL CHECK (genero IN ('M','F')),
  CONSTRAINT fk_reg_ub  FOREIGN KEY (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro)
    REFERENCES UBICACION(escuela_id_escuela, centro_id_centro),
  CONSTRAINT fk_reg_mun FOREIGN KEY (municipio_id_municipio)
    REFERENCES MUNICIPIO(id_municipio)
);

-- CORRELATIVO
CREATE TABLE CORRELATIVO (
  id_correlativo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fecha          DATE   NOT NULL,
  no_examen      NUMBER NOT NULL UNIQUE
);

-- EXAMEN
CREATE TABLE EXAMEN (
  id_examen                              NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  registro_id_registro                   NUMBER NOT NULL,
  correlativo_id_correlativo             NUMBER NOT NULL,
  registro_id_escuela                    NUMBER NOT NULL,
  registro_id_centro                     NUMBER NOT NULL,
  registro_municipio_id_municipio        NUMBER NOT NULL,
  registro_municipio_departamento_id_departamento NUMBER NOT NULL,
  CONSTRAINT fk_ex_reg FOREIGN KEY (registro_id_registro) REFERENCES REGISTRO(id_registro),
  CONSTRAINT fk_ex_cor FOREIGN KEY (correlativo_id_correlativo) REFERENCES CORRELATIVO(id_correlativo)
);

-- PREGUNTAS (teóricas)
CREATE TABLE PREGUNTAS (
  id_pregunta       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_texto    VARCHAR2(500) NOT NULL,
  respuesta_a       VARCHAR2(200) NOT NULL,
  respuesta_b       VARCHAR2(200) NOT NULL,
  respuesta_c       VARCHAR2(200) NOT NULL,
  respuesta_d       VARCHAR2(200) NOT NULL,
  respuesta_correcta CHAR(1)     NOT NULL CHECK (respuesta_correcta IN ('A','B','C','D'))
);

-- PREGUNTAS_PRACTICO
CREATE TABLE PREGUNTAS_PRACTICO (
  id_pregunta_practico NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_texto       VARCHAR2(500) NOT NULL,
  punteo               NUMBER(5,2)   NOT NULL
);

-- RESPUESTA_USUARIO
CREATE TABLE RESPUESTA_USUARIO (
  id_respuesta_usuario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_id_pregunta NUMBER NOT NULL,
  examen_id_examen     NUMBER NOT NULL,
  respuesta            CHAR(1) NOT NULL CHECK (respuesta IN ('A','B','C','D')),
  CONSTRAINT fk_ru_preg FOREIGN KEY (pregunta_id_pregunta) REFERENCES PREGUNTAS(id_pregunta),
  CONSTRAINT fk_ru_exam FOREIGN KEY (examen_id_examen)     REFERENCES EXAMEN(id_examen)
);

-- RESPUESTA_PRACTICO_USUARIO
CREATE TABLE RESPUESTA_PRACTICO_USUARIO (
  id_respuesta_practico_usuario NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_practico_id_pregunta_practico NUMBER NOT NULL,
  examen_id_examen                       NUMBER NOT NULL,
  nota                                   NUMBER(5,2) NOT NULL,
  CONSTRAINT fk_rpu_preg FOREIGN KEY (pregunta_practico_id_pregunta_practico)
    REFERENCES PREGUNTAS_PRACTICO(id_pregunta_practico),
  CONSTRAINT fk_rpu_exam FOREIGN KEY (examen_id_examen) REFERENCES EXAMEN(id_examen)
);

COMMIT;
/
```

## Paso 1.6 — Crear el script DML (02_dml.sql)

Crea `oracle-db/init-scripts/02_dml.sql`:

```sql
-- ============================================
-- DML - Datos de Prueba
-- Centros de Evaluación de Manejo
-- ============================================

-- DEPARTAMENTOS
INSERT INTO DEPARTAMENTO (nombre, codigo) VALUES ('Guatemala', '01');
INSERT INTO DEPARTAMENTO (nombre, codigo) VALUES ('Sacatepéquez', '03');
INSERT INTO DEPARTAMENTO (nombre, codigo) VALUES ('Escuintla', '05');

-- MUNICIPIOS
INSERT INTO MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Guatemala', '01', 1);
INSERT INTO MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Mixco', '02', 1);
INSERT INTO MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Villa Nueva', '03', 1);
INSERT INTO MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Escuintla', '01', 3);
INSERT INTO MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Antigua Guatemala', '01', 2);

-- CENTROS
INSERT INTO CENTRO (nombre) VALUES ('Centro de Evaluación Zona 12');
INSERT INTO CENTRO (nombre) VALUES ('Centro de Evaluación Antigua Guatemala');
INSERT INTO CENTRO (nombre) VALUES ('Centro de Evaluación Escuintla');

-- ESCUELAS
INSERT INTO ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Escuela de Manejo AutoMaster', 'Avenida Reforma 15-45, Zona 10', 'ESC-AM-001');
INSERT INTO ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Academia Vial GuateDrive', 'Boulevard Los Próceres 18-20, Zona 10', 'ESC-GD-002');
INSERT INTO ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Instituto de Conducción Segura', 'Calzada Roosevelt 25-30, Zona 11', 'ESC-ICS-003');

-- UBICACIONES
INSERT INTO UBICACION VALUES (1, 1);
INSERT INTO UBICACION VALUES (1, 2);
INSERT INTO UBICACION VALUES (2, 1);
INSERT INTO UBICACION VALUES (3, 2);
INSERT INTO UBICACION VALUES (3, 3);

-- REGISTROS
INSERT INTO REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (1, 1, 1, 1, DATE '2025-01-15', 'Licencia de Conducir', 'A', 'Juan Carlos López García', 'M');

INSERT INTO REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (1, 2, 2, 1, DATE '2025-01-15', 'Licencia de Conducir', 'B', 'María Elena Rodríguez Morales', 'F');

INSERT INTO REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (2, 1, 3, 1, DATE '2025-01-16', 'Licencia de Conducir', 'A', 'Carlos Alberto Méndez Castillo', 'M');

INSERT INTO REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (3, 3, 4, 3, DATE '2025-01-17', 'Licencia de Conducir', 'A', 'Ana Sofía Guerrero Díaz', 'F');

INSERT INTO REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (2, 2, 5, 2, DATE '2025-01-18', 'Licencia de Conducir', 'B', 'Pedro José Hernández Ruiz', 'M');

-- CORRELATIVOS
INSERT INTO CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-15', 1);
INSERT INTO CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-15', 2);
INSERT INTO CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-16', 3);
INSERT INTO CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-17', 4);
INSERT INTO CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-18', 5);

-- EXAMENES
INSERT INTO EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro, registro_municipio_id_municipio,
  registro_municipio_departamento_id_departamento)
VALUES (1, 1, 1, 1, 1, 1);

INSERT INTO EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro, registro_municipio_id_municipio,
  registro_municipio_departamento_id_departamento)
VALUES (2, 2, 1, 2, 2, 1);

INSERT INTO EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro, registro_municipio_id_municipio,
  registro_municipio_departamento_id_departamento)
VALUES (3, 3, 2, 1, 3, 1);

INSERT INTO EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro, registro_municipio_id_municipio,
  registro_municipio_departamento_id_departamento)
VALUES (4, 4, 3, 3, 4, 3);

INSERT INTO EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro, registro_municipio_id_municipio,
  registro_municipio_departamento_id_departamento)
VALUES (5, 5, 2, 2, 5, 2);

-- PREGUNTAS TEÓRICAS
INSERT INTO PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Cuál es la distancia mínima que debe mantener entre vehículos en carretera?',
  '2 metros', '3 segundos de distancia', '5 metros', '1 segundo de distancia', 'B');

INSERT INTO PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Qué significa una señal de alto?',
  'Reducir velocidad', 'Detenerse completamente', 'Ceder el paso', 'Continuar con precaución', 'B');

INSERT INTO PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Cuál es el límite de velocidad en zona escolar?',
  '20 km/h', '30 km/h', '40 km/h', '50 km/h', 'A');

INSERT INTO PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Qué debe hacer al ver una ambulancia con sirena activada?',
  'Mantener velocidad', 'Acelerar para salir del camino', 'Orillarse y detenerse', 'Ignorar la sirena', 'C');

-- PREGUNTAS PRÁCTICAS
INSERT INTO PREGUNTAS_PRACTICO (pregunta_texto, punteo)
VALUES ('Realizar estacionamiento en paralelo en un espacio de 6 metros', 20);

INSERT INTO PREGUNTAS_PRACTICO (pregunta_texto, punteo)
VALUES ('Conducir en reversa por 50 metros manteniendo trayectoria recta', 15);

INSERT INTO PREGUNTAS_PRACTICO (pregunta_texto, punteo)
VALUES ('Maniobra de tres puntos en espacio reducido', 25);

INSERT INTO PREGUNTAS_PRACTICO (pregunta_texto, punteo)
VALUES ('Conducción en zona urbana respetando señales de tránsito', 30);

-- RESPUESTAS DE USUARIOS (teóricas)
INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (1, 1, 'B');
INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (2, 1, 'B');
INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (3, 2, 'A');
INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (4, 2, 'C');
INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (1, 3, 'B');
INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (2, 3, 'A');

-- RESPUESTAS PRÁCTICAS
INSERT INTO RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (1, 1, 18);
INSERT INTO RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (2, 1, 13);
INSERT INTO RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (3, 2, 22);
INSERT INTO RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (4, 2, 28);
INSERT INTO RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (1, 3, 15);

COMMIT;
/
```

## Paso 1.7 — Levantar el contenedor

```bash
# Desde la raíz del proyecto:
docker compose-up -d

# Ver si está corriendo:
docker ps

# Ver los logs (Oracle tarda ~2 minutos en iniciar):
docker logs -f oracle-xe-evaluacion
```

> 💡 La primera vez Docker descarga la imagen de Oracle (~2 GB). Esto puede tardar varios minutos según tu internet.

**¿Cómo saber que Oracle está listo?**
Busca en los logs la frase:
```
DATABASE IS READY TO USE!
```

---

# FASE 2 — Conexión con DBeaver

## Paso 2.1 — Crear conexión en DBeaver

1. Abre DBeaver
2. Clic en el ícono de "Nueva Conexión" (enchufe con +)
3. Selecciona **Oracle** → Siguiente
4. Completa los campos:
   - **Host:** localhost
   - **Port:** 1521
   - **Database (Service Name):** XEPDB1
   - **Username:** EVALUACION
   - **Password:** (la que pusiste en .env)
5. Clic en **Test Connection** — debe decir "Connected" ✅
6. Clic en **Finish**

## Paso 2.2 — Verificar tablas

En el panel izquierdo de DBeaver:
- Expande: **XEPDB1** → **Schemas** → **EVALUACION** → **Tables**
- Deberías ver todas las 12 tablas creadas por el DDL

## Paso 2.3 — Ver datos

- Haz clic derecho en una tabla → "Read Data"
- Verifica que los datos del DML se insertan

---

# FASE 3 — Backend Node.js/Express

## Conceptos antes de empezar

### ¿Qué es Node.js?
JavaScript normalmente corre en el navegador. Node.js te permite correr JavaScript en tu computadora como un programa normal. Es lo que usaremos para hacer el servidor.

### ¿Qué es Express?
Es una librería que hace muy fácil crear un servidor web en Node.js. Sin Express, tendrías que escribir muchísimo código. Con Express, crear una ruta es simple.

### ¿Qué es una API REST?
Es un servidor que escucha peticiones HTTP (como las que hace un navegador) y responde con datos en formato JSON. Por ejemplo:
- Tu programa hace: `GET http://localhost:3000/api/departamentos`
- El servidor responde: `[{"id": 1, "nombre": "Guatemala"}, ...]`

## Paso 3.1 — Inicializar el proyecto Node.js

```bash
# Desde la raíz del proyecto, crea la carpeta src:
mkdir src
mkdir src/config
mkdir src/routes

# Inicializa npm (crea package.json):
npm init -y

# Instala las dependencias:
npm install express oracledb dotenv

# Instala nodemon para desarrollo (reinicia el servidor al guardar):
npm install --save-dev nodemon
```

Edita `package.json` y agrega en `"scripts"`:
```json
"scripts": {
  "start": "node src/app.js",
  "dev": "nodemon src/app.js"
}
```

## Paso 3.2 — Crear db.js (conexión a Oracle)

Crea `src/config/db.js`:

```javascript
const oracledb = require('oracledb');
require('dotenv').config();

// Modo thick: necesario para Oracle XE en contenedores
// oracledb.initOracleClient(); // Descomenta si tienes Oracle Client instalado

async function getConnection() {
  try {
    const connection = await oracledb.getConnection({
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING
    });
    return connection;
  } catch (err) {
    console.error('Error de conexión a Oracle:', err);
    throw err;
  }
}

module.exports = { getConnection };
```

## Paso 3.3 — Crear app.js (servidor principal)

Crea `src/app.js`:

```javascript
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
```

## Paso 3.4 — Crear una ruta CRUD (ejemplo: departamento.js)

Crea `src/routes/departamento.js`:

```javascript
const express = require('express');
const router = express.Router();
const oracledb = require('oracledb');
const { getConnection } = require('../config/db');

// Configurar salida como objetos JavaScript
oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

// GET /api/departamentos — Obtener todos
router.get('/', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute('SELECT * FROM DEPARTAMENTO ORDER BY id_departamento');
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// GET /api/departamentos/:id — Obtener uno por ID
router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(
      'SELECT * FROM DEPARTAMENTO WHERE id_departamento = :id',
      { id: parseInt(req.params.id) }
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Departamento no encontrado' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// POST /api/departamentos — Crear nuevo
router.post('/', async (req, res) => {
  let conn;
  const { nombre, codigo } = req.body;
  if (!nombre || !codigo) {
    return res.status(400).json({ error: 'nombre y codigo son requeridos' });
  }
  try {
    conn = await getConnection();
    const result = await conn.execute(
      'INSERT INTO DEPARTAMENTO (nombre, codigo) VALUES (:nombre, :codigo) RETURNING id_departamento INTO :id',
      { nombre, codigo, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ 
      id_departamento: result.outBinds.id[0],
      nombre, 
      codigo 
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// PUT /api/departamentos/:id — Actualizar
router.put('/:id', async (req, res) => {
  let conn;
  const { nombre, codigo } = req.body;
  try {
    conn = await getConnection();
    const result = await conn.execute(
      'UPDATE DEPARTAMENTO SET nombre = :nombre, codigo = :codigo WHERE id_departamento = :id',
      { nombre, codigo, id: parseInt(req.params.id) },
      { autoCommit: true }
    );
    if (result.rowsAffected === 0) {
      return res.status(404).json({ error: 'Departamento no encontrado' });
    }
    res.json({ message: 'Departamento actualizado correctamente' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// DELETE /api/departamentos/:id — Eliminar
router.delete('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(
      'DELETE FROM DEPARTAMENTO WHERE id_departamento = :id',
      { id: parseInt(req.params.id) },
      { autoCommit: true }
    );
    if (result.rowsAffected === 0) {
      return res.status(404).json({ error: 'Departamento no encontrado' });
    }
    res.json({ message: 'Departamento eliminado correctamente' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

module.exports = router;
```

> 💡 **Repite este patrón para cada tabla.** Solo cambia el nombre de la tabla, los campos del INSERT/UPDATE y los binds.

## Paso 3.5 — Probar el servidor

```bash
# Inicia el servidor en modo desarrollo:
npm run dev

# En otra terminal, prueba con curl:
curl http://localhost:3000/api/departamentos
```

---

# FASE 4 — Consultas Estadísticas

## Crear src/routes/estadisticas.js

```javascript
const express = require('express');
const router = express.Router();
const oracledb = require('oracledb');
const { getConnection } = require('../config/db');

oracledb.outFormat = oracledb.OUT_FORMAT_OBJECT;

// =============================================
// CONSULTA 1: Estadísticas por centro y escuela
// =============================================
router.get('/por-centro', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(`
      SELECT 
        c.nombre AS CENTRO,
        e.nombre AS ESCUELA,
        COUNT(DISTINCT ex.id_examen) AS TOTAL_EXAMENES,
        ROUND(
          AVG(
            CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END
          ) * 100, 2
        ) AS PROMEDIO_TEORICO,
        ROUND(
          AVG(rpu.nota), 2
        ) AS PROMEDIO_PRACTICO,
        COUNT(DISTINCT 
          CASE WHEN (
            (SELECT COUNT(*) FROM RESPUESTA_USUARIO ru2 
             WHERE ru2.examen_id_examen = ex.id_examen
             AND ru2.respuesta = (
               SELECT p2.respuesta_correcta FROM PREGUNTAS p2 
               WHERE p2.id_pregunta = ru2.pregunta_id_pregunta
             )) * 100.0 /
            NULLIF((SELECT COUNT(*) FROM RESPUESTA_USUARIO ru3 
                    WHERE ru3.examen_id_examen = ex.id_examen), 0)
          ) >= 60 THEN ex.id_examen END
        ) AS APROBADOS
      FROM EXAMEN ex
      JOIN CENTRO c ON ex.registro_id_centro = c.id_centro
      JOIN ESCUELA e ON ex.registro_id_escuela = e.id_escuela
      LEFT JOIN RESPUESTA_USUARIO ru ON ru.examen_id_examen = ex.id_examen
      LEFT JOIN PREGUNTAS p ON p.id_pregunta = ru.pregunta_id_pregunta
      LEFT JOIN RESPUESTA_PRACTICO_USUARIO rpu ON rpu.examen_id_examen = ex.id_examen
      GROUP BY c.nombre, e.nombre
      ORDER BY c.nombre, e.nombre
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// =============================================
// CONSULTA 2: Ranking de evaluados por resultado
// =============================================
router.get('/ranking', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(`
      SELECT 
        RANK() OVER (ORDER BY (puntaje_teorico + puntaje_practico) DESC) AS RANKING,
        nombre_completo,
        ROUND(puntaje_teorico, 2) AS PUNTAJE_TEORICO,
        ROUND(puntaje_practico, 2) AS PUNTAJE_PRACTICO,
        ROUND(puntaje_teorico + puntaje_practico, 2) AS PUNTAJE_TOTAL,
        CASE WHEN (puntaje_teorico + puntaje_practico) >= 60 THEN 'APROBADO' ELSE 'REPROBADO' END AS RESULTADO
      FROM (
        SELECT 
          r.nombre_completo,
          NVL(
            (SELECT COUNT(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 END) * 100.0 / 
                    NULLIF(COUNT(*), 0)
             FROM RESPUESTA_USUARIO ru
             JOIN PREGUNTAS p ON p.id_pregunta = ru.pregunta_id_pregunta
             WHERE ru.examen_id_examen = ex.id_examen), 0
          ) AS puntaje_teorico,
          NVL(
            (SELECT SUM(rpu.nota)
             FROM RESPUESTA_PRACTICO_USUARIO rpu
             WHERE rpu.examen_id_examen = ex.id_examen), 0
          ) AS puntaje_practico
        FROM REGISTRO r
        JOIN EXAMEN ex ON ex.registro_id_registro = r.id_registro
      )
      ORDER BY RANKING
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

// =============================================
// CONSULTA 3: Pregunta con menor aciertos
// =============================================
router.get('/pregunta-menor-aciertos', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const result = await conn.execute(`
      SELECT *
      FROM (
        SELECT 
          p.id_pregunta,
          p.pregunta_texto,
          COUNT(*) AS TOTAL_RESPUESTAS,
          SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) AS ACIERTOS,
          ROUND(
            SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
            2
          ) AS PORCENTAJE_ACIERTOS,
          p.respuesta_correcta
        FROM PREGUNTAS p
        JOIN RESPUESTA_USUARIO ru ON ru.pregunta_id_pregunta = p.id_pregunta
        GROUP BY p.id_pregunta, p.pregunta_texto, p.respuesta_correcta
        ORDER BY PORCENTAJE_ACIERTOS ASC
      )
      WHERE ROWNUM = 1
    `);
    res.json(result.rows[0] || { message: 'Sin datos suficientes' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  } finally {
    if (conn) await conn.close();
  }
});

module.exports = router;
```

---

# FASE 5 — Postman

## Paso 5.1 — Crear colección

1. Abre Postman
2. Clic en **"New"** → **"Collection"**
3. Nómbrala: `SBD1 - Centros de Evaluación`

## Paso 5.2 — Agregar peticiones

Para cada tabla, crea una carpeta y agrega las 5 peticiones:

**Ejemplo para Departamentos:**
- `GET http://localhost:3000/api/departamentos`
- `GET http://localhost:3000/api/departamentos/1`
- `POST http://localhost:3000/api/departamentos`  
  Body (JSON): `{"nombre": "Quetzaltenango", "codigo": "09"}`
- `PUT http://localhost:3000/api/departamentos/1`  
  Body (JSON): `{"nombre": "Guatemala Actualizado", "codigo": "01"}`
- `DELETE http://localhost:3000/api/departamentos/6`

## Paso 5.3 — Exportar colección

1. Clic derecho en la colección → **"Export"**
2. Selecciona **Collection v2.1**
3. Guarda el archivo como `postman/SBD1_Evaluacion.postman_collection.json`
4. Este archivo va en tu repositorio GitHub

---

# FASE 6 — README

El archivo `README.md` es lo primero que ve el tutor al entrar a tu GitHub.

Ve el archivo `MANUAL.md` del proyecto para la estructura detallada con los espacios para capturas de pantalla.

---

# Comandos útiles de Docker

```bash
# Levantar todos los servicios
docker compose up -d

# Ver estado de los contenedores
docker ps

# Ver logs de Oracle
docker logs -f oracle-xe-evaluacion

# Detener los servicios
docker compose down

# Detener y eliminar volúmenes (¡borra la BD!)
docker compose down -v

# Reiniciar solo un servicio
docker compose restart oracle-db
```

# Comandos útiles de Node.js

```bash
# Iniciar en producción
npm start

# Iniciar en desarrollo (reinicia al guardar)
npm run dev

# Instalar una dependencia
npm install nombre-paquete

# Ver dependencias instaladas
npm list
```

# Errores frecuentes y cómo resolverlos

## Oracle no inicia
```bash
# Ver los logs detallados:
docker logs oracle-xe-evaluacion

# Si hay error de permisos en Windows, ejecuta Docker Desktop como administrador
```

## Error ORA-01017 (credenciales incorrectas)
- Oracle guarda usuarios en MAYÚSCULAS: `EVALUACION`, no `evaluacion`
- Verifica tu `.env` y que la contraseña cumpla requisitos de Oracle

## La API no conecta a Oracle
- Verifica que Oracle esté corriendo: `docker ps`
- El `connectString` en `.env` debe ser `localhost:1521/XEPDB1` (no `oracle-db` cuando corres Node.js local)
- Si corres Node.js también en Docker, entonces sí usar `oracle-db:1521/XEPDB1`

## NJS-006 o errores de binding
- Asegúrate de pasar los parámetros como objeto: `{ id: value }` no solo `[value]`
- Para números, usa `parseInt()` antes de bindear

---

# Glosario

| Término | Significado |
|---------|-------------|
| Contenedor | Caja aislada donde corre software |
| Imagen Docker | Plantilla para crear contenedores |
| Volumen | Carpeta persistente en Docker |
| API REST | Servidor que responde peticiones HTTP con JSON |
| Endpoint | Una URL específica de la API (ej: `/api/departamentos`) |
| CRUD | Create, Read, Update, Delete |
| JSON | Formato de datos: `{"clave": "valor"}` |
| Driver | Librería que permite conectar a una BD específica |
| Middleware | Función que se ejecuta entre la petición y la respuesta |
| dotenv | Librería que carga variables del archivo `.env` |
| Bind | Pasar parámetros seguros a una consulta SQL |