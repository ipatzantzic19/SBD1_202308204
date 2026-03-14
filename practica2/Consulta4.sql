-- ============================================================
-- BASE DE DATOS 1 - PRACTICA NO. 2
-- Consulta 4
-- Preguntas teoricas con mayores aciertos en un rango
-- de fechas, ordenadas de mayor a menor
-- Al ejecutar pedira fecha_inicio y fecha_fin
-- Ingresar en formato: DD/MM/YYYY  (ej. 01/03/2023)
-- ============================================================

SELECT
    p.ID                                                AS "ID Pregunta",
    p.PREGUNTA_TEXTO                                    AS "Pregunta",
    p.RES1                                              AS "Opcion 1",
    p.RES2                                              AS "Opcion 2",
    p.RES3                                              AS "Opcion 3",
    p.RES4                                              AS "Opcion 4",
    p.RESPUESTA                                         AS "Respuesta Correcta (1-4)",
    COUNT(ru.ID_RESPUESTA_USUARIO)                      AS "Total Respuestas",
    SUM(CASE WHEN ru.RESPUESTA = p.RESPUESTA THEN 1 ELSE 0 END)
                                                        AS "Total Aciertos",
    ROUND(
        SUM(CASE WHEN ru.RESPUESTA = p.RESPUESTA THEN 1 ELSE 0 END)
        * 100.0 / COUNT(ru.ID_RESPUESTA_USUARIO), 2
    )                                                   AS "% Aciertos"
FROM
    PREGUNTAS p
    JOIN RESPUESTA_USUARIO ru ON ru.PREGUNTA_ID_PREGUNTA = p.ID
    JOIN EXAMEN            ex ON ru.EXAMEN_ID_EXAMEN     = ex.ID_EXAMEN
    JOIN REGISTRO          re ON ex.REGISTRO_ID_REGISTRO = re.ID_REGISTRO
WHERE
    TRUNC(re.FECHA) BETWEEN TO_DATE('&fecha_inicio', 'DD/MM/YYYY')
                        AND TO_DATE('&fecha_fin',    'DD/MM/YYYY')
GROUP BY
    p.ID,
    p.PREGUNTA_TEXTO,
    p.RES1,
    p.RES2,
    p.RES3,
    p.RES4,
    p.RESPUESTA
ORDER BY
    SUM(CASE WHEN ru.RESPUESTA = p.RESPUESTA THEN 1 ELSE 0 END) DESC;