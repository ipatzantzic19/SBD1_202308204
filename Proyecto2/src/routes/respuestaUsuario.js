import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(`
      SELECT ru.*, p.pregunta_texto, p.respuesta_correcta,
             CASE WHEN ru.respuesta = p.respuesta_correcta THEN 'CORRECTO' ELSE 'INCORRECTO' END AS resultado
      FROM RESPUESTA_USUARIO ru
      JOIN PREGUNTAS p ON ru.pregunta_id_pregunta = p.id_pregunta
      ORDER BY ru.id_respuesta_usuario
    `);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM RESPUESTA_USUARIO WHERE id_respuesta_usuario = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { pregunta_id_pregunta, examen_id_examen, respuesta } = req.body;
  if (!pregunta_id_pregunta || !examen_id_examen || !respuesta)
    return res.status(400).json({ error: 'pregunta_id_pregunta, examen_id_examen y respuesta son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO RESPUESTA_USUARIO (pregunta_id_pregunta, examen_id_examen, respuesta)
       VALUES (:preg, :exam, :resp) RETURNING id_respuesta_usuario INTO :id`,
      { preg: pregunta_id_pregunta, exam: examen_id_examen, resp: respuesta,
        id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_respuesta_usuario: r.outBinds.id[0], pregunta_id_pregunta, examen_id_examen, respuesta });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { respuesta } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'UPDATE RESPUESTA_USUARIO SET respuesta = :resp WHERE id_respuesta_usuario = :id',
      { resp: respuesta, id: parseInt(req.params.id) }, { autoCommit: true }
    );
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Actualizado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.delete('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('DELETE FROM RESPUESTA_USUARIO WHERE id_respuesta_usuario = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;