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
      SELECT
        c.nombre                                    AS CENTRO,
        e.nombre                                    AS ESCUELA,
        COUNT(DISTINCT ex.id_examen)                AS TOTAL_EXAMENES,
        ROUND(AVG(teorico.pct), 2)                  AS PROMEDIO_TEORICO_PCT,
        ROUND(AVG(practico.suma_nota), 2)           AS PROMEDIO_PRACTICO,
        SUM(CASE WHEN (NVL(teorico.pct,0) + NVL(practico.suma_nota,0)) >= 60 THEN 1 ELSE 0 END) AS APROBADOS
      FROM EVALUACION.EXAMEN ex
      JOIN EVALUACION.CENTRO  c ON ex.registro_id_centro  = c.id_centro
      JOIN EVALUACION.ESCUELA e ON ex.registro_id_escuela = e.id_escuela
      LEFT JOIN (
        SELECT
          ru.examen_id_examen,
          ROUND(
            SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) * 100.0
            / NULLIF(COUNT(*), 0), 2
          ) AS pct
        FROM EVALUACION.RESPUESTA_USUARIO ru
        JOIN EVALUACION.PREGUNTAS p ON p.id_pregunta = ru.pregunta_id_pregunta
        GROUP BY ru.examen_id_examen
      ) teorico ON teorico.examen_id_examen = ex.id_examen
      LEFT JOIN (
        SELECT examen_id_examen, SUM(nota) AS suma_nota
        FROM EVALUACION.RESPUESTA_PRACTICO_USUARIO
        GROUP BY examen_id_examen
      ) practico ON practico.examen_id_examen = ex.id_examen
      GROUP BY c.nombre, e.nombre
      ORDER BY c.nombre, e.nombre
    `);
    
    // Transformar a objetos con nombres de campo
    const resultado = r.rows.map(row => ({
      centro: row[0],
      escuela: row[1],
      total_examenes: row[2],
      promedio_teorico_pct: row[3],
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
      SELECT
        RANK() OVER (ORDER BY (puntaje_teorico + puntaje_practico) DESC) AS RANKING,
        nombre_completo,
        ROUND(puntaje_teorico, 2)                            AS PUNTAJE_TEORICO,
        ROUND(puntaje_practico, 2)                           AS PUNTAJE_PRACTICO,
        ROUND(puntaje_teorico + puntaje_practico, 2)         AS PUNTAJE_TOTAL,
        CASE
          WHEN (puntaje_teorico + puntaje_practico) >= 60 THEN 'APROBADO'
          ELSE 'REPROBADO'
        END                                                  AS RESULTADO
      FROM (
        SELECT
          reg.nombre_completo,
          NVL((
            SELECT ROUND(
              SUM(CASE WHEN ru.respuesta = p.respuesta_correcta THEN 1 ELSE 0 END) * 100.0
              / NULLIF(COUNT(*), 0), 2)
            FROM EVALUACION.RESPUESTA_USUARIO ru
            JOIN EVALUACION.PREGUNTAS p ON p.id_pregunta = ru.pregunta_id_pregunta
            WHERE ru.examen_id_examen = ex.id_examen
          ), 0) AS puntaje_teorico,
          NVL((
            SELECT SUM(nota)
            FROM EVALUACION.RESPUESTA_PRACTICO_USUARIO
            WHERE examen_id_examen = ex.id_examen
          ), 0) AS puntaje_practico
        FROM EVALUACION.REGISTRO reg
        JOIN EVALUACION.EXAMEN ex ON ex.registro_id_registro = reg.id_registro
      )
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