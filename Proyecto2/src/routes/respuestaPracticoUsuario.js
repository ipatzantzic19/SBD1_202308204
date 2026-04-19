import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(`
      SELECT rpu.*, pp.pregunta_texto, pp.punteo AS punteo_maximo
      FROM RESPUESTA_PRACTICO_USUARIO rpu
      JOIN PREGUNTAS_PRACTICO pp ON rpu.pregunta_practico_id_pregunta_practico = pp.id_pregunta_practico
      ORDER BY rpu.id_respuesta_practico_usuario
    `);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM RESPUESTA_PRACTICO_USUARIO WHERE id_respuesta_practico_usuario = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { pregunta_practico_id_pregunta_practico, examen_id_examen, nota } = req.body;
  if (!pregunta_practico_id_pregunta_practico || !examen_id_examen || nota === undefined)
    return res.status(400).json({ error: 'pregunta_practico_id_pregunta_practico, examen_id_examen y nota son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO RESPUESTA_PRACTICO_USUARIO (pregunta_practico_id_pregunta_practico, examen_id_examen, nota)
       VALUES (:preg, :exam, :nota) RETURNING id_respuesta_practico_usuario INTO :id`,
      { preg: pregunta_practico_id_pregunta_practico, exam: examen_id_examen, nota,
        id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_respuesta_practico_usuario: r.outBinds.id[0], pregunta_practico_id_pregunta_practico, examen_id_examen, nota });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { nota } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'UPDATE RESPUESTA_PRACTICO_USUARIO SET nota = :nota WHERE id_respuesta_practico_usuario = :id',
      { nota, id: parseInt(req.params.id) }, { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM RESPUESTA_PRACTICO_USUARIO WHERE id_respuesta_practico_usuario = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;