

-- ============================================================
-- LIMPIEZA (orden inverso a dependencias)
-- ============================================================
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EVAL_INSTR      CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EVAL_RESP       CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EVALUACION      CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE INSTR_PRACTICA  CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE RESPUESTA       CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PREG_TEORICA    CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PERSONA         CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE INSTRUCTOR      CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ESC_CENTRO      CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ESCUELA         CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CENTRO          CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MUNICIPIO       CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE DEPTO           CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE USUARIO         CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/


-- ============================================================
-- TABLA: USUARIO
-- Personal del Centro que opera el sistema (auditoria)
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE USUARIO (
    id_usuario      NUMBER(10)    NOT NULL,
    nombre          VARCHAR2(150) NOT NULL,
    identificacion  VARCHAR2(20)  NOT NULL,
    usuario_acc     VARCHAR2(50)  NOT NULL,
    fec_creacion    DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_USUARIO    PRIMARY KEY (id_usuario),
    CONSTRAINT UQ_USU_IDENT  UNIQUE      (identificacion),
    CONSTRAINT UQ_USU_ACC    UNIQUE      (usuario_acc)
);


-- ============================================================
-- TABLA: DEPTO
-- Catalogo de departamentos de Guatemala
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE DEPTO (
    id_depto    NUMBER(10)    NOT NULL,
    nombre      VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_DEPTO PRIMARY KEY (id_depto)
);


-- ============================================================
-- TABLA: MUNICIPIO
-- Municipios agrupados por departamento
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE MUNICIPIO (
    id_municipio    NUMBER(10)    NOT NULL,
    nombre          VARCHAR2(100) NOT NULL,
    id_depto        NUMBER(10)    NOT NULL,
    CONSTRAINT PK_MUNICIPIO  PRIMARY KEY (id_municipio),
    CONSTRAINT FK_MUN_DEPTO  FOREIGN KEY (id_depto)
        REFERENCES DEPTO (id_depto)
);


-- ============================================================
-- TABLA: CENTRO
-- Centros de Evaluacion de Manejo ubicados en Guatemala
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE CENTRO (
    id_centro       NUMBER(10)    NOT NULL,
    nombre          VARCHAR2(150) NOT NULL,
    direccion       VARCHAR2(250) NOT NULL,
    fec_creacion    DATE          DEFAULT SYSDATE NOT NULL,
    id_usuario_reg  NUMBER(10)    NOT NULL,
    CONSTRAINT PK_CENTRO      PRIMARY KEY (id_centro),
    CONSTRAINT FK_CEN_USUARIO FOREIGN KEY (id_usuario_reg)
        REFERENCES USUARIO (id_usuario)
);


-- ============================================================
-- TABLA: ESCUELA
-- Escuelas de Automovilismo autorizadas por Transito
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE ESCUELA (
    id_escuela          NUMBER(10)   NOT NULL,
    nombre              VARCHAR2(150) NOT NULL,
    direccion           VARCHAR2(250) NOT NULL,
    num_autorizacion    VARCHAR2(50)  NOT NULL,
    fec_creacion        DATE          DEFAULT SYSDATE NOT NULL,
    id_usuario_reg      NUMBER(10)    NOT NULL,
    CONSTRAINT PK_ESCUELA     PRIMARY KEY (id_escuela),
    CONSTRAINT UQ_ESC_AUTORI  UNIQUE      (num_autorizacion),
    CONSTRAINT FK_ESC_USUARIO FOREIGN KEY (id_usuario_reg)
        REFERENCES USUARIO (id_usuario)
);


-- ============================================================
-- TABLA: ESC_CENTRO
-- Tabla intermedia - Relacion M:N entre ESCUELA y CENTRO
-- Una escuela puede operar en muchos centros y un centro
-- puede albergar muchas escuelas
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE ESC_CENTRO (
    id_esc_centro   NUMBER(10) NOT NULL,
    id_escuela      NUMBER(10) NOT NULL,
    id_centro       NUMBER(10) NOT NULL,
    fec_registro    DATE       DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_ESC_CENTRO  PRIMARY KEY (id_esc_centro),
    CONSTRAINT UQ_EC_RELACION UNIQUE      (id_escuela, id_centro),
    CONSTRAINT FK_EC_ESCUELA  FOREIGN KEY (id_escuela)
        REFERENCES ESCUELA (id_escuela),
    CONSTRAINT FK_EC_CENTRO   FOREIGN KEY (id_centro)
        REFERENCES CENTRO  (id_centro)
);


-- ============================================================
-- TABLA: INSTRUCTOR
-- Instructores que supervisan la evaluacion practica
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE INSTRUCTOR (
    id_instructor   NUMBER(10)    NOT NULL,
    nombre          VARCHAR2(150) NOT NULL,
    identificacion  VARCHAR2(20)  NOT NULL,
    fec_creacion    DATE          DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_INSTRUCTOR PRIMARY KEY (id_instructor),
    CONSTRAINT UQ_INST_IDENT UNIQUE      (identificacion)
);


-- ============================================================
-- TABLA: PERSONA
-- Personas que solicitan evaluacion de manejo
-- Opcionales: telefono (NULL), fotografia (NULL)
-- tipo_licencia: M=Moto P=Particular B=Liviana A=Profesional E=Agricola
-- tipo_tramite:  PRIMERA_LICENCIA | CAMBIO_TIPO
-- genero:        M=Masculino | F=Femenino
-- ============================================================
CREATE TABLE PERSONA (
    id_persona      NUMBER(10)    NOT NULL,
    nombre_completo VARCHAR2(200) NOT NULL,
    direccion       VARCHAR2(250) NOT NULL,
    identificacion  VARCHAR2(20)  NOT NULL,
    telefono        VARCHAR2(15)  NULL,
    fotografia      BLOB          NULL,
    tipo_licencia   CHAR(1)       NOT NULL,
    tipo_tramite    VARCHAR2(30)  NOT NULL,
    genero          CHAR(1)       NOT NULL,
    fec_nacimiento  DATE          NOT NULL,
    id_municipio    NUMBER(10)    NOT NULL,
    id_escuela      NUMBER(10)    NOT NULL,
    fec_creacion    DATE          DEFAULT SYSDATE NOT NULL,
    id_usuario_reg  NUMBER(10)    NOT NULL,
    CONSTRAINT PK_PERSONA       PRIMARY KEY (id_persona),
    CONSTRAINT UQ_PER_IDENT     UNIQUE      (identificacion),
    CONSTRAINT FK_PER_MUNICIPIO FOREIGN KEY (id_municipio)
        REFERENCES MUNICIPIO (id_municipio),
    CONSTRAINT FK_PER_ESCUELA   FOREIGN KEY (id_escuela)
        REFERENCES ESCUELA   (id_escuela),
    CONSTRAINT FK_PER_USUARIO   FOREIGN KEY (id_usuario_reg)
        REFERENCES USUARIO   (id_usuario),
    CONSTRAINT CK_PER_LICENCIA  CHECK (tipo_licencia IN ('M','P','B','A','E')),
    CONSTRAINT CK_PER_TRAMITE   CHECK (tipo_tramite   IN ('PRIMERA_LICENCIA','CAMBIO_TIPO')),
    CONSTRAINT CK_PER_GENERO    CHECK (genero          IN ('M','F'))
);


-- ============================================================
-- TABLA: PREG_TEORICA
-- Banco de preguntas para la evaluacion teorica
-- 25 preguntas por examen
-- Opcional: imagen (la pregunta puede ser solo texto)
-- ============================================================
CREATE TABLE PREG_TEORICA (
    id_pregunta     NUMBER(10)    NOT NULL,
    texto           VARCHAR2(500) NOT NULL,
    imagen          BLOB          NULL,
    fec_creacion    DATE          DEFAULT SYSDATE NOT NULL,
    id_usuario_reg  NUMBER(10)    NOT NULL,
    CONSTRAINT PK_PREG_TEORICA PRIMARY KEY (id_pregunta),
    CONSTRAINT FK_PT_USUARIO   FOREIGN KEY (id_usuario_reg)
        REFERENCES USUARIO (id_usuario)
);


-- ============================================================
-- TABLA: RESPUESTA
-- Opciones de respuesta por pregunta (maximo 4, una correcta)
-- Opcionales: texto (NULL), imagen (NULL)
-- Al menos uno de los dos debe existir pero se valida en app
-- es_correcta: S=Si | N=No
-- ============================================================
CREATE TABLE RESPUESTA (
    id_respuesta    NUMBER(10)    NOT NULL,
    texto           VARCHAR2(500) NULL,
    imagen          BLOB          NULL,
    es_correcta     CHAR(1)       NOT NULL,
    id_pregunta     NUMBER(10)    NOT NULL,
    CONSTRAINT PK_RESPUESTA     PRIMARY KEY (id_respuesta),
    CONSTRAINT FK_RESP_PREGUNTA FOREIGN KEY (id_pregunta)
        REFERENCES PREG_TEORICA (id_pregunta),
    CONSTRAINT CK_RESP_CORRECTA CHECK (es_correcta IN ('S','N'))
);


-- ============================================================
-- TABLA: INSTR_PRACTICA
-- Banco de instrucciones para la evaluacion practica
-- 10 instrucciones por examen
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE INSTR_PRACTICA (
    id_instruccion  NUMBER(10)    NOT NULL,
    descripcion     VARCHAR2(300) NOT NULL,
    fec_creacion    DATE          DEFAULT SYSDATE NOT NULL,
    id_usuario_reg  NUMBER(10)    NOT NULL,
    CONSTRAINT PK_INSTR_PRACTICA PRIMARY KEY (id_instruccion),
    CONSTRAINT FK_IP_USUARIO     FOREIGN KEY (id_usuario_reg)
        REFERENCES USUARIO (id_usuario)
);


-- ============================================================
-- TABLA: EVALUACION
-- Registro central de cada examen de manejo
-- correlativo: reinicia cada dia por centro
-- Opcionales: res_teorico (NULL), res_practico (NULL)
--             se llenan al completar cada fase del examen
-- ============================================================
CREATE TABLE EVALUACION (
    id_evaluacion   NUMBER(10)   NOT NULL,
    correlativo     NUMBER(5)    NOT NULL,
    fecha           DATE         NOT NULL,
    res_teorico     NUMBER(5,2)  NULL,
    res_practico    NUMBER(5,2)  NULL,
    id_persona      NUMBER(10)   NOT NULL,
    id_centro       NUMBER(10)   NOT NULL,
    id_instructor   NUMBER(10)   NOT NULL,
    fec_creacion    DATE         DEFAULT SYSDATE NOT NULL,
    id_usuario_reg  NUMBER(10)   NOT NULL,
    CONSTRAINT PK_EVALUACION       PRIMARY KEY (id_evaluacion),
    CONSTRAINT UQ_EVAL_CORR_DIARIO UNIQUE (fecha, correlativo, id_centro),
    CONSTRAINT FK_EVAL_PERSONA     FOREIGN KEY (id_persona)
        REFERENCES PERSONA    (id_persona),
    CONSTRAINT FK_EVAL_CENTRO      FOREIGN KEY (id_centro)
        REFERENCES CENTRO     (id_centro),
    CONSTRAINT FK_EVAL_INSTRUCT    FOREIGN KEY (id_instructor)
        REFERENCES INSTRUCTOR (id_instructor),
    CONSTRAINT FK_EVAL_USUARIO     FOREIGN KEY (id_usuario_reg)
        REFERENCES USUARIO    (id_usuario)
);


-- ============================================================
-- TABLA: EVAL_RESP
-- Tabla intermedia - Relacion M:N entre EVALUACION y PREG_TEORICA
-- Detalle de respuestas seleccionadas en la fase teorica
-- Una fila por cada pregunta respondida en cada evaluacion
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE EVAL_RESP (
    id_eval_resp    NUMBER(10) NOT NULL,
    id_evaluacion   NUMBER(10) NOT NULL,
    id_pregunta     NUMBER(10) NOT NULL,
    id_respuesta    NUMBER(10) NOT NULL,
    CONSTRAINT PK_EVAL_RESP      PRIMARY KEY (id_eval_resp),
    CONSTRAINT UQ_ER_PREG_EVAL   UNIQUE      (id_evaluacion, id_pregunta),
    CONSTRAINT FK_ER_EVALUACION  FOREIGN KEY (id_evaluacion)
        REFERENCES EVALUACION   (id_evaluacion),
    CONSTRAINT FK_ER_PREGUNTA    FOREIGN KEY (id_pregunta)
        REFERENCES PREG_TEORICA (id_pregunta),
    CONSTRAINT FK_ER_RESPUESTA   FOREIGN KEY (id_respuesta)
        REFERENCES RESPUESTA    (id_respuesta)
);


-- ============================================================
-- TABLA: EVAL_INSTR
-- Tabla intermedia - Relacion M:N entre EVALUACION e INSTR_PRACTICA
-- Detalle de instrucciones practicas ejecutadas por evaluacion
-- Una fila por cada instruccion evaluada en cada evaluacion
-- cumplida: S=Si cumplio | N=No cumplio
-- Todos los campos obligatorios (NOT NULL)
-- ============================================================
CREATE TABLE EVAL_INSTR (
    id_eval_instr   NUMBER(10) NOT NULL,
    id_evaluacion   NUMBER(10) NOT NULL,
    id_instruccion  NUMBER(10) NOT NULL,
    cumplida        CHAR(1)    NOT NULL,
    CONSTRAINT PK_EVAL_INSTR     PRIMARY KEY (id_eval_instr),
    CONSTRAINT UQ_EI_INSTR_EVAL  UNIQUE      (id_evaluacion, id_instruccion),
    CONSTRAINT FK_EI_EVALUACION  FOREIGN KEY (id_evaluacion)
        REFERENCES EVALUACION     (id_evaluacion),
    CONSTRAINT FK_EI_INSTRUCCION FOREIGN KEY (id_instruccion)
        REFERENCES INSTR_PRACTICA (id_instruccion),
    CONSTRAINT CK_EI_CUMPLIDA    CHECK (cumplida IN ('S','N'))
);


-- ============================================================
-- FIN DEL SCRIPT DDL
-- 14 tablas creadas en orden de dependencias:
--   1. USUARIO
--   2. DEPTO
--   3. MUNICIPIO
--   4. CENTRO
--   5. ESCUELA
--   6. ESC_CENTRO     <- M:N Escuela/Centro
--   7. INSTRUCTOR
--   8. PERSONA
--   9. PREG_TEORICA
--  10. RESPUESTA
--  11. INSTR_PRACTICA
--  12. EVALUACION
--  13. EVAL_RESP      <- M:N Evaluacion/PregTeorica
--  14. EVAL_INSTR     <- M:N Evaluacion/InstrPractica
-- ============================================================
