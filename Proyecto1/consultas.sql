-- ============================================================
-- CONSULTAS SQL FINALES - REGISTRO ACADÉMICO FIUSAC
-- Proyecto 1 - Sistemas de Bases de Datos 1 - 1S 2026
-- ============================================================
--
-- REGLAS DE NEGOCIO:
--
-- REGLA 1 - Aprobación:
--   a) zona >= ZONAMINIMA del pensum
--   b) nota >= NOTAAPROBACION del pensum
--   c) Todos los cursos prerrequisito aprobados
--   d) Créditos totales aprobados en la carrera >= CREDPRERREQUISITOS
--      NOTA: se verifica sobre el total acumulado al cerrar, no
--      ciclo a ciclo, porque varios cursos del mismo ciclo pueden
--      compartir el requisito (ej: cursos 141-145 todos en CICLO9).
--
-- REGLA 2 - Promedio: solo sobre notas aprobadas.
--
-- REGLA 3 - Cierre: todos los obligatorios aprobados dentro del
--   período de vigencia + créditos >= NUMCREDITOSCIERRE.
--
-- REGLA 4 - Mejor estudiante: mayor promedio + ningún curso perdido.
-- ============================================================


-- ============================================================
-- CONSULTA 1
-- Nombre, promedio y créditos ganados de estudiantes que
-- cerraron Ingeniería en Ciencias y Sistemas (carrera 9).
-- ============================================================

SELECT
    e.NOMBRE                    AS NOMBRE_ESTUDIANTE,
    ROUND(AVG(a.NOTA), 2)       AS PROMEDIO,
    SUM(ps.NUMCREDITOS)         AS CREDITOS_GANADOS
FROM
    ESTUDIANTE e
    JOIN ASIGNACION a
        ON  a.ESTUDIANTE_CARNET     = e.CARNET
    JOIN PENSUM ps
        ON  ps.CURSO_CODIGOCURSO    = a.SECCION_CODIGOCURSO
        AND ps.PLAN_CARRERA_CARRERA = 9
    JOIN PLAN pl
        ON  pl.PLAN    = ps.PLAN_PLAN
        AND pl.CARRERA = ps.PLAN_CARRERA_CARRERA
    JOIN CARRERA c
        ON  c.CARRERA = pl.CARRERA
        AND c.CARRERA = 9
WHERE
    -- REGLA 2: solo cursos aprobados
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    -- Dentro del período de vigencia del plan
    AND (
            a.SECCION_ANIO < pl.ANIOFINAL
         OR (
                a.SECCION_ANIO = pl.ANIOFINAL
            AND TO_NUMBER(SUBSTR(a.SECCION_CICLO, 6))
                    <= TO_NUMBER(SUBSTR(pl.CICLOFINAL, 6))
            )
    )
    -- REGLA 3: el estudiante cerró la carrera 9
    AND e.CARNET IN (
        SELECT  a2.ESTUDIANTE_CARNET
        FROM    ASIGNACION a2
                JOIN PENSUM ps2
                    ON  ps2.CURSO_CODIGOCURSO    = a2.SECCION_CODIGOCURSO
                    AND ps2.PLAN_CARRERA_CARRERA  = 9
                    AND ps2.OBLIGATORIEDAD        = 1
                JOIN PLAN pl2
                    ON  pl2.PLAN    = ps2.PLAN_PLAN
                    AND pl2.CARRERA = ps2.PLAN_CARRERA_CARRERA
        WHERE
            -- REGLA 1a y 1b
            a2.ZONA >= ps2.ZONAMINIMA
            AND a2.NOTA >= ps2.NOTAAPROBACION
            -- Dentro del período de vigencia
            AND (
                    a2.SECCION_ANIO < pl2.ANIOFINAL
                 OR (
                        a2.SECCION_ANIO = pl2.ANIOFINAL
                    AND TO_NUMBER(SUBSTR(a2.SECCION_CICLO, 6))
                            <= TO_NUMBER(SUBSTR(pl2.CICLOFINAL, 6))
                    )
            )
            -- REGLA 1c: todos los cursos prerrequisito aprobados
            AND NOT EXISTS (
                SELECT 1
                FROM   PRERREQUISITO pr
                WHERE  pr.PENSUM_CARRERA = 9
                AND    pr.PENSUM_PLAN    = ps2.PLAN_PLAN
                AND    pr.PENSUM_CURSO   = a2.SECCION_CODIGOCURSO
                AND NOT EXISTS (
                    SELECT 1
                    FROM   ASIGNACION a_pre
                           JOIN PENSUM ps_pre
                               ON  ps_pre.CURSO_CODIGOCURSO    = a_pre.SECCION_CODIGOCURSO
                               AND ps_pre.PLAN_PLAN             = ps2.PLAN_PLAN
                               AND ps_pre.PLAN_CARRERA_CARRERA  = 9
                    WHERE  a_pre.ESTUDIANTE_CARNET   = a2.ESTUDIANTE_CARNET
                    AND    a_pre.SECCION_CODIGOCURSO = pr.CURSO_PREREQUISITO
                    AND    a_pre.ZONA >= ps_pre.ZONAMINIMA
                    AND    a_pre.NOTA >= ps_pre.NOTAAPROBACION
                )
            )
            -- REGLA 1d: créditos totales aprobados >= CREDPRERREQUISITOS
            -- Se usa el total acumulado en la carrera porque múltiples
            -- cursos del mismo ciclo pueden compartir este requisito.
            AND (
                ps2.CREDPRERREQUISITOS = 0
                OR (
                    SELECT NVL(SUM(ps_cred.NUMCREDITOS), 0)
                    FROM   ASIGNACION a_cred
                           JOIN PENSUM ps_cred
                               ON  ps_cred.CURSO_CODIGOCURSO    = a_cred.SECCION_CODIGOCURSO
                               AND ps_cred.PLAN_PLAN             = ps2.PLAN_PLAN
                               AND ps_cred.PLAN_CARRERA_CARRERA  = 9
                    WHERE  a_cred.ESTUDIANTE_CARNET = a2.ESTUDIANTE_CARNET
                    AND    a_cred.ZONA >= ps_cred.ZONAMINIMA
                    AND    a_cred.NOTA >= ps_cred.NOTAAPROBACION
                ) >= ps2.CREDPRERREQUISITOS
            )
        GROUP BY
            a2.ESTUDIANTE_CARNET,
            ps2.PLAN_PLAN,
            ps2.PLAN_CARRERA_CARRERA,
            pl2.NUMCREDITOSCIERRE
        HAVING
            -- REGLA 3a: aprobó todos los cursos obligatorios
            COUNT(DISTINCT a2.SECCION_CODIGOCURSO) = (
                SELECT COUNT(*)
                FROM   PENSUM ps3
                WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
                AND    ps3.PLAN_CARRERA_CARRERA  = 9
                AND    ps3.OBLIGATORIEDAD        = 1
            )
            -- REGLA 3c: créditos suficientes para cierre
            AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
    )
GROUP BY
    e.CARNET,
    e.NOMBRE
ORDER BY
    PROMEDIO DESC;

-- Resultado esperado:
-- NOMBRE_ESTUDIANTE  | PROMEDIO | CREDITOS_GANADOS
-- ESTUDIANTE 1001    |    83.22 |             250


-- ============================================================
-- CONSULTA 2
-- Nombre, carrera, promedio y créditos de estudiantes que
-- cerraron en cualquier carrera, inscritos o no en ella.
-- ============================================================

SELECT
    e.NOMBRE                    AS NOMBRE_ESTUDIANTE,
    c.NOMBRE                    AS NOMBRE_CARRERA,
    ROUND(AVG(a.NOTA), 2)       AS PROMEDIO,
    SUM(ps.NUMCREDITOS)         AS CREDITOS_GANADOS
FROM
    ESTUDIANTE e
    JOIN ASIGNACION a
        ON  a.ESTUDIANTE_CARNET  = e.CARNET
    JOIN PENSUM ps
        ON  ps.CURSO_CODIGOCURSO = a.SECCION_CODIGOCURSO
    JOIN PLAN pl
        ON  pl.PLAN    = ps.PLAN_PLAN
        AND pl.CARRERA = ps.PLAN_CARRERA_CARRERA
    JOIN CARRERA c
        ON  c.CARRERA = pl.CARRERA
WHERE
    -- REGLA 2: solo cursos aprobados
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    -- Dentro del período de vigencia del plan
    AND (
            a.SECCION_ANIO < pl.ANIOFINAL
         OR (
                a.SECCION_ANIO = pl.ANIOFINAL
            AND TO_NUMBER(SUBSTR(a.SECCION_CICLO, 6))
                    <= TO_NUMBER(SUBSTR(pl.CICLOFINAL, 6))
            )
    )
    -- REGLA 3: cerró en esa carrera específica
    AND (e.CARNET, pl.CARRERA) IN (
        SELECT  a2.ESTUDIANTE_CARNET,
                ps2.PLAN_CARRERA_CARRERA
        FROM    ASIGNACION a2
                JOIN PENSUM ps2
                    ON  ps2.CURSO_CODIGOCURSO    = a2.SECCION_CODIGOCURSO
                    AND ps2.OBLIGATORIEDAD        = 1
                JOIN PLAN pl2
                    ON  pl2.PLAN    = ps2.PLAN_PLAN
                    AND pl2.CARRERA = ps2.PLAN_CARRERA_CARRERA
        WHERE
            -- REGLA 1a y 1b
            a2.ZONA >= ps2.ZONAMINIMA
            AND a2.NOTA >= ps2.NOTAAPROBACION
            AND (
                    a2.SECCION_ANIO < pl2.ANIOFINAL
                 OR (
                        a2.SECCION_ANIO = pl2.ANIOFINAL
                    AND TO_NUMBER(SUBSTR(a2.SECCION_CICLO, 6))
                            <= TO_NUMBER(SUBSTR(pl2.CICLOFINAL, 6))
                    )
            )
            -- REGLA 1c: prerrequisitos de cursos aprobados
            AND NOT EXISTS (
                SELECT 1
                FROM   PRERREQUISITO pr
                WHERE  pr.PENSUM_CARRERA = ps2.PLAN_CARRERA_CARRERA
                AND    pr.PENSUM_PLAN    = ps2.PLAN_PLAN
                AND    pr.PENSUM_CURSO   = a2.SECCION_CODIGOCURSO
                AND NOT EXISTS (
                    SELECT 1
                    FROM   ASIGNACION a_pre
                           JOIN PENSUM ps_pre
                               ON  ps_pre.CURSO_CODIGOCURSO    = a_pre.SECCION_CODIGOCURSO
                               AND ps_pre.PLAN_PLAN             = ps2.PLAN_PLAN
                               AND ps_pre.PLAN_CARRERA_CARRERA  = ps2.PLAN_CARRERA_CARRERA
                    WHERE  a_pre.ESTUDIANTE_CARNET   = a2.ESTUDIANTE_CARNET
                    AND    a_pre.SECCION_CODIGOCURSO = pr.CURSO_PREREQUISITO
                    AND    a_pre.ZONA >= ps_pre.ZONAMINIMA
                    AND    a_pre.NOTA >= ps_pre.NOTAAPROBACION
                )
            )
            -- REGLA 1d: créditos totales aprobados >= CREDPRERREQUISITOS
            AND (
                ps2.CREDPRERREQUISITOS = 0
                OR (
                    SELECT NVL(SUM(ps_cred.NUMCREDITOS), 0)
                    FROM   ASIGNACION a_cred
                           JOIN PENSUM ps_cred
                               ON  ps_cred.CURSO_CODIGOCURSO    = a_cred.SECCION_CODIGOCURSO
                               AND ps_cred.PLAN_PLAN             = ps2.PLAN_PLAN
                               AND ps_cred.PLAN_CARRERA_CARRERA  = ps2.PLAN_CARRERA_CARRERA
                    WHERE  a_cred.ESTUDIANTE_CARNET = a2.ESTUDIANTE_CARNET
                    AND    a_cred.ZONA >= ps_cred.ZONAMINIMA
                    AND    a_cred.NOTA >= ps_cred.NOTAAPROBACION
                ) >= ps2.CREDPRERREQUISITOS
            )
        GROUP BY
            a2.ESTUDIANTE_CARNET,
            ps2.PLAN_PLAN,
            ps2.PLAN_CARRERA_CARRERA,
            pl2.NUMCREDITOSCIERRE
        HAVING
            COUNT(DISTINCT a2.SECCION_CODIGOCURSO) = (
                SELECT COUNT(*)
                FROM   PENSUM ps3
                WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
                AND    ps3.PLAN_CARRERA_CARRERA  = ps2.PLAN_CARRERA_CARRERA
                AND    ps3.OBLIGATORIEDAD        = 1
            )
            AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
    )
GROUP BY
    e.CARNET,
    e.NOMBRE,
    c.CARRERA,
    c.NOMBRE
ORDER BY
    c.NOMBRE,
    PROMEDIO DESC;

-- Resultado esperado:
-- NOMBRE_ESTUDIANTE  | NOMBRE_CARRERA                    | PROMEDIO | CREDITOS
-- ESTUDIANTE 1001    | INGENIERIA EN CIENCIAS Y SISTEMAS |    83.22 |     250


-- ============================================================
-- CONSULTA 3
-- Estudiantes que ganaron algún curso con algún catedrático
-- que impartió cursos de Sistemas en el semestre pasado
-- (2014, CICLO9 y CICLO10).
-- ============================================================

SELECT DISTINCT
    e.NOMBRE    AS NOMBRE_ESTUDIANTE
FROM
    ESTUDIANTE e
    JOIN ASIGNACION a
        ON  a.ESTUDIANTE_CARNET   = e.CARNET
    JOIN SECCION sec
        ON  sec.SECCION           = a.SECCION_SECCION
        AND sec.ANIO              = a.SECCION_ANIO
        AND sec.CICLO             = a.SECCION_CICLO
        AND sec.CURSO_CODIGOCURSO = a.SECCION_CODIGOCURSO
    JOIN PENSUM ps
        ON  ps.CURSO_CODIGOCURSO  = a.SECCION_CODIGOCURSO
WHERE
    -- REGLA 1a y 1b: el estudiante ganó el curso
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    -- El catedrático impartió cursos de Sistemas el semestre pasado
    AND sec.CATEDRATICO_CATEDRATICO IN (
        SELECT DISTINCT sec2.CATEDRATICO_CATEDRATICO
        FROM   SECCION sec2
               JOIN PENSUM ps2
                   ON  ps2.CURSO_CODIGOCURSO    = sec2.CURSO_CODIGOCURSO
                   AND ps2.PLAN_CARRERA_CARRERA  = 9
        WHERE  sec2.ANIO = 2014
        AND    sec2.CICLO IN ('CICLO9', 'CICLO10')
    )
ORDER BY
    e.NOMBRE;

-- Resultado esperado:
-- NOMBRE_ESTUDIANTE
-- ESTUDIANTE 1001


-- ============================================================
-- CONSULTA 4
-- Para un estudiante que cerró carrera, dar el nombre de los
-- estudiantes que llevaron con él todos los cursos.
-- Parámetro: sustituir 1001 por el carnet deseado.
-- ============================================================

SELECT
    e.NOMBRE    AS NOMBRE_ESTUDIANTE
FROM
    ESTUDIANTE e
WHERE
    e.CARNET <> 1001

    -- GUARDA 1: el estudiante de referencia tiene asignaciones
    AND EXISTS (
        SELECT 1
        FROM   ASIGNACION
        WHERE  ESTUDIANTE_CARNET = 1001
    )

    -- GUARDA 2 - REGLA 3: el estudiante de referencia cerró carrera
    AND EXISTS (
        SELECT 1
        FROM   ASIGNACION a2
               JOIN PENSUM ps2
                   ON  ps2.CURSO_CODIGOCURSO    = a2.SECCION_CODIGOCURSO
                   AND ps2.OBLIGATORIEDAD        = 1
               JOIN PLAN pl2
                   ON  pl2.PLAN    = ps2.PLAN_PLAN
                   AND pl2.CARRERA = ps2.PLAN_CARRERA_CARRERA
        WHERE  a2.ESTUDIANTE_CARNET = 1001
        AND    a2.ZONA >= ps2.ZONAMINIMA
        AND    a2.NOTA >= ps2.NOTAAPROBACION
        AND    (
                   a2.SECCION_ANIO < pl2.ANIOFINAL
                OR (
                       a2.SECCION_ANIO = pl2.ANIOFINAL
                   AND TO_NUMBER(SUBSTR(a2.SECCION_CICLO, 6))
                           <= TO_NUMBER(SUBSTR(pl2.CICLOFINAL, 6))
                   )
               )
        GROUP BY
            a2.ESTUDIANTE_CARNET,
            ps2.PLAN_PLAN,
            ps2.PLAN_CARRERA_CARRERA,
            pl2.NUMCREDITOSCIERRE
        HAVING
            COUNT(DISTINCT a2.SECCION_CODIGOCURSO) = (
                SELECT COUNT(*) FROM PENSUM ps3
                WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
                AND    ps3.PLAN_CARRERA_CARRERA  = ps2.PLAN_CARRERA_CARRERA
                AND    ps3.OBLIGATORIEDAD        = 1
            )
            AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
    )

    -- CONDICIÓN PRINCIPAL: división relacional con doble NOT EXISTS
    AND NOT EXISTS (
        SELECT 1
        FROM   ASIGNACION a_ref
        WHERE  a_ref.ESTUDIANTE_CARNET = 1001
        AND NOT EXISTS (
            SELECT 1
            FROM   ASIGNACION a_cand
            WHERE  a_cand.ESTUDIANTE_CARNET   = e.CARNET
            AND    a_cand.SECCION_CODIGOCURSO  = a_ref.SECCION_CODIGOCURSO
            AND    a_cand.SECCION_SECCION      = a_ref.SECCION_SECCION
            AND    a_cand.SECCION_ANIO         = a_ref.SECCION_ANIO
            AND    a_cand.SECCION_CICLO        = a_ref.SECCION_CICLO
        )
    )
ORDER BY
    e.NOMBRE;

-- Resultado esperado con datos originales : sin filas
-- Resultado esperado con datos de prueba  : ESTUDIANTE 1002


-- ============================================================
-- CONSULTA ADICIONAL - REGLA 4
-- Mejor estudiante de la promoción:
-- mayor promedio (solo aprobados) + ningún curso perdido.
-- ============================================================

SELECT
    e.NOMBRE                    AS NOMBRE_ESTUDIANTE,
    ROUND(AVG(a.NOTA), 2)       AS PROMEDIO,
    SUM(ps.NUMCREDITOS)         AS CREDITOS_GANADOS
FROM
    ESTUDIANTE e
    JOIN ASIGNACION a
        ON  a.ESTUDIANTE_CARNET     = e.CARNET
    JOIN PENSUM ps
        ON  ps.CURSO_CODIGOCURSO    = a.SECCION_CODIGOCURSO
        AND ps.PLAN_CARRERA_CARRERA = 9
    JOIN PLAN pl
        ON  pl.PLAN    = ps.PLAN_PLAN
        AND pl.CARRERA = ps.PLAN_CARRERA_CARRERA
WHERE
    -- REGLA 2: solo notas aprobadas
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    -- REGLA 4b: no perdió ningún curso
    AND NOT EXISTS (
        SELECT 1
        FROM   ASIGNACION a_perd
               JOIN PENSUM ps_perd
                   ON  ps_perd.CURSO_CODIGOCURSO    = a_perd.SECCION_CODIGOCURSO
                   AND ps_perd.PLAN_CARRERA_CARRERA  = 9
        WHERE  a_perd.ESTUDIANTE_CARNET = e.CARNET
        AND    (
                   a_perd.ZONA < ps_perd.ZONAMINIMA
                OR a_perd.NOTA < ps_perd.NOTAAPROBACION
               )
    )
GROUP BY
    e.CARNET,
    e.NOMBRE
-- REGLA 4a: el que tenga el mayor promedio
HAVING
    ROUND(AVG(a.NOTA), 2) = (
        SELECT ROUND(MAX(prom), 2)
        FROM (
            SELECT AVG(a_i.NOTA) AS prom
            FROM   ASIGNACION a_i
                   JOIN PENSUM ps_i
                       ON  ps_i.CURSO_CODIGOCURSO    = a_i.SECCION_CODIGOCURSO
                       AND ps_i.PLAN_CARRERA_CARRERA  = 9
            WHERE  a_i.ZONA >= ps_i.ZONAMINIMA
            AND    a_i.NOTA >= ps_i.NOTAAPROBACION
            AND NOT EXISTS (
                SELECT 1
                FROM   ASIGNACION a_p
                       JOIN PENSUM ps_p
                           ON  ps_p.CURSO_CODIGOCURSO    = a_p.SECCION_CODIGOCURSO
                           AND ps_p.PLAN_CARRERA_CARRERA  = 9
                WHERE  a_p.ESTUDIANTE_CARNET = a_i.ESTUDIANTE_CARNET
                AND    (a_p.ZONA < ps_p.ZONAMINIMA OR a_p.NOTA < ps_p.NOTAAPROBACION)
            )
            GROUP BY a_i.ESTUDIANTE_CARNET
        )
    )
ORDER BY PROMEDIO DESC;

-- Resultado esperado:
-- NOMBRE_ESTUDIANTE | PROMEDIO | CREDITOS_GANADOS
-- ESTUDIANTE 1001   |    83.22 |             250

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================