-- ============================================================
-- BASE DE DATOS 1 - PRACTICA NO. 2
-- Vistas para consultar las 12 tablas del modelo
-- ============================================================


-- ============================================================
-- LIMPIEZA: eliminar vistas si ya existen
-- ============================================================
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_DEPARTAMENTO';           EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_MUNICIPIO';              EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_CENTRO';                 EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_ESCUELA';                EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_UBICACION';              EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_PREGUNTAS';              EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_PREGUNTAS_PRACTICO';     EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_REGISTRO';               EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_CORRELATIVO';            EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_EXAMEN';                 EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_RESPUESTA_USUARIO';      EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW V_RESP_PRACTICO_USUARIO';  EXCEPTION WHEN OTHERS THEN NULL; END;
/


-- ============================================================
-- VISTA 1: V_DEPARTAMENTO
-- Catalogo de departamentos de Guatemala
-- ============================================================
CREATE OR REPLACE VIEW V_DEPARTAMENTO AS
SELECT
    ID_DEPARTAMENTO     AS "ID",
    NOMBRE              AS "Departamento",
    CODIGO              AS "Codigo"
FROM DEPARTAMENTO
ORDER BY ID_DEPARTAMENTO;


-- ============================================================
-- VISTA 2: V_MUNICIPIO
-- Municipios con nombre de departamento
-- ============================================================
CREATE OR REPLACE VIEW V_MUNICIPIO AS
SELECT
    m.ID_MUNICIPIO                      AS "ID Municipio",
    m.NOMBRE                            AS "Municipio",
    m.CODIGO                            AS "Codigo",
    d.ID_DEPARTAMENTO                   AS "ID Departamento",
    d.NOMBRE                            AS "Departamento"
FROM MUNICIPIO m
JOIN DEPARTAMENTO d ON m.DEPARTAMENTO_ID_DEPARTAMENTO = d.ID_DEPARTAMENTO
ORDER BY d.ID_DEPARTAMENTO, m.CODIGO;


-- ============================================================
-- VISTA 3: V_CENTRO
-- Centros de evaluacion de manejo
-- ============================================================
CREATE OR REPLACE VIEW V_CENTRO AS
SELECT
    ID_CENTRO   AS "ID Centro",
    NOMBRE      AS "Centro"
FROM CENTRO
ORDER BY ID_CENTRO;


-- ============================================================
-- VISTA 4: V_ESCUELA
-- Escuelas de automovilismo
-- ============================================================
CREATE OR REPLACE VIEW V_ESCUELA AS
SELECT
    ID_ESCUELA  AS "ID Escuela",
    NOMBRE      AS "Escuela",
    DIRECCION   AS "Direccion",
    ACUERDO     AS "No. Acuerdo"
FROM ESCUELA
ORDER BY ID_ESCUELA;


-- ============================================================
-- VISTA 5: V_UBICACION
-- Relacion escuela-centro con nombres descriptivos
-- ============================================================
CREATE OR REPLACE VIEW V_UBICACION AS
SELECT
    e.ID_ESCUELA    AS "ID Escuela",
    e.NOMBRE        AS "Escuela",
    c.ID_CENTRO     AS "ID Centro",
    c.NOMBRE        AS "Centro"
FROM UBICACION u
JOIN ESCUELA e ON u.ESCUELA_ID_ESCUELA = e.ID_ESCUELA
JOIN CENTRO  c ON u.CENTRO_ID_CENTRO   = c.ID_CENTRO
ORDER BY e.ID_ESCUELA, c.ID_CENTRO;


-- ============================================================
-- VISTA 6: V_PREGUNTAS
-- Banco de preguntas teoricas con respuesta correcta resaltada
-- ============================================================
CREATE OR REPLACE VIEW V_PREGUNTAS AS
SELECT
    ID                  AS "ID",
    PREGUNTA_TEXTO      AS "Pregunta",
    RES1                AS "Opcion 1",
    RES2                AS "Opcion 2",
    RES3                AS "Opcion 3",
    RES4                AS "Opcion 4",
    RESPUESTA           AS "No. Correcta",
    CASE RESPUESTA
        WHEN 1 THEN RES1
        WHEN 2 THEN RES2
        WHEN 3 THEN RES3
        WHEN 4 THEN RES4
    END                 AS "Respuesta Correcta"
FROM PREGUNTAS
ORDER BY ID;


-- ============================================================
-- VISTA 7: V_PREGUNTAS_PRACTICO
-- Banco de instrucciones de la evaluacion practica
-- ============================================================
CREATE OR REPLACE VIEW V_PREGUNTAS_PRACTICO AS
SELECT
    ID_PREGUNTA_PRACTICO    AS "ID",
    PREGUNTA_TEXTO          AS "Instruccion",
    PUNTEO                  AS "Punteo"
FROM PREGUNTAS_PRACTICO
ORDER BY ID_PREGUNTA_PRACTICO;


-- ============================================================
-- VISTA 8: V_REGISTRO
-- Datos generales de los evaluados con municipio y departamento
-- ============================================================
CREATE OR REPLACE VIEW V_REGISTRO AS
SELECT
    re.ID_REGISTRO          AS "ID Registro",
    re.NOMBRE_COMPLETO      AS "Nombre",
    re.GENERO               AS "Genero",
    re.TIPO_LICENCIA        AS "Tipo Licencia",
    re.TIPO_TRAMITE         AS "Tipo Tramite",
    re.FECHA                AS "Fecha",
    m.NOMBRE                AS "Municipio",
    d.NOMBRE                AS "Departamento",
    e.NOMBRE                AS "Escuela",
    c.NOMBRE                AS "Centro"
FROM REGISTRO re
JOIN MUNICIPIO    m ON re.MUNICIPIO_ID_MUNICIPIO        = m.ID_MUNICIPIO
JOIN DEPARTAMENTO d ON re.MUNICIPIO_DEPARTAMENTO_ID_DEPARTAMENTO = d.ID_DEPARTAMENTO
JOIN ESCUELA      e ON re.UBICACION_ESCUELA_ID_ESCUELA  = e.ID_ESCUELA
JOIN CENTRO       c ON re.UBICACION_CENTRO_ID_CENTRO    = c.ID_CENTRO
ORDER BY re.ID_REGISTRO;


-- ============================================================
-- VISTA 9: V_CORRELATIVO
-- Correlativos diarios de examenes
-- ============================================================
CREATE OR REPLACE VIEW V_CORRELATIVO AS
SELECT
    ID_CORRELATIVO  AS "ID Correlativo",
    FECHA           AS "Fecha",
    NO_EXAMEN       AS "No. Examen del Dia"
FROM CORRELATIVO
ORDER BY FECHA, NO_EXAMEN;


-- ============================================================
-- VISTA 10: V_EXAMEN
-- Examenes con datos del evaluado y correlativo
-- ============================================================
CREATE OR REPLACE VIEW V_EXAMEN AS
SELECT
    ex.ID_EXAMEN            AS "ID Examen",
    co.NO_EXAMEN            AS "No. Examen",
    co.FECHA                AS "Fecha",
    re.NOMBRE_COMPLETO      AS "Evaluado",
    re.TIPO_LICENCIA        AS "Tipo Licencia",
    re.TIPO_TRAMITE         AS "Tipo Tramite",
    e.NOMBRE                AS "Escuela",
    c.NOMBRE                AS "Centro"
FROM EXAMEN ex
JOIN CORRELATIVO co ON ex.CORRELATIVO_ID_CORRELATIVO   = co.ID_CORRELATIVO
JOIN REGISTRO    re ON ex.REGISTRO_ID_REGISTRO         = re.ID_REGISTRO
JOIN ESCUELA      e ON re.UBICACION_ESCUELA_ID_ESCUELA = e.ID_ESCUELA
JOIN CENTRO       c ON re.UBICACION_CENTRO_ID_CENTRO   = c.ID_CENTRO
ORDER BY co.FECHA, co.NO_EXAMEN;


-- ============================================================
-- VISTA 11: V_RESPUESTA_USUARIO
-- Respuestas teoricas del evaluado con indicador de acierto
-- ============================================================
CREATE OR REPLACE VIEW V_RESPUESTA_USUARIO AS
SELECT
    ru.ID_RESPUESTA_USUARIO         AS "ID",
    ex.ID_EXAMEN                    AS "ID Examen",
    re.NOMBRE_COMPLETO              AS "Evaluado",
    p.ID                            AS "ID Pregunta",
    p.PREGUNTA_TEXTO                AS "Pregunta",
    ru.RESPUESTA                    AS "Respuesta Elegida (1-4)",
    p.RESPUESTA                     AS "Respuesta Correcta (1-4)",
    CASE
        WHEN ru.RESPUESTA = p.RESPUESTA THEN 'CORRECTO'
        ELSE 'INCORRECTO'
    END                             AS "Resultado",
    CASE
        WHEN ru.RESPUESTA = p.RESPUESTA THEN 4
        ELSE 0
    END                             AS "Puntos"
FROM RESPUESTA_USUARIO ru
JOIN PREGUNTAS p  ON ru.PREGUNTA_ID_PREGUNTA = p.ID
JOIN EXAMEN    ex ON ru.EXAMEN_ID_EXAMEN     = ex.ID_EXAMEN
JOIN REGISTRO  re ON ex.REGISTRO_ID_REGISTRO = re.ID_REGISTRO
ORDER BY ex.ID_EXAMEN, p.ID;


-- ============================================================
-- VISTA 12: V_RESP_PRACTICO_USUARIO
-- Resultados de la evaluacion practica por instruccion
-- ============================================================
CREATE OR REPLACE VIEW V_RESP_PRACTICO_USUARIO AS
SELECT
    rpu.ID_RESPUESTA_PRACTICO                   AS "ID",
    ex.ID_EXAMEN                                AS "ID Examen",
    re.NOMBRE_COMPLETO                          AS "Evaluado",
    pp.ID_PREGUNTA_PRACTICO                     AS "ID Instruccion",
    pp.PREGUNTA_TEXTO                           AS "Instruccion",
    pp.PUNTEO                                   AS "Punteo Maximo",
    rpu.NOTA                                    AS "Nota Obtenida",
    CASE
        WHEN rpu.NOTA >= pp.PUNTEO THEN 'COMPLETO'
        WHEN rpu.NOTA > 0          THEN 'PARCIAL'
        ELSE                            'NO REALIZO'
    END                                         AS "Estado"
FROM RESPUESTA_PRACTICO_USUARIO rpu
JOIN PREGUNTAS_PRACTICO pp ON rpu.PREGUNTA_PRACTICO_ID_PREGUNTA_PRACTICO = pp.ID_PREGUNTA_PRACTICO
JOIN EXAMEN             ex ON rpu.EXAMEN_ID_EXAMEN                       = ex.ID_EXAMEN
JOIN REGISTRO           re ON ex.REGISTRO_ID_REGISTRO                    = re.ID_REGISTRO
ORDER BY ex.ID_EXAMEN, pp.ID_PREGUNTA_PRACTICO;


-- ============================================================
-- PARA CONSULTAR CADA VISTA EJECUTA:
-- ============================================================
-- SELECT * FROM V_DEPARTAMENTO;
-- SELECT * FROM V_MUNICIPIO;
-- SELECT * FROM V_CENTRO;
-- SELECT * FROM V_ESCUELA;
-- SELECT * FROM V_UBICACION;
-- SELECT * FROM V_PREGUNTAS;
-- SELECT * FROM V_PREGUNTAS_PRACTICO;
-- SELECT * FROM V_REGISTRO;
-- SELECT * FROM V_CORRELATIVO;
-- SELECT * FROM V_EXAMEN;
-- SELECT * FROM V_RESPUESTA_USUARIO;
-- SELECT * FROM V_RESP_PRACTICO_USUARIO;
-- ============================================================