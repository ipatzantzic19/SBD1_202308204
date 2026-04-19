import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM PREGUNTAS ORDER BY id_pregunta');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM PREGUNTAS WHERE id_pregunta = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta } = req.body;
  if (!pregunta_texto || !respuesta_correcta) return res.status(400).json({ error: 'Faltan campos requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO PREGUNTAS (pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta)
       VALUES (:texto, :a, :b, :c, :d, :correcta) RETURNING id_pregunta INTO :id`,
      { texto: pregunta_texto, a: respuesta_a, b: respuesta_b, c: respuesta_c, d: respuesta_d,
        correcta: respuesta_correcta, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_pregunta: r.outBinds.id[0], ...req.body });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { pregunta_texto, respuesta_a, respuesta_b, respuesta_c, respuesta_d, respuesta_correcta } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `UPDATE PREGUNTAS SET pregunta_texto = :texto, respuesta_a = :a, respuesta_b = :b,
        respuesta_c = :c, respuesta_d = :d, respuesta_correcta = :correcta WHERE id_pregunta = :id`,
      { texto: pregunta_texto, a: respuesta_a, b: respuesta_b, c: respuesta_c, d: respuesta_d,
        correcta: respuesta_correcta, id: parseInt(req.params.id) }, { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM PREGUNTAS WHERE id_pregunta = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;