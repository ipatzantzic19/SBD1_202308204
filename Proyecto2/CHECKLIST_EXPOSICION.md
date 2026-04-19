# 📋 Checklist de Exposición y Entrega

**Proyecto:** Centros de Evaluación de Manejo — SBD1 USAC 2026  
**Fecha de Exposición:** 2 - 3 de mayo, 2026  
**Carnet:** 202308204

---

## 🎯 Preparación (48 horas antes)

### Verificaciones Técnicas

- [ ] **Docker corriendo sin errores**
  ```bash
  docker compose up -d
  docker logs -f oracle-xe-evaluacion
  # Debe mostrar: DATABASE IS READY TO USE!
  ```

- [ ] **DBeaver conectado a Oracle**
  - [ ] Localhost:1521
  - [ ] Usuario: EVALUACION
  - [ ] BD: XEPDB1
  - [ ] Ver las 12 tablas
  - [ ] Ver datos en cada tabla

- [ ] **API funcionando en Puerto 3000**
  ```bash
  npm install
  npm start
  # Testing: curl http://localhost:3000/
  ```

- [ ] **Postman con colección lista**
  - [ ] Abrir Postman
  - [ ] Importar: postman/SBD1_Evaluacion.postman_collection.json
  - [ ] Configurar variable: base_url = http://localhost:3000
  - [ ] Probar 5 requests (GET, POST, PUT, DELETE, Consulta)

- [ ] **Repositorio en GitHub**
  - [ ] Nombre: SBD1B_1S2026_202308204 (tu carnet)
  - [ ] Privado
  - [ ] Tutor agregado como colaborador (parguet o Tefy1317)
  - [ ] Commits visibles

- [ ] **Cámara y Micrófono Funcionando**
  - [ ] Prueba de audio: habla con claridad
  - [ ] Prueba de video: imagen clara
  - [ ] Iluminación: cara visible
  - [ ] Fondo: ordenado, sin distracciones

---

### Documentación Preparada

- [ ] **README.md actualizado**
  - [ ] Todos los pasos 1-6 claros
  - [ ] Imágenes insertadas (13 capturas)
  - [ ] Comandos útiles funcionales
  - [ ] Penalizaciones claras

- [ ] **ENTREGABLES_VERIFICACION.md**
  - [ ] Todos los requisitos checados
  - [ ] Estado claro: qué está 100% y qué falta

- [ ] **Document/PREGUNTAS_TEORICAS.md**
  - [ ] Leído y entendido las 10 preguntas
  - [ ] Práctica: responder cada pregunta en <2 min

- [ ] **Document/MODELO_RELACIONAL_REFERENCIA.md**
  - [ ] Entender las 12 tablas
  - [ ] Entender las 15 relaciones
  - [ ] Poder dibujar en papel el modelo ER

- [ ] **postman/SBD1_Evaluacion.postman_collection.json**
  - [ ] Todos los 47 endpoints listos
  - [ ] Ejemplos de body correctos
  - [ ] Respuestas esperadas documentadas

---

## 📚 Documentación de Referencia

### Archivos a Tener Visibles en Exposición

1. **README.md** — Abrirlo en navegador o editor
2. **Proyecto en Volúmenes (Editor)**
   - src/app.js
   - src/routes/*.js (si están implementadas)
   - oracle-db/init-scripts/01_ddl.sql

3. **DBeaver** — Mostrar:
   - Conexión a XEPDB1
   - Las 12 tablas
   - Datos en 3 tablas (Departamento, Registro, Examen)

4. **Postman** — Mostrar:
   - Colección cargada
   - 5 requests (CRUD + Consulta)
   - Respuestas exitosas

5. **Docker Desktop** — Mostrar:
   - Contenedor "oracle-xe-evaluacion" en Running
   - Volúmenes configurados

---

## 🎤 Sesión de Exposición (1 hora máximo)

### Estructura de la Exposición

**Momento 1: Presentación (5 min)**
- [ ] Introduce al tutor
- [ ] Presenta el proyecto: "Sistema de Centros de Evaluación de Manejo"
- [ ] Repasa el objetivo SMART (dockerizar, API, Postman)

**Momento 2: Demostración Técnica (20 min)**
- [ ] Muestra Docker corriendo
  - `docker ps` — contenedor activo
  - `docker logs` — últimas líneas OK
  
- [ ] Muestra DBeaver conectado
  - Tablas del modelo (12 total)
  - Datos en 3 tablas
  
- [ ] Muestra API en Postman
  - GET: Listar departamentos (200 OK)
  - POST: Crear departamento (201 Created)
  - PUT: Actualizar (200 OK)
  - DELETE: Eliminar (200 OK)
  - Consultas estadísticas (3 ejemplos)

- [ ] Navega código
  - Abre app.js
  - Muestra una ruta CRUD simple
  - Explica la conexión a BD

**Momento 3: Preguntas Teóricas (20 min)**
- [ ] Responde 5-8 preguntas elegidas por el tutor
  - Puedo responder sin miedo porque he leído PREGUNTAS_TEORICAS.md
  - Si no sé,admito y profundizo en lo que sí sé

**Momento 4: Verificación de Requisitos (10-15 min)**
- [ ] Verifica:
  - ✅ Docker levantado → No da -30%
  - ✅ Datos en BD → Integridad OK
  - ✅ API funcionando → Endpoints responden
  - ✅ Repo en GitHub → Se ve commits
  - ✅ Cámara/Micrófono activos → Comunicación bilateral

---

## 💬 Respuestas que DEBO Saber

### Top 5 Preguntas Constantes

**P1: "¿Por qué uso Docker?"**
```
✅ Respuesta:
   - Portabilidad: Funciona en cualquier máquina
   - Reproducibilidad: Mismo estado siempre
   - Aislamiento: No interfiere con sistemas
   - Fácil de escalar: Múltiples instancias
```

**P2: "¿Cómo se conecta tu API a Oracle?"**
```
✅ Respuesta:
   - Uso driver oracledb
   - Credenciales en .env (no en código)
   - Connection string: localhost:1521/XEPDB1
   - Cada request obtiene conexión del pool
```

**P3: "¿Cuántas tablas tienes y por qué?"**
```
✅ Respuesta:
   - 12 tablas
   - Modelo 3NF (Tercera Forma Normal)
   - Entidades: DEPARTAMENTO, MUNICIPIO, CENTRO, ESCUELA, UBICACION
   - Transacciones: REGISTRO, EXAMEN, CORRELATIVO
   - Datos: PREGUNTAS, RESPUESTAS
```

**P4: "¿Cuál es la relación M:M en tu modelo?"**
```
✅ Respuesta:
   - ESCUELA ↔ CENTRO vía UBICACION
   - Una escuela en múltiples centros
   - Un centro con múltiples escuelas
   - Tabla intermedia (UBICACION) con dos FKs
```

**P5: "¿Cuáles son las tres consultas estadísticas?"**
```
✅ Respuesta:
   1. Estadísticas por Centro
      - Total exámenes, promedios, aprobados
   2. Ranking de Evaluados
      - Top de personas por puntaje total
   3. Pregunta con Menor Aciertos
      - Identifica la pregunta más difícil
```

---

## 📸 Pantallazos que Debo Mostrar

### Orden Recomendado (Si el tutor lo pide)

1. **Docker Desktop corriendo** (desktop)
   - Mostrar contenedor en estado Running
   - Volumen oracle-data visible

2. **Terminal: docker logs** (editor)
   ```bash
   docker logs -f oracle-xe-evaluacion
   # Mostrar últimas líneas: DATABASE IS READY
   ```

3. **DBeaver conectado** (software)
   - Navegador izquierda: 12 tablas listadas
   - Doble-clic en DEPARTAMENTO: datos (3 filas)
   - Doble-clic en REGISTRO: datos (5 filas)

4. **API corriendo** (terminal)
   ```bash
   npm start
   # Mostrar: Listening on port 3000
   # curl http://localhost:3000
   ```

5. **Postman**: 5 requests
   - GET /api/departamentos → 3 registros
   - POST /api/departamentos → 201
   - PUT /api/departamentos/1 → 200
   - DELETE → 200
   - GET /api/estadisticas/por-centro → datos

6. **Código**: Show en editor
   - app.js: estructura principal
   - config/db.js: configuración
   - routes/*.js: lógica CRUD

---

## 🚨 Signals de Alerta (Para No Perder Puntos)

### Errores CRÍTICOS a Evitar

| Error | Penalización | Solución |
|-------|------------|----------|
| Docker no levanta | -30% | Verifica: ORACLE_PWD > 8 chars, 1 mayús, 1 mins, 1 número |
| BD diferente a Oracle | -50% | Asegurate: usuario EVALUACION, BD XEPDB1 |
| Cámara/Micrófono apagados | -30% | Prueba antes: settings → audio/video |
| No saber explicar código | -30% | Lee el código antes, practica |
| Documentación plagiada | -20% | Revisa: son tus palabras, no copy-paste |
| Entrega después del 30/04 | -100% | Entrega HOY mismo en GitHub |

---

## ✍️ Notas Personales (Llena esto ahora)

**Datos del Estudiante:**
- Mi Carnet: `202308204`
- Mi Nombre Completo: `________________________________`
- Mi Auxiliar: `parguet` o `Tefy1317`
- Mi Email Uadi: `________________________________`

**Mi Repositorio:**
- URL: `https://github.com/[MI_USUARIO]/SBD1B_1S2026_202308204`
- Branch: `main`
- Colaborador Agregado: ✅

**Mi Estado Actual:**
- Docker levantado: Sí / No / A veces
- DBeaver conectado: Sí / No
- API corriendo: Sí / No
- Endpoints testeados: Cantidad: ___/47
- Documentación lista: Sí / No / Parcialmente

**Mis Dudas/Notas:**
```
_________________________________________________________________

_________________________________________________________________

_________________________________________________________________
```

---

## 🏁 Momento JUSTO ANTES de la Exposición

### Checklist de Último Minuto (5 minutos antes)

- [ ] Docker levantado: `docker compose ps`
- [ ] Terminal 1: `npm start` → API escuchando
- [ ] Terminal 2: `docker logs oracle-xe-evaluacion` (en background)
- [ ] DBeaver: Conexión probada
- [ ] Postman: Colección abierta, base_url = http://localhost:3000
- [ ] Editor: Carpeta del proyecto abierta
- [ ] GitHub: Repo visible en navegador
- [ ] Notas físicas: 10 preguntas impresas o en otro monitor
- [ ] Cámara: "Testing... 1, 2, 3" → Micrófono OK
- [ ] Posición: Cámara a la altura de los ojos, 60 cm de distancia

### Últimas Palabras Antes de Empezar

✅ "He preparado este proyecto con dedicación"  
✅ "Entiendo cómo funciona cada parte"  
✅ "Estoy listo para responder preguntas"  
✅ "Mi código es original y mío"  

❌ "Espero que funcione"  
❌ "Lo copié porque no sabía"  
❌ "No sé qué es Docker"  

---

## 🎓 Criterios de Evaluación

### Área 1: Habilidades (40 pts)

- Docker + Persistencia (10 pts)
  - [ ] Container corriendo
  - [ ] Volumen configurado
  - [ ] Datos persisten

- DDL Automática (5 pts)
  - [ ] 12 tablas al iniciar
  - [ ] Sin intervención manual

- Código API (5 pts)
  - [ ] Buena estructura
  - [ ] Nombres descriptivos
  - [ ] Manejo de errores

- CRUD Endpoints (10 pts)
  - [ ] 12 tablas
  - [ ] GET, POST, PUT, DELETE
  - [ ] Respuestas correctas

- Preguntas Teóricas (10 pts)
  - [ ] Responde 80%+ correctamente
  - [ ] Demuestra comprensión
  - [ ] No memoriza

### Área 2: Conocimiento (60 pts)

- Consulta 1: Estadísticas (10 pts)
- Consulta 2: Ranking (10 pts)
- Consulta 3: Pregunta menor (10 pts)
- Pruebas Postman (30 pts)
  - Evidence de 15+ requests exitosos

---

## 📞 En caso de Problemas Técnicos

**Si Docker falla durante la exposición:**
```bash
# Opción 1: Reinicia
docker compose down -v
docker compose up -d
# Espera 3-5 min

# Opción 2: Muestra el código mientras carga
docker logs oracle-xe-evaluacion
# El tutor verá: contenedor iniciando normalmente
```

**Si la API no responde:**
```bash
# Verifica:
npm start
# ¿Está escuchando en puerto 3000?

# Reinicia:
# Ctrl+C → npm start
```

**Si DBeaver no conecta:**
```bash
# Verifica:
sqlplus EVALUACION/Proyecto123@localhost:1521/XEPDB1
# Si funciona en terminal, es problema de DBeaver
# Cierra/Abre conexión
```

**Último recurso:**
- Explica lo que sucede
- Muestra el código fuente
- Explica la lógica verbalmente
- Tutor lo valida igual

---

## 🎉 ¡Bienvenida la Exposición!

Recuerda:
- ✅ Eres el experto de tu proyecto
- ✅ Has preparado bien
- ✅ Conoces cada línea de código
- ✅ Comunicación clara y confiada
- ✅ Si no sabes, lo dices sin miedo

**¡Mucho éxito! 🚀**

---

**Documento Creado:** 18 de abril de 2026  
**Próxima Revisión:** La mañana de tu exposición  
**Contacto de Emergencia:** parguet o Tefy1317
