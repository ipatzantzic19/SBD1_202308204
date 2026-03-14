-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-02-26 22:08:14 CST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE CENTRO 
    ( 
     id_centro          INTEGER  NOT NULL , 
     nombre             VARCHAR2 (150 CHAR)  NOT NULL , 
     direccion          VARCHAR2 (250 CHAR)  NOT NULL , 
     fec_creacion       DATE  NOT NULL , 
     id_usuario_reg     INTEGER  NOT NULL , 
     USUARIO_id_usuario INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX CENTRO__IDX ON CENTRO 
    ( 
     USUARIO_id_usuario ASC 
    ) 
;

ALTER TABLE CENTRO 
    ADD CONSTRAINT CENTRO_PK PRIMARY KEY ( id_centro ) ;

CREATE TABLE DEPTO 
    ( 
     id_depto INTEGER  NOT NULL , 
     nombre   VARCHAR2 (100 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE DEPTO 
    ADD CONSTRAINT DEPTO_PK PRIMARY KEY ( id_depto ) ;

CREATE TABLE ESC_CENTRO 
    ( 
     id_esc_centro INTEGER  NOT NULL , 
     id_escuela    INTEGER  NOT NULL , 
     id_centro     INTEGER  NOT NULL , 
     fec_registro  DATE  NOT NULL 
    ) 
;

ALTER TABLE ESC_CENTRO 
    ADD CONSTRAINT ESC_CENTRO_PK PRIMARY KEY ( id_esc_centro ) ;

CREATE TABLE ESCUELA 
    ( 
     id_escuela         INTEGER  NOT NULL , 
     nombre             VARCHAR2 (150 CHAR)  NOT NULL , 
     direccion          VARCHAR2 (250 CHAR)  NOT NULL , 
     num_autorizacion   VARCHAR2 (50 CHAR)  NOT NULL , 
     fec_creacion       DATE  NOT NULL , 
     id_usuario_reg     INTEGER  NOT NULL , 
     CENTRO_id_centro   INTEGER  NOT NULL , 
     USUARIO_id_usuario INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX ESCUELA__IDX ON ESCUELA 
    ( 
     USUARIO_id_usuario ASC 
    ) 
;

ALTER TABLE ESCUELA 
    ADD CONSTRAINT ESCUELA_PK PRIMARY KEY ( id_escuela ) ;

CREATE TABLE EVAL_INSTR 
    ( 
     id_eval_instr                 INTEGER  NOT NULL , 
     id_evaluacion                 INTEGER  NOT NULL , 
     id_instruccion                INTEGER  NOT NULL , 
     cumplida                      CHAR (1 CHAR)  NOT NULL , 
     EVALUACION_id_evaluacion      INTEGER  NOT NULL , 
     INSTR_PRACTICA_id_instruccion INTEGER  NOT NULL 
    ) 
;

ALTER TABLE EVAL_INSTR 
    ADD CONSTRAINT EVAL_INSTR_PK PRIMARY KEY ( id_eval_instr ) ;

CREATE TABLE EVAL_RESP 
    ( 
     id_eval_resp             INTEGER  NOT NULL , 
     id_evaluacion            INTEGER  NOT NULL , 
     id_pregunta              INTEGER  NOT NULL , 
     id_respuesta             INTEGER  NOT NULL , 
     EVALUACION_id_evaluacion INTEGER  NOT NULL , 
     PREG_TEORICA_id_pregunta INTEGER  NOT NULL , 
     RESPUESTA_id_respuesta   INTEGER  NOT NULL 
    ) 
;

ALTER TABLE EVAL_RESP 
    ADD CONSTRAINT EVAL_RESP_PK PRIMARY KEY ( id_eval_resp ) ;

CREATE TABLE EVALUACION 
    ( 
     id_evaluacion            INTEGER  NOT NULL , 
     correlativo              INTEGER  NOT NULL , 
     fecha                    INTEGER  NOT NULL , 
     res_teorico              INTEGER , 
     res_practico             INTEGER , 
     id_persona               INTEGER  NOT NULL , 
     id_centro                INTEGER  NOT NULL , 
     id_instructor            INTEGER  NOT NULL , 
     fec_creacion             DATE  NOT NULL , 
     id_usuario_reg           INTEGER  NOT NULL , 
     INSTRUCTOR_id_instructor INTEGER  NOT NULL , 
     CENTRO_id_centro         INTEGER  NOT NULL , 
     PERSONA_id_persona       INTEGER  NOT NULL 
    ) 
;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT EVALUACION_PK PRIMARY KEY ( id_evaluacion ) ;

CREATE TABLE INSTR_PRACTICA 
    ( 
     id_instruccion INTEGER  NOT NULL , 
     descripcion    VARCHAR2 (300 CHAR)  NOT NULL , 
     fec_creacion   DATE  NOT NULL , 
     id_usuario_reg INTEGER  NOT NULL 
    ) 
;

ALTER TABLE INSTR_PRACTICA 
    ADD CONSTRAINT INSTR_PRACTICA_PK PRIMARY KEY ( id_instruccion ) ;

CREATE TABLE INSTRUCTOR 
    ( 
     id_instructor INTEGER  NOT NULL , 
     nombre        VARCHAR2 (150 CHAR)  NOT NULL , 
     dpi           INTEGER  NOT NULL , 
     fec_creacion  DATE  NOT NULL 
    ) 
;

ALTER TABLE INSTRUCTOR 
    ADD CONSTRAINT INSTRUCTOR_PK PRIMARY KEY ( id_instructor ) ;

CREATE TABLE MUNICIPIO 
    ( 
     id_municipio       INTEGER  NOT NULL , 
     nombre             VARCHAR2 (100 CHAR)  NOT NULL , 
     id_depto           INTEGER  NOT NULL , 
     PERSONA_id_persona INTEGER  NOT NULL , 
     DEPTO_id_depto     INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX MUNICIPIO__IDX ON MUNICIPIO 
    ( 
     PERSONA_id_persona ASC 
    ) 
;

ALTER TABLE MUNICIPIO 
    ADD CONSTRAINT MUNICIPIO_PK PRIMARY KEY ( id_municipio ) ;

CREATE TABLE PERSONA 
    ( 
     id_persona             INTEGER  NOT NULL , 
     nombre_completo        VARCHAR2 (200 CHAR)  NOT NULL , 
     direccion              VARCHAR2 (250 CHAR)  NOT NULL , 
     dpi                    INTEGER  NOT NULL , 
     telefono               INTEGER , 
     foto                   BLOB , 
     tipo_licencia          CHAR (1 CHAR)  NOT NULL , 
     tipo_tramite           VARCHAR2 (30 CHAR)  NOT NULL , 
     genero                 CHAR (1 CHAR)  NOT NULL , 
     fec_nacimiento         DATE  NOT NULL , 
     id_municipio           INTEGER  NOT NULL , 
     id_escuela             INTEGER  NOT NULL , 
     fec_creacion           DATE  NOT NULL , 
     id_usuario_reg         INTEGER  NOT NULL , 
     MUNICIPIO_id_municipio INTEGER  NOT NULL , 
     ESCUELA_id_escuela     INTEGER  NOT NULL , 
     USUARIO_id_usuario     INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX PERSONA__IDX ON PERSONA 
    ( 
     USUARIO_id_usuario ASC 
    ) 
;
CREATE UNIQUE INDEX PERSONA__IDXv1 ON PERSONA 
    ( 
     MUNICIPIO_id_municipio ASC 
    ) 
;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_PK PRIMARY KEY ( id_persona ) ;

CREATE TABLE PREG_TEORICA 
    ( 
     id_pregunta    INTEGER  NOT NULL , 
     texto          VARCHAR2 (500 CHAR)  NOT NULL , 
     foto           BLOB , 
     fec_creacion   INTEGER  NOT NULL , 
     id_usuario_reg INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PREG_TEORICA 
    ADD CONSTRAINT PREG_TEORICA_PK PRIMARY KEY ( id_pregunta ) ;

CREATE TABLE Relation_5 
    ( 
     ESCUELA_id_escuela       INTEGER  NOT NULL , 
     ESC_CENTRO_id_esc_centro INTEGER  NOT NULL 
    ) 
;

ALTER TABLE Relation_5 
    ADD CONSTRAINT Relation_5_PK PRIMARY KEY ( ESCUELA_id_escuela, ESC_CENTRO_id_esc_centro ) ;

CREATE TABLE RESPUESTA 
    ( 
     id_respuesta             INTEGER  NOT NULL , 
     texto                    VARCHAR2 (500) , 
     foto                     BLOB , 
     es_correcta              CHAR (1 CHAR)  NOT NULL , 
     id_pregunta              INTEGER  NOT NULL , 
     PREG_TEORICA_id_pregunta INTEGER  NOT NULL 
    ) 
;

ALTER TABLE RESPUESTA 
    ADD CONSTRAINT RESPUESTA_PK PRIMARY KEY ( id_respuesta ) ;

CREATE TABLE USUARIO 
    ( 
     id_usuario         INTEGER  NOT NULL , 
     nombre             VARCHAR2 (150 CHAR)  NOT NULL , 
     dpi                INTEGER  NOT NULL , 
     usuario_acc        INTEGER  NOT NULL , 
     fec_creacion       DATE  NOT NULL , 
     CENTRO_id_centro   INTEGER  NOT NULL , 
     ESCUELA_id_escuela INTEGER  NOT NULL , 
     PERSONA_id_persona INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX USUARIO__IDX ON USUARIO 
    ( 
     CENTRO_id_centro ASC 
    ) 
;
CREATE UNIQUE INDEX USUARIO__IDXv1 ON USUARIO 
    ( 
     ESCUELA_id_escuela ASC 
    ) 
;
CREATE UNIQUE INDEX USUARIO__IDXv2 ON USUARIO 
    ( 
     PERSONA_id_persona ASC 
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PK PRIMARY KEY ( id_usuario ) ;

ALTER TABLE CENTRO 
    ADD CONSTRAINT CENTRO_USUARIO_FK FOREIGN KEY 
    ( 
     USUARIO_id_usuario
    ) 
    REFERENCES USUARIO 
    ( 
     id_usuario
    ) 
;

ALTER TABLE ESCUELA 
    ADD CONSTRAINT ESCUELA_CENTRO_FK FOREIGN KEY 
    ( 
     CENTRO_id_centro
    ) 
    REFERENCES CENTRO 
    ( 
     id_centro
    ) 
;

ALTER TABLE ESCUELA 
    ADD CONSTRAINT ESCUELA_USUARIO_FK FOREIGN KEY 
    ( 
     USUARIO_id_usuario
    ) 
    REFERENCES USUARIO 
    ( 
     id_usuario
    ) 
;

ALTER TABLE EVAL_INSTR 
    ADD CONSTRAINT EVAL_INSTR_EVALUACION_FK FOREIGN KEY 
    ( 
     EVALUACION_id_evaluacion
    ) 
    REFERENCES EVALUACION 
    ( 
     id_evaluacion
    ) 
;

ALTER TABLE EVAL_INSTR 
    ADD CONSTRAINT EVAL_INSTR_INSTR_PRACTICA_FK FOREIGN KEY 
    ( 
     INSTR_PRACTICA_id_instruccion
    ) 
    REFERENCES INSTR_PRACTICA 
    ( 
     id_instruccion
    ) 
;

ALTER TABLE EVAL_RESP 
    ADD CONSTRAINT EVAL_RESP_EVALUACION_FK FOREIGN KEY 
    ( 
     EVALUACION_id_evaluacion
    ) 
    REFERENCES EVALUACION 
    ( 
     id_evaluacion
    ) 
;

ALTER TABLE EVAL_RESP 
    ADD CONSTRAINT EVAL_RESP_PREG_TEORICA_FK FOREIGN KEY 
    ( 
     PREG_TEORICA_id_pregunta
    ) 
    REFERENCES PREG_TEORICA 
    ( 
     id_pregunta
    ) 
;

ALTER TABLE EVAL_RESP 
    ADD CONSTRAINT EVAL_RESP_RESPUESTA_FK FOREIGN KEY 
    ( 
     RESPUESTA_id_respuesta
    ) 
    REFERENCES RESPUESTA 
    ( 
     id_respuesta
    ) 
;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT EVALUACION_CENTRO_FK FOREIGN KEY 
    ( 
     CENTRO_id_centro
    ) 
    REFERENCES CENTRO 
    ( 
     id_centro
    ) 
;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT EVALUACION_INSTRUCTOR_FK FOREIGN KEY 
    ( 
     INSTRUCTOR_id_instructor
    ) 
    REFERENCES INSTRUCTOR 
    ( 
     id_instructor
    ) 
;

ALTER TABLE EVALUACION 
    ADD CONSTRAINT EVALUACION_PERSONA_FK FOREIGN KEY 
    ( 
     PERSONA_id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;

ALTER TABLE MUNICIPIO 
    ADD CONSTRAINT MUNICIPIO_DEPTO_FK FOREIGN KEY 
    ( 
     DEPTO_id_depto
    ) 
    REFERENCES DEPTO 
    ( 
     id_depto
    ) 
;

ALTER TABLE MUNICIPIO 
    ADD CONSTRAINT MUNICIPIO_PERSONA_FK FOREIGN KEY 
    ( 
     PERSONA_id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_ESCUELA_FK FOREIGN KEY 
    ( 
     ESCUELA_id_escuela
    ) 
    REFERENCES ESCUELA 
    ( 
     id_escuela
    ) 
;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_MUNICIPIO_FK FOREIGN KEY 
    ( 
     MUNICIPIO_id_municipio
    ) 
    REFERENCES MUNICIPIO 
    ( 
     id_municipio
    ) 
;

ALTER TABLE PERSONA 
    ADD CONSTRAINT PERSONA_USUARIO_FK FOREIGN KEY 
    ( 
     USUARIO_id_usuario
    ) 
    REFERENCES USUARIO 
    ( 
     id_usuario
    ) 
;

ALTER TABLE Relation_5 
    ADD CONSTRAINT Relation_5_ESC_CENTRO_FK FOREIGN KEY 
    ( 
     ESC_CENTRO_id_esc_centro
    ) 
    REFERENCES ESC_CENTRO 
    ( 
     id_esc_centro
    ) 
;

ALTER TABLE Relation_5 
    ADD CONSTRAINT Relation_5_ESCUELA_FK FOREIGN KEY 
    ( 
     ESCUELA_id_escuela
    ) 
    REFERENCES ESCUELA 
    ( 
     id_escuela
    ) 
;

ALTER TABLE RESPUESTA 
    ADD CONSTRAINT RESPUESTA_PREG_TEORICA_FK FOREIGN KEY 
    ( 
     PREG_TEORICA_id_pregunta
    ) 
    REFERENCES PREG_TEORICA 
    ( 
     id_pregunta
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_CENTRO_FK FOREIGN KEY 
    ( 
     CENTRO_id_centro
    ) 
    REFERENCES CENTRO 
    ( 
     id_centro
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_ESCUELA_FK FOREIGN KEY 
    ( 
     ESCUELA_id_escuela
    ) 
    REFERENCES ESCUELA 
    ( 
     id_escuela
    ) 
;

ALTER TABLE USUARIO 
    ADD CONSTRAINT USUARIO_PERSONA_FK FOREIGN KEY 
    ( 
     PERSONA_id_persona
    ) 
    REFERENCES PERSONA 
    ( 
     id_persona
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            15
-- CREATE INDEX                             8
-- ALTER TABLE                             37
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
