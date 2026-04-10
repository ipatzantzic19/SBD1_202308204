# Proyecto 1 — Registro Académico Facultad de Ingeniería USAC
**Universidad San Carlos de Guatemala**  
**Facultad de Ingeniería — Ingeniería en Ciencias y Sistemas**  
**Sistemas de Bases de Datos 1 — Primer Semestre 2026**

---

## Índice

1. [Descripción del Sistema](#1-descripción-del-sistema)
2. [Entidades y Atributos](#2-entidades-y-atributos)
3. [Relaciones entre Entidades](#3-relaciones-entre-entidades)
4. [Reglas de Negocio](#4-reglas-de-negocio)
5. [Consultas SQL y Resultados](#5-consultas-sql-y-resultados)

---

## 1. Descripción del Sistema

La Facultad de Ingeniería de la Universidad de San Carlos de Guatemala requiere un sistema de control académico que permita gestionar de manera eficiente la información de su población estudiantil. El sistema contempla el registro de estudiantes, carreras, planes de estudio, cursos, docentes, horarios, salones y asignaciones académicas.

Se diseñó una base de datos relacional normalizada que garantiza la integridad referencial y la consistencia de los datos, implementada en Oracle Database siguiendo los principios de la teoría relacional.

---

### Modelo Conceptual

![Modelo conceptual](img/conceptual.svg)

---

### Modelo Lógico

![Modelo lógico](img/logico.png)

---

### Modelo Relacional

![Modelo relacional (Data Modeler)](img/relacional.png)

---

## 2. Entidades y Atributos

### 2.1 CARRERA

Representa cada una de las carreras universitarias que ofrece la Facultad de Ingeniería. Es la entidad raíz del sistema académico ya que todos los planes, pensums e inscripciones dependen de ella. Existe porque los estudiantes se inscriben en carreras específicas y cada carrera tiene su propio pensum y plan de estudios.

| Atributo | Tipo           | Restricción | Descripción                          |
|----------|----------------|-------------|--------------------------------------|
| CARRERA  | NUMBER(5)      | PK NOT NULL | Código único identificador           |
| NOMBRE   | VARCHAR2(100)  | NOT NULL    | Nombre completo de la carrera        |

---

### 2.2 CURSO

Catálogo general de cursos disponibles en la facultad, independiente de la carrera. Se separó en una entidad propia porque un mismo curso puede pertenecer a múltiples pensums de diferentes carreras, evitando la redundancia de datos.

| Atributo    | Tipo          | Restricción | Descripción                    |
|-------------|---------------|-------------|--------------------------------|
| CODIGOCURSO | NUMBER(5)     | PK NOT NULL | Código único del curso         |
| NOMBRECURSO | VARCHAR2(100) | NOT NULL    | Nombre descriptivo del curso   |

---

### 2.3 CATEDRATICO

Almacena la información de los docentes de la facultad. Es una entidad independiente porque un catedrático puede impartir múltiples cursos en diferentes secciones, años y ciclos, y su información personal no depende de los cursos que imparte.

| Atributo      | Tipo          | Restricción | Descripción                         |
|---------------|---------------|-------------|-------------------------------------|
| CATEDRATICO   | NUMBER(5)     | PK NOT NULL | Código único del catedrático        |
| NOMBRE        | VARCHAR2(100) | NOT NULL    | Nombre completo del docente         |
| SUELDOMENSUAL | NUMBER(10,2)  | NOT NULL    | Sueldo mensual en quetzales         |

---

### 2.4 ESTUDIANTE

Registra a cada estudiante de la facultad con su información personal. Es la entidad central para el control de asignaciones y el seguimiento académico. Se identifica por carnet, que es único por estudiante a nivel de la universidad.

| Atributo        | Tipo          | Restricción | Descripción                               |
|-----------------|---------------|-------------|-------------------------------------------|
| CARNET          | NUMBER(10)    | PK NOT NULL | Número de carnet universitario único      |
| NOMBRE          | VARCHAR2(100) | NOT NULL    | Nombre completo del estudiante            |
| INGRESOFAMILIAR | NUMBER(10,2)  | NOT NULL    | Ingreso familiar mensual en quetzales     |
| FECHANACIMIENTO | DATE          | NOT NULL    | Fecha de nacimiento del estudiante        |

---

### 2.5 DIA

Catálogo de los días de la semana. Se modela como entidad separada para garantizar la integridad referencial en los horarios y permitir que el sistema opere con cualquier convención sin modificar los datos de horarios.

| Atributo  | Tipo         | Restricción | Descripción                              |
|-----------|--------------|-------------|------------------------------------------|
| DIA       | NUMBER(1)    | PK NOT NULL | Número del día (1=Lunes, 7=Domingo)      |
| NOMBREDIA | VARCHAR2(20) | NOT NULL    | Nombre del día de la semana              |

---

### 2.6 PERIODO

Define los bloques de tiempo en que se imparten los cursos. Se separó porque un mismo período puede ser usado por múltiples horarios y secciones, y centraliza la administración de los rangos horarios de la facultad.

| Atributo     | Tipo         | Restricción | Descripción                          |
|--------------|--------------|-------------|--------------------------------------|
| PERIODO      | NUMBER(3)    | PK NOT NULL | Código único del período             |
| HORARIOINICIO| VARCHAR2(10) | NOT NULL    | Hora de inicio (formato HH:MM)       |
| HORARIOFINAL | VARCHAR2(10) | NOT NULL    | Hora de finalización (formato HH:MM) |

---

### 2.7 SALON

Representa los salones físicos donde se imparten los cursos. La clave primaria es compuesta (EDIFICIO + SALON) porque los salones se identifican por su edificio y número dentro del edificio. CAPACIDAD permite controlar que no se sobrepase el límite de estudiantes por aula.

| Atributo  | Tipo         | Restricción | Descripción                              |
|-----------|--------------|-------------|------------------------------------------|
| EDIFICIO  | VARCHAR2(10) | PK NOT NULL | Código del edificio donde se ubica       |
| SALON     | NUMBER(5)    | PK NOT NULL | Número del salón dentro del edificio     |
| CAPACIDAD | NUMBER(5)    | NOT NULL    | Capacidad máxima de estudiantes          |

---

### 2.8 PLAN

Define los planes de estudio de cada carrera, indicando el período de vigencia y los créditos necesarios para el cierre. La PK es compuesta (PLAN + CARRERA) porque el mismo código de plan puede existir en diferentes carreras. Es fundamental para aplicar la Regla 3 de cierre de carrera.

| Atributo           | Tipo         | Restricción    | Descripción                                  |
|--------------------|--------------|----------------|----------------------------------------------|
| PLAN               | VARCHAR2(20) | PK NOT NULL    | Código del plan (ej: DIARIO)                 |
| CARRERA            | NUMBER(5)    | PK FK NOT NULL | Carrera a la que pertenece                   |
| NOMBRE             | VARCHAR2(50) | NOT NULL       | Nombre descriptivo del plan                  |
| ANIOINICIAL        | NUMBER(4)    | NOT NULL       | Año en que inicia la vigencia                |
| CICLOINICIAL       | VARCHAR2(20) | NOT NULL       | Ciclo en que inicia la vigencia              |
| ANIOFINAL          | NUMBER(4)    | NOT NULL       | Año en que finaliza la vigencia              |
| CICLOFINAL         | VARCHAR2(20) | NOT NULL       | Ciclo en que finaliza la vigencia            |
| NUMCREDITOSCIERRE  | NUMBER(5)    | NOT NULL       | Créditos mínimos para cerrar la carrera      |

---

### 2.9 INSCRIPCION

Registra la inscripción formal de un estudiante en una carrera. Es una entidad asociativa entre ESTUDIANTE y CARRERA. Su existencia es necesaria porque un estudiante debe estar inscrito para asignarse cursos, y puede inscribirse en máximo dos carreras simultáneamente.

| Atributo         | Tipo      | Restricción    | Descripción                              |
|------------------|-----------|----------------|------------------------------------------|
| CARRERA          | NUMBER(5) | PK FK NOT NULL | Carrera en la que se inscribe            |
| CARNET           | NUMBER(10)| PK FK NOT NULL | Carnet del estudiante inscrito           |
| FECHAINSCRIPCION | DATE      | NOT NULL       | Fecha en que realizó la inscripción      |

---

### 2.10 PENSUM

Detalla los cursos que conforman el plan de estudios de una carrera específica con sus condiciones de aprobación. Es una entidad de intersección entre CURSO y PLAN que añade atributos propios como obligatoriedad, créditos y notas mínimas. Es la base para aplicar las Reglas 1, 2 y 3.

| Atributo                | Tipo         | Restricción    | Descripción                                        |
|-------------------------|--------------|----------------|----------------------------------------------------|
| CURSO_CODIGOCURSO       | NUMBER(5)    | PK FK NOT NULL | Código del curso en el pensum                      |
| PLAN_PLAN               | VARCHAR2(20) | PK FK NOT NULL | Plan al que pertenece                              |
| PLAN_CARRERA_CARRERA    | NUMBER(5)    | PK FK NOT NULL | Carrera del plan                                   |
| OBLIGATORIEDAD          | NUMBER(1)    | NOT NULL       | 1 = Obligatorio, 0 = Optativo                      |
| NUMCREDITOS             | NUMBER(5)    | NOT NULL       | Créditos que otorga al aprobarse                   |
| NOTAAPROBACION          | NUMBER(5,2)  | NOT NULL       | Nota mínima para aprobar el curso (0-100)          |
| ZONAMINIMA              | NUMBER(5,2)  | NOT NULL       | Zona mínima para tener derecho a examen (0-100)    |
| CREDPRERREQUISITOS      | NUMBER(5)    | NOT NULL       | Créditos totales acumulados mínimos requeridos     |

---

### 2.11 PRERREQUISITO

Registra qué cursos deben haberse aprobado previamente para poder asignarse un curso determinado dentro de un plan y carrera. Se modela como entidad independiente porque la relación de prerrequisito es muchos a muchos: un curso puede tener varios prerrequisitos y un mismo curso puede ser prerrequisito de varios cursos. Es fundamental para la Regla 1.

| Atributo            | Tipo         | Restricción    | Descripción                              |
|---------------------|--------------|----------------|------------------------------------------|
| PENSUM_CARRERA      | NUMBER(5)    | PK FK NOT NULL | Carrera del pensum                       |
| PENSUM_PLAN         | VARCHAR2(20) | PK FK NOT NULL | Plan del pensum                          |
| PENSUM_CURSO        | NUMBER(5)    | PK FK NOT NULL | Curso que tiene el prerrequisito         |
| CURSO_PREREQUISITO  | NUMBER(5)    | PK FK NOT NULL | Curso que debe aprobarse primero         |

---

### 2.12 SECCION

Representa una sección específica de un curso en un año y ciclo determinado, asignada a un catedrático. La PK compuesta (SECCION + ANIO + CICLO + CURSO) permite que existan múltiples secciones del mismo curso en el mismo período (A, B, C…), cada una con su propio docente.

| Atributo                  | Tipo         | Restricción    | Descripción                              |
|---------------------------|--------------|----------------|------------------------------------------|
| SECCION                   | VARCHAR2(5)  | PK NOT NULL    | Código de sección (A, B, C…)            |
| ANIO                      | NUMBER(4)    | PK NOT NULL    | Año en que se imparte                    |
| CICLO                     | VARCHAR2(20) | PK NOT NULL    | Ciclo en que se imparte                  |
| CURSO_CODIGOCURSO         | NUMBER(5)    | PK FK NOT NULL | Curso que se imparte en la sección       |
| CATEDRATICO_CATEDRATICO   | NUMBER(5)    | FK NOT NULL    | Catedrático asignado a la sección        |

---

### 2.13 HORARIO

Define cuándo y dónde se imparte cada sección de un curso: período, día y salón. La PK incluye todos los campos de ubicación temporal porque una misma sección puede impartirse en diferentes días y períodos durante la semana.

| Atributo                    | Tipo         | Restricción    | Descripción                              |
|-----------------------------|--------------|----------------|------------------------------------------|
| SECCION_CURSO_CODIGOCURSO   | NUMBER(5)    | PK FK NOT NULL | Curso de la sección                      |
| SECCION_SECCION             | VARCHAR2(5)  | PK FK NOT NULL | Código de la sección                     |
| SECCION_ANIO                | NUMBER(4)    | PK FK NOT NULL | Año de la sección                        |
| SECCION_CICLO               | VARCHAR2(20) | PK FK NOT NULL | Ciclo de la sección                      |
| PERIODO_PERIODO             | NUMBER(3)    | PK FK NOT NULL | Período en que se imparte                |
| DIA_DIA                     | NUMBER(1)    | PK FK NOT NULL | Día en que se imparte                    |
| SALON_EDIFICIO              | VARCHAR2(10) | FK NOT NULL    | Edificio del salón asignado              |
| SALON_SALON                 | NUMBER(5)    | FK NOT NULL    | Número del salón asignado                |

---

### 2.14 ASIGNACION

Registra la inscripción de un estudiante a una sección específica de un curso, almacenando la zona y nota obtenidas. Es el núcleo del control académico: permite calcular promedios (Regla 2), verificar aprobación (Regla 1) y determinar cierre de carrera (Regla 3). ZONA y NOTA son opcionales (NULL si el ciclo no ha concluido).

| Atributo               | Tipo         | Restricción    | Descripción                              |
|------------------------|--------------|----------------|------------------------------------------|
| ESTUDIANTE_CARNET      | NUMBER(10)   | PK FK NOT NULL | Carnet del estudiante                    |
| SECCION_CODIGOCURSO    | NUMBER(5)    | PK FK NOT NULL | Curso de la sección asignada             |
| SECCION_SECCION        | VARCHAR2(5)  | PK FK NOT NULL | Sección asignada                         |
| SECCION_ANIO           | NUMBER(4)    | PK FK NOT NULL | Año de la sección                        |
| SECCION_CICLO          | VARCHAR2(20) | PK FK NOT NULL | Ciclo de la sección                      |
| ZONA                   | NUMBER(5,2)  | NULL           | Zona obtenida en el curso (0-100)        |
| NOTA                   | NUMBER(5,2)  | NULL           | Nota final obtenida en el curso (0-100)  |

---

## 3. Relaciones entre Entidades

| Relación                  | Cardinalidad | Descripción y Justificación                                                                                                                                   |
|---------------------------|:------------:|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
| CARRERA — PLAN            | 1:N          | Una carrera tiene uno o más planes de estudio. Un plan pertenece a exactamente una carrera. Una carrera puede tener diferentes planes vigentes a lo largo del tiempo. |
| CARRERA — INSCRIPCION     | 1:N          | Una carrera puede tener inscritos a muchos estudiantes. Una inscripción pertenece a una sola carrera. El enunciado permite hasta dos carreras simultáneas por estudiante. |
| ESTUDIANTE — INSCRIPCION  | 1:N          | Un estudiante puede inscribirse en una o dos carreras. Una inscripción pertenece a un solo estudiante.                                                        |
| PLAN — PENSUM             | 1:N          | Un plan contiene muchos cursos en su pensum. Un registro de pensum pertenece a un plan específico. El pensum define las condiciones particulares de cada curso en ese plan. |
| CURSO — PENSUM            | 1:N          | Un curso puede aparecer en múltiples pensums de diferentes carreras y planes. Permite reutilizar el catálogo de cursos sin duplicar información.               |
| PENSUM — PRERREQUISITO    | 1:N          | Un curso del pensum puede tener cero o más prerrequisitos. Necesaria para implementar la Regla 1 de aprobación.                                               |
| CURSO — PRERREQUISITO     | 1:N          | Un curso puede ser prerrequisito de cero o más cursos. Permite modelar la cadena de dependencias académicas.                                                  |
| CURSO — SECCION           | 1:N          | Un curso puede tener múltiples secciones en diferentes años, ciclos y grupos. Una sección pertenece a un solo curso.                                          |
| CATEDRATICO — SECCION     | 1:N          | Un catedrático puede impartir múltiples secciones. Una sección tiene exactamente un catedrático. El enunciado indica que los docentes pueden dar uno o más cursos. |
| SECCION — HORARIO         | 1:N          | Una sección puede tener múltiples entradas de horario (diferentes días y períodos). Permite representar que un curso se imparte varios días a la semana.       |
| PERIODO — HORARIO         | 1:N          | Un período puede utilizarse en múltiples horarios. Un horario ocurre en un solo período.                                                                      |
| DIA — HORARIO             | 1:N          | Un día puede aparecer en múltiples horarios. Un horario ocurre en un solo día.                                                                                |
| SALON — HORARIO           | 1:N          | Un salón puede ser utilizado en múltiples horarios. El enunciado indica que los salones pueden ser usados por uno o más catedráticos.                         |
| ESTUDIANTE — ASIGNACION   | 1:N          | Un estudiante puede tener múltiples asignaciones (una por curso por ciclo). Una asignación pertenece a un solo estudiante.                                    |
| SECCION — ASIGNACION      | 1:N          | Una sección puede tener múltiples estudiantes asignados. Una asignación pertenece a una sola sección.                                                         |

---

## 4. Reglas de Negocio

### Regla 1 — Aprobación de un Curso

Para que un curso sea considerado aprobado deben cumplirse simultáneamente cuatro condiciones:

1. `ZONA >= ZONAMINIMA` del pensum del plan vigente en la asignación.
2. `NOTA >= NOTAAPROBACION` del pensum del plan vigente en la asignación.
3. Todos los cursos prerrequisito (tabla PRERREQUISITO) han sido aprobados previamente.
4. Los créditos totales acumulados aprobados en la carrera `>= CREDPRERREQUISITOS` del curso en ese plan.

> **Nota técnica:** El campo `CREDPRERREQUISITOS` representa un umbral de créditos mínimos acumulados en la carrera. Se verifica sobre el total global (no ciclo por ciclo) porque múltiples cursos del mismo ciclo pueden compartir este requisito. Por ejemplo, los cursos 141–145 están todos en CICLO9/2014; si se verificara estrictamente "antes del mismo ciclo" se excluirían entre sí al calcular los créditos previos.

**Implementación SQL — subconsulta de cierre:**

```sql
-- Condición 1 y 2: zona y nota aprobadas según pensum del plan
WHERE a2.ZONA >= ps2.ZONAMINIMA
  AND a2.NOTA >= ps2.NOTAAPROBACION

-- Condición 3: todos los cursos prerrequisito aprobados
AND NOT EXISTS (
    SELECT 1 FROM PRERREQUISITO pr
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
        WHERE  a_pre.ESTUDIANTE_CARNET    = a2.ESTUDIANTE_CARNET
        AND    a_pre.SECCION_CODIGOCURSO  = pr.CURSO_PREREQUISITO
        AND    a_pre.ZONA >= ps_pre.ZONAMINIMA
        AND    a_pre.NOTA >= ps_pre.NOTAAPROBACION
    )
)

-- Condición 4: créditos totales acumulados >= CREDPRERREQUISITOS
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
```

---

### Regla 2 — Cálculo de Promedio

El promedio de un estudiante se calcula únicamente sobre las notas de los cursos que ha **aprobado**, según los criterios del plan en que fue asignado el curso. Los cursos reprobados (zona < mínima o nota < aprobación) no se incluyen en el cálculo.

**Implementación SQL — WHERE del query principal:**

```sql
-- Solo los cursos aprobados entran al AVG(NOTA)
WHERE a.ZONA >= ps.ZONAMINIMA
  AND a.NOTA >= ps.NOTAAPROBACION

SELECT ROUND(AVG(a.NOTA), 2) AS PROMEDIO,
       SUM(ps.NUMCREDITOS)   AS CREDITOS_GANADOS
```

---

### Regla 3 — Cierre de Carrera

Para que un estudiante sea considerado como cerrado en una carrera deben cumplirse tres condiciones:

1. Aprobó **todos** los cursos obligatorios (`OBLIGATORIEDAD = 1`) del plan.
2. Las aprobaciones ocurrieron dentro del período de vigencia del plan (`ANIOINICIAL/CICLOINICIAL` hasta `ANIOFINAL/CICLOFINAL`). Se permite incluir cursos aprobados en planes anteriores.
3. Los créditos totales acumulados aprobados son `>= NUMCREDITOSCIERRE` del plan.

> **Nota técnica:** Los ciclos se almacenan como texto ('CICLO1'…'CICLO10'). La comparación debe hacerse extrayendo el número con `TO_NUMBER(SUBSTR(campo, 6))`, ya que alfabéticamente `'CICLO10' < 'CICLO2'`, lo que rompería la lógica de vigencia.

**Implementación SQL — HAVING de la subconsulta de cierre:**

```sql
-- Vigencia del plan con comparación numérica de ciclos
AND (
        a2.SECCION_ANIO < pl2.ANIOFINAL
     OR (
            a2.SECCION_ANIO = pl2.ANIOFINAL
        AND TO_NUMBER(SUBSTR(a2.SECCION_CICLO, 6))
                <= TO_NUMBER(SUBSTR(pl2.CICLOFINAL, 6))
        )
)

GROUP BY a2.ESTUDIANTE_CARNET, ps2.PLAN_PLAN,
         ps2.PLAN_CARRERA_CARRERA, pl2.NUMCREDITOSCIERRE

-- Condición a: aprobó TODOS los obligatorios del plan
HAVING COUNT(DISTINCT a2.SECCION_CODIGOCURSO) = (
    SELECT COUNT(*)
    FROM   PENSUM ps3
    WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
    AND    ps3.PLAN_CARRERA_CARRERA = ps2.PLAN_CARRERA_CARRERA
    AND    ps3.OBLIGATORIEDAD       = 1
)
-- Condición c: créditos suficientes para el cierre
AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
```

---

### Regla 4 — Mejor Estudiante de la Promoción

Para que un estudiante sea considerado el mejor de su promoción debe cumplir dos condiciones:

1. Tener el **mayor promedio** (calculado solo sobre notas aprobadas, Regla 2).
2. **No haber perdido ningún curso** (ninguna asignación con zona < mínima o nota < aprobación).

**Implementación SQL:**

```sql
-- Condición b: no perdió ningún curso
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

-- Condición a: promedio máximo entre los candidatos sin pérdidas
HAVING ROUND(AVG(a.NOTA), 2) = (
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
            SELECT 1 FROM ASIGNACION a_p
            JOIN PENSUM ps_p ON ps_p.CURSO_CODIGOCURSO    = a_p.SECCION_CODIGOCURSO
                            AND ps_p.PLAN_CARRERA_CARRERA  = 9
            WHERE a_p.ESTUDIANTE_CARNET = a_i.ESTUDIANTE_CARNET
            AND (a_p.ZONA < ps_p.ZONAMINIMA OR a_p.NOTA < ps_p.NOTAAPROBACION)
        )
        GROUP BY a_i.ESTUDIANTE_CARNET
    )
)
```

---

## 5. Consultas SQL y Resultados

### Consulta 1 — Estudiantes que Cerraron Ingeniería en Ciencias y Sistemas

Retorna el nombre del estudiante, su promedio (calculado solo sobre notas aprobadas) y el número de créditos ganados, para todos los estudiantes que han cerrado la carrera de Ingeniería en Ciencias y Sistemas (código 9). Aplica Reglas 1, 2 y 3.

```sql
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
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    AND (
            a.SECCION_ANIO < pl.ANIOFINAL
         OR (
                a.SECCION_ANIO = pl.ANIOFINAL
            AND TO_NUMBER(SUBSTR(a.SECCION_CICLO, 6))
                    <= TO_NUMBER(SUBSTR(pl.CICLOFINAL, 6))
            )
    )
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
            AND NOT EXISTS (
                SELECT 1 FROM PRERREQUISITO pr
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
                    WHERE  a_pre.ESTUDIANTE_CARNET    = a2.ESTUDIANTE_CARNET
                    AND    a_pre.SECCION_CODIGOCURSO  = pr.CURSO_PREREQUISITO
                    AND    a_pre.ZONA >= ps_pre.ZONAMINIMA
                    AND    a_pre.NOTA >= ps_pre.NOTAAPROBACION
                )
            )
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
            COUNT(DISTINCT a2.SECCION_CODIGOCURSO) = (
                SELECT COUNT(*) FROM PENSUM ps3
                WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
                AND    ps3.PLAN_CARRERA_CARRERA  = 9
                AND    ps3.OBLIGATORIEDAD        = 1
            )
            AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
    )
GROUP BY e.CARNET, e.NOMBRE
ORDER BY PROMEDIO DESC;
```

**Resultado:**

| NOMBRE_ESTUDIANTE | PROMEDIO | CREDITOS_GANADOS |
|-------------------|:--------:|:----------------:|
| ESTUDIANTE 1001   | 83.22    | 250              |

![Resultado de la Consulta 1](img/consulta1.png)

---

### Consulta 2 — Estudiantes que Cerraron en Cualquier Carrera

Retorna el nombre del estudiante, nombre de la carrera, promedio y créditos ganados para todos los estudiantes que han cerrado en alguna carrera, independientemente de si están actualmente inscritos en ella. No filtra por carrera específica ni requiere existencia en INSCRIPCION. Aplica Reglas 1, 2 y 3.

```sql
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
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    AND (
            a.SECCION_ANIO < pl.ANIOFINAL
         OR (
                a.SECCION_ANIO = pl.ANIOFINAL
            AND TO_NUMBER(SUBSTR(a.SECCION_CICLO, 6))
                    <= TO_NUMBER(SUBSTR(pl.CICLOFINAL, 6))
            )
    )
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
            AND NOT EXISTS (
                SELECT 1 FROM PRERREQUISITO pr
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
                    WHERE  a_pre.ESTUDIANTE_CARNET    = a2.ESTUDIANTE_CARNET
                    AND    a_pre.SECCION_CODIGOCURSO  = pr.CURSO_PREREQUISITO
                    AND    a_pre.ZONA >= ps_pre.ZONAMINIMA
                    AND    a_pre.NOTA >= ps_pre.NOTAAPROBACION
                )
            )
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
                SELECT COUNT(*) FROM PENSUM ps3
                WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
                AND    ps3.PLAN_CARRERA_CARRERA  = ps2.PLAN_CARRERA_CARRERA
                AND    ps3.OBLIGATORIEDAD        = 1
            )
            AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
    )
GROUP BY e.CARNET, e.NOMBRE, c.CARRERA, c.NOMBRE
ORDER BY c.NOMBRE, PROMEDIO DESC;
```

**Resultado:**

| NOMBRE_ESTUDIANTE | NOMBRE_CARRERA                    | PROMEDIO | CREDITOS_GANADOS |
|-------------------|-----------------------------------|:--------:|:----------------:|
| ESTUDIANTE 1001   | INGENIERIA EN CIENCIAS Y SISTEMAS | 83.22    | 250              |

![Resultado de la Consulta 2](img/consulta2.png)

---

### Consulta 3 — Estudiantes con Catedráticos de Sistemas del Semestre Pasado

Retorna los nombres de los estudiantes que han ganado (aprobado) algún curso con alguno de los catedráticos que impartieron cursos de la carrera de Sistemas (carrera 9) en el semestre pasado.

**Interpretación de "semestre pasado":** el último año completo registrado en el plan vigente es el año 2014 con los ciclos CICLO9 y CICLO10. La consulta primero identifica los catedráticos que impartieron cursos del pensum de Sistemas en ese período, y luego busca los estudiantes que aprobaron cualquier curso con esos mismos docentes. Aplica Regla 1 (condiciones a y b).

```sql
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
    a.ZONA >= ps.ZONAMINIMA
    AND a.NOTA >= ps.NOTAAPROBACION
    AND sec.CATEDRATICO_CATEDRATICO IN (
        SELECT DISTINCT sec2.CATEDRATICO_CATEDRATICO
        FROM   SECCION sec2
               JOIN PENSUM ps2
                   ON  ps2.CURSO_CODIGOCURSO    = sec2.CURSO_CODIGOCURSO
                   AND ps2.PLAN_CARRERA_CARRERA  = 9
        WHERE  sec2.ANIO = 2014
        AND    sec2.CICLO IN ('CICLO9', 'CICLO10')
    )
ORDER BY e.NOMBRE;
```

**Resultado:**

| NOMBRE_ESTUDIANTE |
|-------------------|
| ESTUDIANTE 1001   |

![Resultado de la Consulta 3](img/consulta3.png)

---

### Consulta 4 — Estudiantes que Llevaron Todos los Cursos con el Estudiante de Referencia

Para un estudiante determinado que ha cerrado en alguna carrera, retorna el nombre de todos los estudiantes que "llevaron con él" todos los cursos, es decir, que tienen asignación en exactamente las mismas secciones (mismo curso, sección, año y ciclo) que el estudiante de referencia.

**Técnica utilizada:** división relacional con doble `NOT EXISTS`. Busca estudiantes para quienes no exista ningún curso que llevó el de referencia y que ellos no hayan llevado también. Incluye dos guardas previas: verificar que el estudiante de referencia tiene asignaciones y que efectivamente cerró carrera, para evitar el resultado vacío falso que ocurre cuando el conjunto de referencia está vacío.

```sql
SELECT
    e.NOMBRE    AS NOMBRE_ESTUDIANTE
FROM
    ESTUDIANTE e
WHERE
    e.CARNET <> 1001    -- sustituir por el carnet del estudiante de referencia

    -- Guarda 1: el estudiante de referencia tiene asignaciones
    AND EXISTS (
        SELECT 1 FROM ASIGNACION
        WHERE  ESTUDIANTE_CARNET = 1001
    )

    -- Guarda 2: el estudiante de referencia cerró alguna carrera (Regla 3)
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
        GROUP BY a2.ESTUDIANTE_CARNET, ps2.PLAN_PLAN,
                 ps2.PLAN_CARRERA_CARRERA, pl2.NUMCREDITOSCIERRE
        HAVING
            COUNT(DISTINCT a2.SECCION_CODIGOCURSO) = (
                SELECT COUNT(*) FROM PENSUM ps3
                WHERE  ps3.PLAN_PLAN            = ps2.PLAN_PLAN
                AND    ps3.PLAN_CARRERA_CARRERA  = ps2.PLAN_CARRERA_CARRERA
                AND    ps3.OBLIGATORIEDAD        = 1
            )
            AND SUM(ps2.NUMCREDITOS) >= pl2.NUMCREDITOSCIERRE
    )

    -- Condición principal: división relacional (doble NOT EXISTS)
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
ORDER BY e.NOMBRE;
```

**Resultado con datos originales:** sin filas — ningún otro estudiante tiene asignaciones cargadas.

**Resultado con datos de verificación** (carnet 1002 con los 50 cursos cargados):

| NOMBRE_ESTUDIANTE |
|-------------------|
| ESTUDIANTE 1002   |

---

