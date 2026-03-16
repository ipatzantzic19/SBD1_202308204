CREATE TABLE CARRERA (
    CARRERA         NUMBER(5)       NOT NULL,
    NOMBRE          VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_CARRERA PRIMARY KEY (CARRERA)
);

-- ------------------------------------------------------------
-- CURSO
-- Catálogo general de cursos (código + nombre).
-- ------------------------------------------------------------
CREATE TABLE CURSO (
    CODIGOCURSO     NUMBER(5)       NOT NULL,
    NOMBRECURSO     VARCHAR2(100)   NOT NULL,
    CONSTRAINT PK_CURSO PRIMARY KEY (CODIGOCURSO)
);

-- ------------------------------------------------------------
-- CATEDRATICO
-- Docentes identificados por código, nombre y sueldo mensual.
-- ------------------------------------------------------------
CREATE TABLE CATEDRATICO (
    CATEDRATICO     NUMBER(5)       NOT NULL,
    NOMBRE          VARCHAR2(100)   NOT NULL,
    SUELDOMENSUAL   NUMBER(10,2)    NOT NULL,
    CONSTRAINT PK_CATEDRATICO PRIMARY KEY (CATEDRATICO)
);

-- ------------------------------------------------------------
-- ESTUDIANTE
-- Identificado por carnet, nombre, ingreso familiar y fecha de nacimiento.
-- ------------------------------------------------------------
CREATE TABLE ESTUDIANTE (
    CARNET              NUMBER(10)      NOT NULL,
    NOMBRE              VARCHAR2(100)   NOT NULL,
    INGRESOFAMILIAR     NUMBER(10,2)    NOT NULL,
    FECHANACIMIENTO     DATE            NOT NULL,
    CONSTRAINT PK_ESTUDIANTE PRIMARY KEY (CARNET)
);

-- ------------------------------------------------------------
-- DIA
-- Días de la semana (1=Lunes … 7=Domingo).
-- ------------------------------------------------------------
CREATE TABLE DIA (
    DIA         NUMBER(1)       NOT NULL,
    NOMBREDIA   VARCHAR2(20)    NOT NULL,
    CONSTRAINT PK_DIA PRIMARY KEY (DIA)
);

-- ------------------------------------------------------------
-- PERIODO
-- Periodos de clase identificados por código con hora inicio/fin.
-- ------------------------------------------------------------
CREATE TABLE PERIODO (
    PERIODO         NUMBER(3)       NOT NULL,
    HORARIOINICIO   VARCHAR2(10)    NOT NULL,
    HORARIOFINAL    VARCHAR2(10)    NOT NULL,
    CONSTRAINT PK_PERIODO PRIMARY KEY (PERIODO)
);

-- ------------------------------------------------------------
-- SALON
-- Salones identificados por edificio + número de salón y su capacidad.
-- ------------------------------------------------------------
CREATE TABLE SALON (
    EDIFICIO    VARCHAR2(10)    NOT NULL,
    SALON       NUMBER(5)       NOT NULL,
    CAPACIDAD   NUMBER(5)       NOT NULL,
    CONSTRAINT PK_SALON PRIMARY KEY (EDIFICIO, SALON)
);

-- ------------------------------------------------------------
-- PLAN
-- Plan de estudios por carrera: nombre, años de vigencia y créditos mínimos de cierre.
-- PK compuesta: PLAN + CARRERA (una misma clave de plan puede existir en diferentes carreras).
-- ------------------------------------------------------------
CREATE TABLE PLAN (
    PLAN                VARCHAR2(20)    NOT NULL,
    CARRERA             NUMBER(5)       NOT NULL,
    NOMBRE              VARCHAR2(50)    NOT NULL,
    ANIOINICIAL         NUMBER(4)       NOT NULL,
    CICLOINICIAL        VARCHAR2(20)    NOT NULL,
    ANIOFINAL           NUMBER(4)       NOT NULL,
    CICLOFINAL          VARCHAR2(20)    NOT NULL,
    NUMCREDITOSCIERRE   NUMBER(5)       NOT NULL,
    CONSTRAINT PK_PLAN PRIMARY KEY (PLAN, CARRERA),
    CONSTRAINT FK_PLAN_CARRERA FOREIGN KEY (CARRERA)
        REFERENCES CARRERA (CARRERA)
);

-- ------------------------------------------------------------
-- INSCRIPCION
-- Registro de la inscripción de un estudiante a una carrera.
-- Un estudiante puede inscribirse en máximo 2 carreras.
-- ------------------------------------------------------------
CREATE TABLE INSCRIPCION (
    CARRERA             NUMBER(5)   NOT NULL,
    CARNET              NUMBER(10)  NOT NULL,
    FECHAINSCRIPCION    DATE        NOT NULL,
    CONSTRAINT PK_INSCRIPCION PRIMARY KEY (CARRERA, CARNET),
    CONSTRAINT FK_INSCRIPCION_CARRERA   FOREIGN KEY (CARRERA)
        REFERENCES CARRERA (CARRERA),
    CONSTRAINT FK_INSCRIPCION_ESTUDIANTE FOREIGN KEY (CARNET)
        REFERENCES ESTUDIANTE (CARNET)
);

-- ------------------------------------------------------------
-- PENSUM
-- Pensum de estudios: relación de cursos por plan y carrera,
-- con obligatoriedad, créditos, nota de aprobación, zona mínima
-- y créditos prerrequisito.
-- ------------------------------------------------------------
CREATE TABLE PENSUM (
    CURSO_CODIGOCURSO       NUMBER(5)       NOT NULL,
    PLAN_PLAN               VARCHAR2(20)    NOT NULL,
    PLAN_CARRERA_CARRERA    NUMBER(5)       NOT NULL,
    OBLIGATORIEDAD          NUMBER(1)       NOT NULL,
    NUMCREDITOS             NUMBER(5)       NOT NULL,
    NOTAAPROBACION          NUMBER(5,2)     NOT NULL,
    ZONAMINIMA              NUMBER(5,2)     NOT NULL,
    CREDPRERREQUISITOS      NUMBER(5)       DEFAULT 0 NOT NULL,
    CONSTRAINT PK_PENSUM PRIMARY KEY (CURSO_CODIGOCURSO, PLAN_PLAN, PLAN_CARRERA_CARRERA),
    CONSTRAINT FK_PENSUM_CURSO FOREIGN KEY (CURSO_CODIGOCURSO)
        REFERENCES CURSO (CODIGOCURSO),
    CONSTRAINT FK_PENSUM_PLAN FOREIGN KEY (PLAN_PLAN, PLAN_CARRERA_CARRERA)
        REFERENCES PLAN (PLAN, CARRERA),
    CONSTRAINT CK_PENSUM_OBLIGATORIEDAD CHECK (OBLIGATORIEDAD IN (0, 1)),
    CONSTRAINT CK_PENSUM_NOTA CHECK (NOTAAPROBACION BETWEEN 0 AND 100),
    CONSTRAINT CK_PENSUM_ZONA CHECK (ZONAMINIMA BETWEEN 0 AND 100)
);

-- ------------------------------------------------------------
-- PRERREQUISITO
-- Cursos prerrequisito dentro de un plan/carrera.
-- ------------------------------------------------------------
CREATE TABLE PRERREQUISITO (
    PENSUM_CARRERA      NUMBER(5)       NOT NULL,
    PENSUM_PLAN         VARCHAR2(20)    NOT NULL,
    PENSUM_CURSO        NUMBER(5)       NOT NULL,
    CURSO_PREREQUISITO  NUMBER(5)       NOT NULL,
    CONSTRAINT PK_PRERREQUISITO PRIMARY KEY (PENSUM_CARRERA, PENSUM_PLAN, PENSUM_CURSO, CURSO_PREREQUISITO),
    CONSTRAINT FK_PRERREQ_PENSUM FOREIGN KEY (PENSUM_CURSO, PENSUM_PLAN, PENSUM_CARRERA)
        REFERENCES PENSUM (CURSO_CODIGOCURSO, PLAN_PLAN, PLAN_CARRERA_CARRERA),
    CONSTRAINT FK_PRERREQ_CURSO_PRE FOREIGN KEY (CURSO_PREREQUISITO)
        REFERENCES CURSO (CODIGOCURSO)
);

-- ------------------------------------------------------------
-- SECCION
-- Sección de un curso: identificada por SECCION+ANIO+CICLO+CURSO.
-- Cada sección tiene asignado un catedrático.
-- ------------------------------------------------------------
CREATE TABLE SECCION (
    SECCION                 VARCHAR2(5)     NOT NULL,
    ANIO                    NUMBER(4)       NOT NULL,
    CICLO                   VARCHAR2(20)    NOT NULL,
    CURSO_CODIGOCURSO       NUMBER(5)       NOT NULL,
    CATEDRATICO_CATEDRATICO NUMBER(5)       NOT NULL,
    CONSTRAINT PK_SECCION PRIMARY KEY (SECCION, ANIO, CICLO, CURSO_CODIGOCURSO),
    CONSTRAINT FK_SECCION_CURSO FOREIGN KEY (CURSO_CODIGOCURSO)
        REFERENCES CURSO (CODIGOCURSO),
    CONSTRAINT FK_SECCION_CATEDRATICO FOREIGN KEY (CATEDRATICO_CATEDRATICO)
        REFERENCES CATEDRATICO (CATEDRATICO)
);

-- ------------------------------------------------------------
-- HORARIO
-- Horario de cada sección: qué período, qué día y en qué salón
-- se imparte. PK compuesta de todos los campos.
-- ------------------------------------------------------------
CREATE TABLE HORARIO (
    SECCION_CURSO_CODIGOCURSO   NUMBER(5)       NOT NULL,
    SECCION_SECCION             VARCHAR2(5)     NOT NULL,
    SECCION_ANIO                NUMBER(4)       NOT NULL,
    SECCION_CICLO               VARCHAR2(20)    NOT NULL,
    PERIODO_PERIODO             NUMBER(3)       NOT NULL,
    DIA_DIA                     NUMBER(1)       NOT NULL,
    SALON_EDIFICIO              VARCHAR2(10)    NOT NULL,
    SALON_SALON                 NUMBER(5)       NOT NULL,
    CONSTRAINT PK_HORARIO PRIMARY KEY (
        SECCION_CURSO_CODIGOCURSO,
        SECCION_SECCION,
        SECCION_ANIO,
        SECCION_CICLO,
        PERIODO_PERIODO,
        DIA_DIA
    ),
    CONSTRAINT FK_HORARIO_SECCION FOREIGN KEY (
        SECCION_SECCION, SECCION_ANIO, SECCION_CICLO, SECCION_CURSO_CODIGOCURSO
    ) REFERENCES SECCION (SECCION, ANIO, CICLO, CURSO_CODIGOCURSO),
    CONSTRAINT FK_HORARIO_PERIODO FOREIGN KEY (PERIODO_PERIODO)
        REFERENCES PERIODO (PERIODO),
    CONSTRAINT FK_HORARIO_DIA FOREIGN KEY (DIA_DIA)
        REFERENCES DIA (DIA),
    CONSTRAINT FK_HORARIO_SALON FOREIGN KEY (SALON_EDIFICIO, SALON_SALON)
        REFERENCES SALON (EDIFICIO, SALON)
);

-- ------------------------------------------------------------
-- ASIGNACION
-- Registro de un estudiante asignado a una sección de curso,
-- con zona y nota obtenidas.
-- ------------------------------------------------------------
CREATE TABLE ASIGNACION (
    ESTUDIANTE_CARNET       NUMBER(10)      NOT NULL,
    SECCION_CODIGOCURSO     NUMBER(5)       NOT NULL,
    SECCION_SECCION         VARCHAR2(5)     NOT NULL,
    SECCION_ANIO            NUMBER(4)       NOT NULL,
    SECCION_CICLO           VARCHAR2(20)    NOT NULL,
    ZONA                    NUMBER(5,2),
    NOTA                    NUMBER(5,2),
    CONSTRAINT PK_ASIGNACION PRIMARY KEY (
        ESTUDIANTE_CARNET,
        SECCION_CODIGOCURSO,
        SECCION_SECCION,
        SECCION_ANIO,
        SECCION_CICLO
    ),
    CONSTRAINT FK_ASIGNACION_ESTUDIANTE FOREIGN KEY (ESTUDIANTE_CARNET)
        REFERENCES ESTUDIANTE (CARNET),
    CONSTRAINT FK_ASIGNACION_SECCION FOREIGN KEY (
        SECCION_SECCION, SECCION_ANIO, SECCION_CICLO, SECCION_CODIGOCURSO
    ) REFERENCES SECCION (SECCION, ANIO, CICLO, CURSO_CODIGOCURSO),
    CONSTRAINT CK_ASIGNACION_ZONA CHECK (ZONA IS NULL OR ZONA BETWEEN 0 AND 100),
    CONSTRAINT CK_ASIGNACION_NOTA CHECK (NOTA IS NULL OR NOTA BETWEEN 0 AND 100)
);