-- ============================================================
-- BASE DE DATOS 1 - PRACTICA NO. 2
-- Consulta 2
-- Notas de evaluaciones APROBADAS en un rango de fechas
-- (>= 70 puntos teoricos Y >= 70 puntos practicos)
-- Al ejecutar pedira fecha_inicio y fecha_fin
-- Ingresar en formato: DD/MM/YYYY  (ej. 01/03/2023)
-- ============================================================

SELECT
    ex.ID_EXAMEN                                            AS "ID Examen",
    co.NO_EXAMEN                                            AS "No. Examen",
    re.FECHA                                                AS "Fecha",
    re.NOMBRE_COMPLETO                                      AS "Nombre Completo",
    re.TIPO_LICENCIA                                        AS "Tipo Licencia",
    re.TIPO_TRAMITE                                         AS "Tipo Tramite",
    cen.NOMBRE                                              AS "Centro",
    nota_teo.NOTA_TEORICA                                   AS "Nota Teorica",
    nota_pra.NOTA_PRACTICA                                  AS "Nota Practica",
    ROUND((nota_teo.NOTA_TEORICA + nota_pra.NOTA_PRACTICA) / 2, 2)
                                                            AS "Promedio Final"
FROM
    EXAMEN ex
    JOIN CORRELATIVO  co  ON ex.CORRELATIVO_ID_CORRELATIVO   = co.ID_CORRELATIVO
    JOIN REGISTRO     re  ON ex.REGISTRO_ID_REGISTRO         = re.ID_REGISTRO
    JOIN CENTRO       cen ON re.UBICACION_CENTRO_ID_CENTRO   = cen.ID_CENTRO
    JOIN (
        SELECT   ru.EXAMEN_ID_EXAMEN, SUM(4) AS NOTA_TEORICA
        FROM     RESPUESTA_USUARIO ru
        JOIN     PREGUNTAS p ON ru.PREGUNTA_ID_PREGUNTA = p.ID
        WHERE    ru.RESPUESTA = p.RESPUESTA
        GROUP BY ru.EXAMEN_ID_EXAMEN
    ) nota_teo ON nota_teo.EXAMEN_ID_EXAMEN = ex.ID_EXAMEN
    JOIN (
        SELECT   rpu.EXAMEN_ID_EXAMEN, SUM(rpu.NOTA) AS NOTA_PRACTICA
        FROM     RESPUESTA_PRACTICO_USUARIO rpu
        GROUP BY rpu.EXAMEN_ID_EXAMEN
    ) nota_pra ON nota_pra.EXAMEN_ID_EXAMEN = ex.ID_EXAMEN
WHERE
    TRUNC(re.FECHA) BETWEEN TO_DATE('&fecha_inicio', 'DD/MM/YYYY')
                        AND TO_DATE('&fecha_fin',    'DD/MM/YYYY')
    AND nota_teo.NOTA_TEORICA  >= 70
    AND nota_pra.NOTA_PRACTICA >= 70
ORDER BY
    re.FECHA ASC,
    co.NO_EXAMEN ASC;