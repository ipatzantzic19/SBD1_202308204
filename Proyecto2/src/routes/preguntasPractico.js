import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.PREGUNTAS_PRACTICO ORDER BY id_pregunta_practico');
    const resultado = r.rows.map(row => ({
      id_pregunta_practico: row[0],
      pregunta_texto: row[1],
      punteo: row[2]
    }));
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.PREGUNTAS_PRACTICO WHERE id_pregunta_practico = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    const row = r.rows[0];
    res.json({
      id_pregunta_practico: row[0],
      pregunta_texto: row[1],
      punteo: row[2]
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { pregunta_texto, punteo } = req.body;
  if (!pregunta_texto || punteo === undefined) return res.status(400).json({ error: 'pregunta_texto y punteo son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO EVALUACION.PREGUNTAS_PRACTICO (pregunta_texto, punteo) VALUES (:texto, :punteo)
       RETURNING id_pregunta_practico INTO :id`,
      { texto: pregunta_texto, punteo, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_pregunta_practico: r.outBinds.id[0], pregunta_texto, punteo });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { pregunta_texto, punteo } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'UPDATE EVALUACION.PREGUNTAS_PRACTICO SET pregunta_texto = :texto, punteo = :punteo WHERE id_pregunta_practico = :id',
      { texto: pregunta_texto, punteo, id: parseInt(req.params.id) }, { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM EVALUACION.PREGUNTAS_PRACTICO WHERE id_pregunta_practico = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;