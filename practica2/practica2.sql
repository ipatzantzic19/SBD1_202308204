-- ============================================================
-- BASE DE DATOS 1 - PRACTICA NO. 2
-- Script de modificacion de la BD de Practica 1
-- ============================================================


-- ============================================================
-- PASO 1: ELIMINAR TABLAS DEPENDIENTES QUE YA NO EXISTEN EN EL MODELO DEL EXCEL
-- ============================================================

-- Tablas de detalle de evaluacion (reemplazadas por nuevas)
DROP TABLE EVAL_INSTR    CASCADE CONSTRAINTS;
DROP TABLE EVAL_RESP     CASCADE CONSTRAINTS;
DROP TABLE EVALUACION    CASCADE CONSTRAINTS;

-- Banco de preguntas antiguo (estructura diferente en Excel)
DROP TABLE RESPUESTA     CASCADE CONSTRAINTS;
DROP TABLE PREG_TEORICA  CASCADE CONSTRAINTS;
DROP TABLE INSTR_PRACTICA CASCADE CONSTRAINTS;

-- Persona reemplazada por REGISTRO
DROP TABLE PERSONA       CASCADE CONSTRAINTS;

-- Instructor no existe en el modelo Excel
DROP TABLE INSTRUCTOR    CASCADE CONSTRAINTS;

-- ESC_CENTRO reemplazada por UBICACION (sin columna id ni fec_registro)
DROP TABLE ESC_CENTRO    CASCADE CONSTRAINTS;


-- ============================================================
-- PASO 2: QUITAR FK QUE APUNTAN A USUARIO DESDE TABLAS
--         QUE SI SE CONSERVAN (CENTRO y ESCUELA)
--         Para poder luego eliminar USUARIO
-- ============================================================

ALTER TABLE CENTRO  DROP CONSTRAINT FK_CEN_USUARIO;
ALTER TABLE ESCUELA DROP CONSTRAINT FK_ESC_USUARIO;


-- ============================================================
-- PASO 3: ELIMINAR TABLA USUARIO
--         No existe en el modelo Excel (la auditoria de
--         usuario la maneja el sistema externo en P2)
-- ============================================================

DROP TABLE USUARIO CASCADE CONSTRAINTS;


-- ============================================================
-- PASO 4: MODIFICAR TABLA CENTRO
--         Excel solo tiene: ID_CENTRO, NOMBRE
--         Sobran: DIRECCION, FEC_CREACION, ID_USUARIO_REG
-- ============================================================

ALTER TABLE CENTRO DROP COLUMN DIRECCION;
ALTER TABLE CENTRO DROP COLUMN FEC_CREACION;
ALTER TABLE CENTRO DROP COLUMN ID_USUARIO_REG;


-- ============================================================
-- PASO 5: MODIFICAR TABLA ESCUELA
--         Excel tiene: ID_ESCUELA, NOMBRE, DIRECCION, ACUERDO
--         Cambios:
--           - num_autorizacion -> ACUERDO
--           - Quitar FEC_CREACION e ID_USUARIO_REG
--           - Quitar UNIQUE de num_autorizacion (se renombra)
-- ============================================================

ALTER TABLE ESCUELA DROP CONSTRAINT UQ_ESC_AUTORI;
ALTER TABLE ESCUELA RENAME COLUMN NUM_AUTORIZACION TO ACUERDO;
ALTER TABLE ESCUELA DROP COLUMN FEC_CREACION;
ALTER TABLE ESCUELA DROP COLUMN ID_USUARIO_REG;


-- ============================================================
-- PASO 6: RENOMBRAR TABLA DEPTO -> DEPARTAMENTO
--         Y renombrar columna id_depto -> ID_DEPARTAMENTO
--         Y agregar columna CODIGO que trae el Excel
-- ============================================================

RENAME DEPTO TO DEPARTAMENTO;
ALTER TABLE DEPARTAMENTO RENAME COLUMN ID_DEPTO TO ID_DEPARTAMENTO;
ALTER TABLE DEPARTAMENTO DROP COLUMN CALIFICACION1;
ALTER TABLE DEPARTAMENTO ADD CODIGO NUMBER(5);


-- ============================================================
-- PASO 7: MODIFICAR TABLA MUNICIPIO
--         Excel tiene: ID_MUNICIPIO, DEPARTAMENTO_ID_DEPARTAMENTO,
--                      NOMBRE, CODIGO
--         Cambios:
--           - id_depto -> DEPARTAMENTO_ID_DEPARTAMENTO
--           - Agregar columna CODIGO
--           - Recrear FK apuntando al nuevo nombre de tabla/columna
-- ============================================================

-- Quitar FK vieja (apuntaba a DEPTO que ya se llama DEPARTAMENTO)
ALTER TABLE MUNICIPIO DROP CONSTRAINT FK_MUN_DEPTO;

-- Renombrar columna FK
ALTER TABLE MUNICIPIO RENAME COLUMN ID_DEPTO TO DEPARTAMENTO_ID_DEPARTAMENTO;

-- Agregar columna nueva
ALTER TABLE MUNICIPIO ADD CODIGO NUMBER(5);

-- Recrear FK con nuevo nombre de tabla y columna
ALTER TABLE MUNICIPIO ADD CONSTRAINT FK_MUN_DEPTO
    FOREIGN KEY (DEPARTAMENTO_ID_DEPARTAMENTO)
    REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO);


-- ============================================================
-- PASO 8: CREAR TABLA PREGUNTAS
--         Reemplaza PREG_TEORICA + RESPUESTA
--         Las 4 respuestas van como columnas (res1-res4)
--         y "respuesta" indica cual de ellas es la correcta (1-4)
-- ============================================================

CREATE TABLE PREGUNTAS (
    ID              NUMBER(10)    NOT NULL,
    PREGUNTA_TEXTO  VARCHAR2(500) NOT NULL,
    RESPUESTA       NUMBER(1)     NOT NULL,   -- numero 1 a 4 de la correcta
    RES1            VARCHAR2(300) NOT NULL,
    RES2            VARCHAR2(300) NOT NULL,
    RES3            VARCHAR2(300) NOT NULL,
    RES4            VARCHAR2(300) NOT NULL,
    CONSTRAINT PK_PREGUNTAS     PRIMARY KEY (ID),
    CONSTRAINT CK_PREG_RESP     CHECK (RESPUESTA BETWEEN 1 AND 4)
);


-- ============================================================
-- PASO 9: CREAR TABLA PREGUNTAS_PRACTICO
--         Reemplaza INSTR_PRACTICA
--         Agrega columna PUNTEO (valor de cada instruccion)
-- ============================================================

CREATE TABLE PREGUNTAS_PRACTICO (
    ID_PREGUNTA_PRACTICO    NUMBER(10)    NOT NULL,
    PREGUNTA_TEXTO          VARCHAR2(300) NOT NULL,
    PUNTEO                  NUMBER(5,2)   NOT NULL,
    CONSTRAINT PK_PREG_PRACTICO PRIMARY KEY (ID_PREGUNTA_PRACTICO)
);


-- ============================================================
-- PASO 10: CREAR TABLA UBICACION
--          Reemplaza ESC_CENTRO
--          Sin id propio ni fec_registro, PK compuesta
-- ============================================================

CREATE TABLE UBICACION (
    ESCUELA_ID_ESCUELA  NUMBER(10) NOT NULL,
    CENTRO_ID_CENTRO    NUMBER(10) NOT NULL,
    CONSTRAINT PK_UBICACION     PRIMARY KEY (ESCUELA_ID_ESCUELA, CENTRO_ID_CENTRO),
    CONSTRAINT FK_UBI_ESCUELA   FOREIGN KEY (ESCUELA_ID_ESCUELA)
        REFERENCES ESCUELA (ID_ESCUELA),
    CONSTRAINT FK_UBI_CENTRO    FOREIGN KEY (CENTRO_ID_CENTRO)
        REFERENCES CENTRO  (ID_CENTRO)
);


-- ============================================================
-- PASO 11: CREAR TABLA REGISTRO
--          Reemplaza PERSONA
--          Contiene datos generales del evaluado por examen
-- ============================================================

CREATE TABLE REGISTRO (
    ID_REGISTRO                         NUMBER(10)    NOT NULL,
    UBICACION_ESCUELA_ID_ESCUELA        NUMBER(10)    NOT NULL,
    UBICACION_CENTRO_ID_CENTRO          NUMBER(10)    NOT NULL,
    MUNICIPIO_ID_MUNICIPIO              NUMBER(10)    NOT NULL,
    MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO NUMBER(10) NOT NULL,
    FECHA                               DATE          NOT NULL,
    TIPO_TRAMITE                        VARCHAR2(30)  NOT NULL,
    TIPO_LICENCIA                       VARCHAR2(5)   NOT NULL,
    NOMBRE_COMPLETO                     VARCHAR2(200) NOT NULL,
    GENERO                              CHAR(1)       NOT NULL,
    CONSTRAINT PK_REGISTRO          PRIMARY KEY (ID_REGISTRO),
    CONSTRAINT FK_REG_ESCUELA       FOREIGN KEY (UBICACION_ESCUELA_ID_ESCUELA)
        REFERENCES ESCUELA   (ID_ESCUELA),
    CONSTRAINT FK_REG_CENTRO        FOREIGN KEY (UBICACION_CENTRO_ID_CENTRO)
        REFERENCES CENTRO    (ID_CENTRO),
    CONSTRAINT FK_REG_MUNICIPIO     FOREIGN KEY (MUNICIPIO_ID_MUNICIPIO)
        REFERENCES MUNICIPIO (ID_MUNICIPIO),
    CONSTRAINT FK_REG_DEPTO         FOREIGN KEY (MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO)
        REFERENCES DEPARTAMENTO (ID_DEPARTAMENTO),
    CONSTRAINT CK_REG_GENERO        CHECK (GENERO IN ('M','F'))
);


-- ============================================================
-- PASO 12: CREAR TABLA CORRELATIVO
--          Nueva tabla - controla el correlativo diario
--          de examenes por fecha
-- ============================================================

CREATE TABLE CORRELATIVO (
    ID_CORRELATIVO  NUMBER(10) NOT NULL,
    FECHA           DATE       NOT NULL,
    NO_EXAMEN       NUMBER(5)  NOT NULL,
    CONSTRAINT PK_CORRELATIVO PRIMARY KEY (ID_CORRELATIVO)
);


-- ============================================================
-- PASO 13: CREAR TABLA EXAMEN
--          Reemplaza EVALUACION
--          Referencia a REGISTRO y CORRELATIVO
-- ============================================================

CREATE TABLE EXAMEN (
    ID_EXAMEN                                   NUMBER(10) NOT NULL,
    REGISTRO_ID_ESCUELA                         NUMBER(10) NOT NULL,
    REGISTRO_ID_CENTRO                          NUMBER(10) NOT NULL,
    REGISTRO_MUNICIPIO_ID_MUNICIPIO             NUMBER(10) NOT NULL,
    REGISTRO_MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO NUMBER(10) NOT NULL,
    REGISTRO_ID_REGISTRO                        NUMBER(10) NOT NULL,
    CORRELATIVO_ID_CORRELATIVO                  NUMBER(10) NOT NULL,
    CONSTRAINT PK_EXAMEN            PRIMARY KEY (ID_EXAMEN),
    CONSTRAINT FK_EXA_REGISTRO      FOREIGN KEY (REGISTRO_ID_REGISTRO)
        REFERENCES REGISTRO    (ID_REGISTRO),
    CONSTRAINT FK_EXA_CORRELATIVO   FOREIGN KEY (CORRELATIVO_ID_CORRELATIVO)
        REFERENCES CORRELATIVO (ID_CORRELATIVO)
);


-- ============================================================
-- PASO 14: CREAR TABLA RESPUESTA_USUARIO
--          Reemplaza EVAL_RESP
--          Guarda que numero de respuesta (1-4) eligio
--          el evaluado para cada pregunta teorica
-- ============================================================

CREATE TABLE RESPUESTA_USUARIO (
    ID_RESPUESTA_USUARIO    NUMBER(10) NOT NULL,
    PREGUNTA_ID_PREGUNTA    NUMBER(10) NOT NULL,
    EXAMEN_ID_EXAMEN        NUMBER(10) NOT NULL,
    RESPUESTA               NUMBER(1)  NOT NULL,  -- numero 1 a 4 elegido
    CONSTRAINT PK_RESP_USUARIO      PRIMARY KEY (ID_RESPUESTA_USUARIO),
    CONSTRAINT UQ_RU_PREG_EXAMEN    UNIQUE (EXAMEN_ID_EXAMEN, PREGUNTA_ID_PREGUNTA),
    CONSTRAINT FK_RU_PREGUNTA       FOREIGN KEY (PREGUNTA_ID_PREGUNTA)
        REFERENCES PREGUNTAS (ID),
    CONSTRAINT FK_RU_EXAMEN         FOREIGN KEY (EXAMEN_ID_EXAMEN)
        REFERENCES EXAMEN    (ID_EXAMEN),
    CONSTRAINT CK_RU_RESPUESTA      CHECK (RESPUESTA BETWEEN 1 AND 4)
);


-- ============================================================
-- PASO 15: CREAR TABLA RESPUESTA_PRACTICO_USUARIO
--          Reemplaza EVAL_INSTR
--          Guarda la nota obtenida por instruccion practica
-- ============================================================

CREATE TABLE RESPUESTA_PRACTICO_USUARIO (
    ID_RESPUESTA_PRACTICO               NUMBER(10)  NOT NULL,
    PREGUNTA_PRACTICO_ID_PREGUNTA_PRACTICO NUMBER(10) NOT NULL,
    EXAMEN_ID_EXAMEN                    NUMBER(10)  NOT NULL,
    NOTA                                NUMBER(5,2) NOT NULL,
    CONSTRAINT PK_RESP_PRACTICO         PRIMARY KEY (ID_RESPUESTA_PRACTICO),
    CONSTRAINT UQ_RP_PREG_EXAMEN        UNIQUE (EXAMEN_ID_EXAMEN, PREGUNTA_PRACTICO_ID_PREGUNTA_PRACTICO),
    CONSTRAINT FK_RP_PREG_PRACTICO      FOREIGN KEY (PREGUNTA_PRACTICO_ID_PREGUNTA_PRACTICO)
        REFERENCES PREGUNTAS_PRACTICO (ID_PREGUNTA_PRACTICO),
    CONSTRAINT FK_RP_EXAMEN             FOREIGN KEY (EXAMEN_ID_EXAMEN)
        REFERENCES EXAMEN (ID_EXAMEN)
);

-- ========================== * FROM practica1;==================================
-- FIN DEL SCRIPT DE MODIFICACION
-- Resultado final - 12 tablas que coinciden con el Excel:
--   Conservadas y modificadas:
--     1. DEPARTAMENTO  (era DEPTO + columna CODIGO)
--     2. MUNICIPIO     (+ columna CODIGO, FK renombrada)
--     3. CENTRO        (columnas sobrantes eliminadas)
--     4. ESCUELA       (num_autorizacion -> ACUERDO)
--   Eliminadas:
--     USUARIO, INSTRUCTOR, PERSONA, PREG_TEORICA,
--     RESPUESTA, INSTR_PRACTICA, EVALUACION,
--     EVAL_RESP, EVAL_INSTR, ESC_CENTRO
--   Creadas nuevas:
--     5.  UBICACION
--     6.  PREGUNTAS
--     7.  PREGUNTAS_PRACTICO
--     8.  REGISTRO
--     9.  CORRELATIVO
--     10. EXAMEN
--     11. RESPUESTA_USUARIO
--     12. RESPUESTA_PRACTICO_USUARIO
-- ============================================================