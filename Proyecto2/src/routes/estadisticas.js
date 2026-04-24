import oracledb from 'oracledb';
import { Router } from 'express';
import { getConnection } from '../config/db.js';
const router = Router();

// ============================================================
// CONSULTA 1: Estadísticas de evaluaciones por centro y escuela
// Muestra: total exámenes, promedio teórico, promedio práctico, aprobados
// ============================================================
router.get('/por-centro', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(`
      WITH teorico AS (
        SELECT
          ru.examen_id_examen,
          SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 4 ELSE 0 END) AS puntaje_teorico
        FROM EVALUACION.RESPUESTA_USUARIO ru
        JOIN EVALUACION.PREGUNTAS p ON p.id_pregunta = ru.pregunta_id_pregunta
        GROUP BY ru.examen_id_examen
      ),
      practico AS (
        SELECT
          examen_id_examen,
          SUM(nota) AS puntaje_practico
        FROM EVALUACION.RESPUESTA_PRACTICO_USUARIO
        GROUP BY examen_id_examen
      )
      SELECT
        c.nombre AS CENTRO,
        e.nombre AS ESCUELA,
        COUNT(*) AS TOTAL_EXAMENES,
        ROUND(AVG(NVL(t.puntaje_teorico, 0)), 2) AS PROMEDIO_TEORICO,
        ROUND(AVG(NVL(pr.puntaje_practico, 0)), 2) AS PROMEDIO_PRACTICO,
        SUM(CASE WHEN (NVL(t.puntaje_teorico, 0) + NVL(pr.puntaje_practico, 0)) >= 70 THEN 1 ELSE 0 END) AS APROBADOS
      FROM EVALUACION.EXAMEN ex
      JOIN EVALUACION.CENTRO c ON c.id_centro = ex.registro_id_centro
      JOIN EVALUACION.ESCUELA e ON e.id_escuela = ex.registro_id_escuela
      LEFT JOIN teorico t ON t.examen_id_examen = ex.id_examen
      LEFT JOIN practico pr ON pr.examen_id_examen = ex.id_examen
      GROUP BY c.nombre, e.nombre
      ORDER BY c.nombre, e.nombre
    `);
    
    // Transformar a objetos con nombres de campo
    const resultado = r.rows.map(row => ({
      centro: row[0],
      escuela: row[1],
      total_examenes: row[2],
      promedio_teorico: row[3],
      promedio_practico: row[4],
      aprobados: row[5]
    }));
    
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

// ============================================================
// CONSULTA 2: Ranking de evaluados por resultado final
// Ordena de mayor a menor puntaje total (teórico + práctico)
// ============================================================
router.get('/ranking', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(`
      WITH teorico AS (
        SELECT
          ru.examen_id_examen,
          SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 4 ELSE 0 END) AS puntaje_teorico
        FROM EVALUACION.RESPUESTA_USUARIO ru
        JOIN EVALUACION.PREGUNTAS p ON p.id_pregunta = ru.pregunta_id_pregunta
        GROUP BY ru.examen_id_examen
      ),
      practico AS (
        SELECT
          examen_id_examen,
          SUM(nota) AS puntaje_practico
        FROM EVALUACION.RESPUESTA_PRACTICO_USUARIO
        GROUP BY examen_id_examen
      )
      SELECT
        RANK() OVER (ORDER BY (NVL(t.puntaje_teorico, 0) + NVL(pr.puntaje_practico, 0)) DESC) AS RANKING,
        reg.nombre_completo,
        ROUND(NVL(t.puntaje_teorico, 0), 2)                  AS PUNTAJE_TEORICO,
        ROUND(NVL(pr.puntaje_practico, 0), 2)                AS PUNTAJE_PRACTICO,
        ROUND(NVL(t.puntaje_teorico, 0) + NVL(pr.puntaje_practico, 0), 2) AS PUNTAJE_TOTAL,
        CASE
          WHEN (NVL(t.puntaje_teorico, 0) + NVL(pr.puntaje_practico, 0)) >= 70 THEN 'APROBADO'
          ELSE 'REPROBADO'
        END                                                  AS RESULTADO
      FROM EVALUACION.EXAMEN ex
      JOIN EVALUACION.REGISTRO reg ON reg.id_registro = ex.registro_id_registro
      LEFT JOIN teorico t ON t.examen_id_examen = ex.id_examen
      LEFT JOIN practico pr ON pr.examen_id_examen = ex.id_examen
      ORDER BY RANKING
    `);
    
    // Transformar a objetos con nombres de campo
    const resultado = r.rows.map(row => ({
      ranking: row[0],
      nombre_completo: row[1],
      puntaje_teorico: row[2],
      puntaje_practico: row[3],
      puntaje_total: row[4],
      resultado: row[5]
    }));
    
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

// ============================================================
// CONSULTA 3: Pregunta teórica con menor porcentaje de aciertos
// Incluye porcentaje de aciertos en la salida
// ============================================================
router.get('/pregunta-menor-aciertos', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(`
      SELECT *
      FROM (
        SELECT
          p.id_pregunta,
          p.pregunta_texto,
          p.respuesta_correcta,
          COUNT(*)                                                             AS TOTAL_RESPUESTAS,
          SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) AS ACIERTOS,
          ROUND(
            SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) * 100.0
            / COUNT(*), 2
          )                                                                    AS PORCENTAJE_ACIERTOS
        FROM EVALUACION.PREGUNTAS p
        JOIN EVALUACION.RESPUESTA_USUARIO ru ON ru.pregunta_id_pregunta = p.id_pregunta
        GROUP BY p.id_pregunta, p.pregunta_texto, p.respuesta_correcta
        ORDER BY PORCENTAJE_ACIERTOS ASC
      )
      WHERE ROWNUM = 1
    `);
    if (!r.rows.length)
      return res.json({ message: 'No hay respuestas registradas aún' });
    
    // Transformar a objeto con nombres de campo
    const row = r.rows[0];
    const resultado = {
      id_pregunta: row[0],
      pregunta_texto: row[1],
      respuesta_correcta: row[2],
      total_respuestas: row[3],
      aciertos: row[4],
      porcentaje_aciertos: row[5]
    };
    
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;