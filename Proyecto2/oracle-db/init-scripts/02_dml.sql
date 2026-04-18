-- ============================================================
-- 02_dml.sql  —  Datos de prueba (DML)
-- Sistema: Centros de Evaluación de Manejo — Guatemala
-- Proyecto 2 · SBD1 · USAC 1S 2026
-- ============================================================



-- DEPARTAMENTOS
INSERT INTO c##EVAL.DEPARTAMENTO (nombre, codigo) VALUES ('Guatemala',     '01');
INSERT INTO c##EVAL.DEPARTAMENTO (nombre, codigo) VALUES ('Sacatepéquez',  '03');
INSERT INTO c##EVAL.DEPARTAMENTO (nombre, codigo) VALUES ('Escuintla',     '05');

-- MUNICIPIOS
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Guatemala',         '01', 1);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Mixco',             '02', 1);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Villa Nueva',       '03', 1);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Escuintla',         '01', 3);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Antigua Guatemala', '01', 2);

-- CENTROS
INSERT INTO c##EVAL.CENTRO (nombre) VALUES ('Centro de Evaluación Zona 12');
INSERT INTO c##EVAL.CENTRO (nombre) VALUES ('Centro de Evaluación Antigua Guatemala');
INSERT INTO c##EVAL.CENTRO (nombre) VALUES ('Centro de Evaluación Escuintla');

-- ESCUELAS
INSERT INTO c##EVAL.ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Escuela de Manejo AutoMaster',      'Avenida Reforma 15-45, Zona 10',       'ESC-AM-001');
INSERT INTO c##EVAL.ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Academia Vial GuateDrive',          'Boulevard Los Próceres 18-20, Zona 10','ESC-GD-002');
INSERT INTO c##EVAL.ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Instituto de Conducción Segura',    'Calzada Roosevelt 25-30, Zona 11',     'ESC-ICS-003');

-- UBICACIONES (escuela ↔ centro)
INSERT INTO c##EVAL.UBICACION VALUES (1, 1);
INSERT INTO c##EVAL.UBICACION VALUES (1, 2);
INSERT INTO c##EVAL.UBICACION VALUES (2, 1);
INSERT INTO c##EVAL.UBICACION VALUES (3, 2);
INSERT INTO c##EVAL.UBICACION VALUES (3, 3);

-- CORRELATIVO
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-10', 1001);
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-15', 1002);
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-20', 1003);

-- PREGUNTAS (teóricas)
INSERT INTO c##EVAL.PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
  VALUES ('¿Cuál es la velocidad máxima en zona urbana?','60 km/h','80 km/h','40 km/h','100 km/h','C');
INSERT INTO c##EVAL.PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
  VALUES ('¿Qué significa una luz roja en un semáforo?','Avanzar','Esperar','Acelerar','Frenar lentamente','B');

-- PREGUNTAS_PRACTICO
INSERT INTO c##EVAL.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES ('Estacionamiento paralelo', 25);
INSERT INTO c##EVAL.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES ('Marcha atrás en línea recta', 25);

COMMIT;
/

-- DEPARTAMENTOS
INSERT INTO c##EVAL.DEPARTAMENTO (nombre, codigo) VALUES ('Guatemala',     '01');
INSERT INTO c##EVAL.DEPARTAMENTO (nombre, codigo) VALUES ('Sacatepéquez',  '03');
INSERT INTO c##EVAL.DEPARTAMENTO (nombre, codigo) VALUES ('Escuintla',     '05');

-- MUNICIPIOS
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Guatemala',         '01', 1);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Mixco',             '02', 1);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Villa Nueva',       '03', 1);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Escuintla',         '01', 3);
INSERT INTO c##EVAL.MUNICIPIO (nombre, codigo, departamento_id_departamento) VALUES ('Antigua Guatemala', '01', 2);

-- CENTROS
INSERT INTO c##EVAL.CENTRO (nombre) VALUES ('Centro de Evaluación Zona 12');
INSERT INTO c##EVAL.CENTRO (nombre) VALUES ('Centro de Evaluación Antigua Guatemala');
INSERT INTO c##EVAL.CENTRO (nombre) VALUES ('Centro de Evaluación Escuintla');

-- ESCUELAS
INSERT INTO c##EVAL.ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Escuela de Manejo AutoMaster',      'Avenida Reforma 15-45, Zona 10',       'ESC-AM-001');
INSERT INTO c##EVAL.ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Academia Vial GuateDrive',          'Boulevard Los Próceres 18-20, Zona 10','ESC-GD-002');
INSERT INTO c##EVAL.ESCUELA (nombre, direccion, acuerdo)
  VALUES ('Instituto de Conducción Segura',    'Calzada Roosevelt 25-30, Zona 11',     'ESC-ICS-003');

-- UBICACIONES (escuela ↔ centro)
INSERT INTO c##EVAL.UBICACION VALUES (1, 1);
INSERT INTO c##EVAL.UBICACION VALUES (1, 2);
INSERT INTO c##EVAL.UBICACION VALUES (2, 1);
INSERT INTO c##EVAL.UBICACION VALUES (3, 2);
INSERT INTO c##EVAL.UBICACION VALUES (3, 3);

-- REGISTROS
INSERT INTO c##EVAL.REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (1,1,1,1, DATE '2025-01-15','Licencia de Conducir','A','Juan Carlos López García','M');

INSERT INTO c##EVAL.REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (1,2,2,1, DATE '2025-01-15','Licencia de Conducir','B','María Elena Rodríguez Morales','F');

INSERT INTO c##EVAL.REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (2,1,3,1, DATE '2025-01-16','Licencia de Conducir','A','Carlos Alberto Méndez Castillo','M');

INSERT INTO c##EVAL.REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (2,1,4,3, DATE '2025-01-17','Licencia de Conducir','A','Ana Sofía Guerrero Díaz','F');

INSERT INTO c##EVAL.REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
  municipio_id_municipio, municipio_departamento_id_departamento,
  fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
VALUES (2,1,5,2, DATE '2025-01-18','Licencia de Conducir','B','Pedro José Hernández Ruiz','M');

-- CORRELATIVOS
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-15', 1);
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-15', 2);
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-16', 3);
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-17', 4);
INSERT INTO c##EVAL.CORRELATIVO (fecha, no_examen) VALUES (DATE '2025-01-18', 5);

-- EXAMENES
INSERT INTO c##EVAL.EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro,
  registro_municipio_id_municipio, registro_municipio_departamento_id_departamento)
VALUES (1,1,1,1,1,1);

INSERT INTO c##EVAL.EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro,
  registro_municipio_id_municipio, registro_municipio_departamento_id_departamento)
VALUES (2,2,1,2,2,1);

INSERT INTO c##EVAL.EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro,
  registro_municipio_id_municipio, registro_municipio_departamento_id_departamento)
VALUES (3,3,2,1,3,1);

INSERT INTO c##EVAL.EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro,
  registro_municipio_id_municipio, registro_municipio_departamento_id_departamento)
VALUES (4,4,3,3,4,3);

INSERT INTO c##EVAL.EXAMEN (registro_id_registro, correlativo_id_correlativo,
  registro_id_escuela, registro_id_centro,
  registro_municipio_id_municipio, registro_municipio_departamento_id_departamento)
VALUES (5,5,2,2,5,2);

-- PREGUNTAS TEÓRICAS
INSERT INTO c##EVAL.PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Cuál es la distancia mínima que debe mantener entre vehículos en carretera?',
  '2 metros','3 segundos de distancia','5 metros','1 segundo de distancia','B');

INSERT INTO c##EVAL.PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Qué significa una señal de alto?',
  'Reducir velocidad','Detenerse completamente','Ceder el paso','Continuar con precaución','B');

INSERT INTO c##EVAL.PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Cuál es el límite de velocidad en zona escolar?',
  '20 km/h','30 km/h','40 km/h','50 km/h','A');

INSERT INTO c##EVAL.PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
VALUES ('¿Qué debe hacer al ver una ambulancia con sirena activada?',
  'Mantener velocidad','Acelerar para salir del camino','Orillarse y detenerse','Ignorar la sirena','C');

-- PREGUNTAS PRÁCTICAS
INSERT INTO c##EVAL.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES ('Realizar estacionamiento en paralelo en un espacio de 6 metros', 20);
INSERT INTO c##EVAL.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES ('Conducir en reversa por 50 metros manteniendo trayectoria recta', 15);
INSERT INTO c##EVAL.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES ('Maniobra de tres puntos en espacio reducido', 25);
INSERT INTO c##EVAL.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES ('Conducción en zona urbana respetando señales de tránsito', 30);

-- RESPUESTAS TEÓRICAS
INSERT INTO c##EVAL.RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (1,1,'B');
INSERT INTO c##EVAL.RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (2,1,'B');
INSERT INTO c##EVAL.RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (3,2,'A');
INSERT INTO c##EVAL.RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (4,2,'C');
INSERT INTO c##EVAL.RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (1,3,'B');
INSERT INTO c##EVAL.RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta) VALUES (2,3,'A');

-- RESPUESTAS PRÁCTICAS
INSERT INTO c##EVAL.RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (1,1,18);
INSERT INTO c##EVAL.RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (2,1,13);
INSERT INTO c##EVAL.RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (3,2,22);
INSERT INTO c##EVAL.RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (4,2,28);
INSERT INTO c##EVAL.RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota) VALUES (1,3,15);

COMMIT;
/