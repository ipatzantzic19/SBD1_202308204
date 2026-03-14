-- ============================================================
-- BASE DE DATOS 1 - PRACTICA NO. 2
-- Consulta 1
-- Listado de todas las evaluaciones realizadas en el dia.
-- Al ejecutar pedira el valor de fecha_consulta
-- Ingresar en formato: DD/MM/YYYY  (ej. 13/03/2023)
-- ============================================================

SELECT
    co.NO_EXAMEN                                            AS "No. Examen",
    re.ID_REGISTRO                                          AS "ID Registro",
    re.NOMBRE_COMPLETO                                      AS "Nombre Completo",
    re.GENERO                                               AS "Genero",
    re.TIPO_LICENCIA                                        AS "Tipo Licencia",
    re.TIPO_TRAMITE                                         AS "Tipo Tramite",
    d.NOMBRE                                                AS "Departamento",
    m.NOMBRE                                                AS "Municipio",
    esc.NOMBRE                                              AS "Escuela",
    cen.NOMBRE                                              AS "Centro",
    re.FECHA                                                AS "Fecha",
    NVL((
        SELECT SUM(4)
        FROM   RESPUESTA_USUARIO ru
        JOIN   PREGUNTAS p ON ru.PREGUNTA_ID_PREGUNTA = p.ID
        WHERE  ru.EXAMEN_ID_EXAMEN = ex.ID_EXAMEN
          AND  ru.RESPUESTA = p.RESPUESTA
    ), 0)                                                   AS "Nota Teorica",
    NVL((
        SELECT SUM(rpu.NOTA)
        FROM   RESPUESTA_PRACTICO_USUARIO rpu
        WHERE  rpu.EXAMEN_ID_EXAMEN = ex.ID_EXAMEN
    ), 0)                                                   AS "Nota Practica",
    CASE
        WHEN NVL((
                SELECT SUM(4)
                FROM   RESPUESTA_USUARIO ru
                JOIN   PREGUNTAS p ON ru.PREGUNTA_ID_PREGUNTA = p.ID
                WHERE  ru.EXAMEN_ID_EXAMEN = ex.ID_EXAMEN
                  AND  ru.RESPUESTA = p.RESPUESTA
             ), 0) >= 70
         AND NVL((
                SELECT SUM(rpu.NOTA)
                FROM   RESPUESTA_PRACTICO_USUARIO rpu
                WHERE  rpu.EXAMEN_ID_EXAMEN = ex.ID_EXAMEN
             ), 0) >= 70
        THEN 'APROBADO'
        ELSE 'REPROBADO'
    END                                                     AS "Resultado"
FROM
    EXAMEN          ex
    JOIN CORRELATIVO  co  ON ex.CORRELATIVO_ID_CORRELATIVO   = co.ID_CORRELATIVO
    JOIN REGISTRO     re  ON ex.REGISTRO_ID_REGISTRO         = re.ID_REGISTRO
    JOIN MUNICIPIO    m   ON re.MUNICIPIO_ID_MUNICIPIO       = m.ID_MUNICIPIO
    JOIN DEPARTAMENTO d   ON m.DEPARTAMENTO_ID_DEPARTAMENTO  = d.ID_DEPARTAMENTO
    JOIN ESCUELA      esc ON re.UBICACION_ESCUELA_ID_ESCUELA = esc.ID_ESCUELA
    JOIN CENTRO       cen ON re.UBICACION_CENTRO_ID_CENTRO   = cen.ID_CENTRO
WHERE
    TRUNC(re.FECHA) = TO_DATE('&fecha_consulta', 'DD/MM/YYYY')
ORDER BY
    co.NO_EXAMEN ASC;