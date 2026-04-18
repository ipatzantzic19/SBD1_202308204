sleep 180 && echo "SELECT owner, COUNT(*) FROM dba_tables WHERE table_name IN ('DEPARTAMENTO') GROUP BY owner;" | docker exec -i oracle-xe-evaluacion sqlplus -s / as sysdbasleep 180 && echo "SELECT owner, COUNT(*) FROM dba_tables WHERE table_name IN ('DEPARTAMENTO') GROUP BY owner;" | docker exec -i oracle-xe-evaluacion sqlplus -s / as sysdba-- ============================================================
-- 01_ddl.sql  —  Esquema DDL completo
-- Sistema: Centros de Evaluación de Manejo — Guatemala
-- Proyecto 2 · SBD1 · USAC 1S 2026
-- ============================================================

-- Crear tablas explícitamente en el schema EVALUACION

-- ── DEPARTAMENTO ─────────────────────────────────────────────
CREATE TABLE c##EVAL.DEPARTAMENTO (
  id_departamento NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre          VARCHAR2(100)  NOT NULL,
  codigo          VARCHAR2(10)   NOT NULL UNIQUE
);

-- ── MUNICIPIO ────────────────────────────────────────────────
CREATE TABLE c##EVAL.MUNICIPIO (
  id_municipio                  NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre                        VARCHAR2(100) NOT NULL,
  codigo                        VARCHAR2(10)  NOT NULL,
  departamento_id_departamento  NUMBER        NOT NULL,
  CONSTRAINT fk_mun_dep FOREIGN KEY (departamento_id_departamento)
    REFERENCES c##EVAL.DEPARTAMENTO(id_departamento)
);

-- ── CENTRO ───────────────────────────────────────────────────
CREATE TABLE c##EVAL.CENTRO (
  id_centro NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre    VARCHAR2(200)  NOT NULL
);

-- ── ESCUELA ──────────────────────────────────────────────────
CREATE TABLE c##EVAL.ESCUELA (
  id_escuela NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre     VARCHAR2(200)  NOT NULL,
  direccion  VARCHAR2(300),
  acuerdo    VARCHAR2(50)   NOT NULL UNIQUE
);

-- ── UBICACION ────────────────────────────────────────────────
CREATE TABLE c##EVAL.UBICACION (
  escuela_id_escuela NUMBER NOT NULL,
  centro_id_centro   NUMBER NOT NULL,
  CONSTRAINT pk_ubicacion   PRIMARY KEY (escuela_id_escuela, centro_id_centro),
  CONSTRAINT fk_ub_esc      FOREIGN KEY (escuela_id_escuela) REFERENCES c##EVAL.ESCUELA(id_escuela),
  CONSTRAINT fk_ub_cen      FOREIGN KEY (centro_id_centro)   REFERENCES c##EVAL.CENTRO(id_centro)
);

-- ── REGISTRO ─────────────────────────────────────────────────
CREATE TABLE c##EVAL.REGISTRO (
  id_registro                            NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  ubicacion_escuela_id_escuela           NUMBER         NOT NULL,
  ubicacion_centro_id_centro             NUMBER         NOT NULL,
  municipio_id_municipio                 NUMBER         NOT NULL,
  municipio_departamento_id_departamento NUMBER         NOT NULL,
  fecha                                  DATE           NOT NULL,
  tipo_tramite                           VARCHAR2(100)  NOT NULL,
  tipo_licencia                          CHAR(1)        NOT NULL,
  nombre_completo                        VARCHAR2(200)  NOT NULL,
  genero                                 CHAR(1)        NOT NULL CHECK (genero IN ('M','F')),
  CONSTRAINT fk_reg_ub  FOREIGN KEY (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro)
    REFERENCES c##EVAL.UBICACION(escuela_id_escuela, centro_id_centro),
  CONSTRAINT fk_reg_mun FOREIGN KEY (municipio_id_municipio)
    REFERENCES c##EVAL.MUNICIPIO(id_municipio)
);

-- ── CORRELATIVO ──────────────────────────────────────────────
CREATE TABLE c##EVAL.CORRELATIVO (
  id_correlativo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fecha          DATE   NOT NULL,
  no_examen      NUMBER NOT NULL UNIQUE
);

-- ── EXAMEN ───────────────────────────────────────────────────
CREATE TABLE c##EVAL.EXAMEN (
  id_examen                                       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  registro_id_registro                            NUMBER NOT NULL,
  correlativo_id_correlativo                      NUMBER NOT NULL,
  registro_id_escuela                             NUMBER NOT NULL,
  registro_id_centro                              NUMBER NOT NULL,
  registro_municipio_id_municipio                 NUMBER NOT NULL,
  registro_municipio_departamento_id_departamento NUMBER NOT NULL,
  CONSTRAINT fk_ex_reg FOREIGN KEY (registro_id_registro)        REFERENCES c##EVAL.REGISTRO(id_registro),
  CONSTRAINT fk_ex_cor FOREIGN KEY (correlativo_id_correlativo)  REFERENCES c##EVAL.CORRELATIVO(id_correlativo)
);

-- ── PREGUNTAS (teóricas) ─────────────────────────────────────
CREATE TABLE c##EVAL.PREGUNTAS (
  id_pregunta        NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_texto     VARCHAR2(500)  NOT NULL,
  respuesta_a        VARCHAR2(200)  NOT NULL,
  respuesta_b        VARCHAR2(200)  NOT NULL,
  respuesta_c        VARCHAR2(200)  NOT NULL,
  respuesta_d        VARCHAR2(200)  NOT NULL,
  respuesta_correcta CHAR(1)        NOT NULL CHECK (respuesta_correcta IN ('A','B','C','D'))
);

-- ── PREGUNTAS_PRACTICO ───────────────────────────────────────
CREATE TABLE c##EVAL.PREGUNTAS_PRACTICO (
  id_pregunta_practico NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_texto       VARCHAR2(500)  NOT NULL,
  punteo               NUMBER(5,2)    NOT NULL
);

-- ── RESPUESTA_USUARIO ────────────────────────────────────────
CREATE TABLE c##EVAL.RESPUESTA_USUARIO (
  id_respuesta_usuario NUMBER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_id_pregunta NUMBER  NOT NULL,
  examen_id_examen     NUMBER  NOT NULL,
  respuesta            CHAR(1) NOT NULL CHECK (respuesta IN ('A','B','C','D')),
  CONSTRAINT fk_ru_preg FOREIGN KEY (pregunta_id_pregunta) REFERENCES c##EVAL.PREGUNTAS(id_pregunta),
  CONSTRAINT fk_ru_exam FOREIGN KEY (examen_id_examen)     REFERENCES c##EVAL.EXAMEN(id_examen)
);

-- ── RESPUESTA_PRACTICO_USUARIO ───────────────────────────────
CREATE TABLE c##EVAL.RESPUESTA_PRACTICO_USUARIO (
  id_respuesta_practico_usuario          NUMBER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pregunta_practico_id_pregunta_practico NUMBER      NOT NULL,
  examen_id_examen                       NUMBER      NOT NULL,
  nota                                   NUMBER(5,2) NOT NULL,
  CONSTRAINT fk_rpu_preg FOREIGN KEY (pregunta_practico_id_pregunta_practico)
    REFERENCES c##EVAL.PREGUNTAS_PRACTICO(id_pregunta_practico),
  CONSTRAINT fk_rpu_exam FOREIGN KEY (examen_id_examen) REFERENCES c##EVAL.EXAMEN(id_examen)
);

COMMIT;
/