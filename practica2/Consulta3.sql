-- ============================================================
-- BASE DE DATOS 1 - PRACTICA NO. 2
-- Consulta 3
-- Cantidad de evaluaciones por tipo de tramite
-- y tipo de licencia en un rango de fechas
-- Al ejecutar pedira fecha_inicio y fecha_fin
-- Ingresar en formato: DD/MM/YYYY  (ej. 01/03/2023)
-- ============================================================

SELECT
    re.TIPO_TRAMITE                 AS "Tipo Tramite",
    re.TIPO_LICENCIA                AS "Tipo Licencia",
    COUNT(ex.ID_EXAMEN)             AS "Total Evaluaciones"
FROM
    EXAMEN    ex
    JOIN REGISTRO re ON ex.REGISTRO_ID_REGISTRO = re.ID_REGISTRO
WHERE
    TRUNC(re.FECHA) BETWEEN TO_DATE('&fecha_inicio', 'DD/MM/YYYY')
                        AND TO_DATE('&fecha_fin',    'DD/MM/YYYY')
GROUP BY
    re.TIPO_TRAMITE,
    re.TIPO_LICENCIA
ORDER BY
    re.TIPO_TRAMITE ASC,
    re.TIPO_LICENCIA ASC;