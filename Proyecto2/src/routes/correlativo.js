import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.CORRELATIVO ORDER BY id_correlativo');
    const resultado = r.rows.map(row => ({
      id_correlativo: row[0],
      fecha: row[1],
      no_examen: row[2]
    }));
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.CORRELATIVO WHERE id_correlativo = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    const row = r.rows[0];
    res.json({
      id_correlativo: row[0],
      fecha: row[1],
      no_examen: row[2]
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { fecha, no_examen } = req.body;
  if (!fecha || no_examen === undefined) return res.status(400).json({ error: 'fecha y no_examen son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO EVALUACION.CORRELATIVO (fecha, no_examen) VALUES (TO_DATE(:fecha,'YYYY-MM-DD'), :no_examen)
       RETURNING id_correlativo INTO :id`,
      { fecha, no_examen, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_correlativo: r.outBinds.id[0], fecha, no_examen });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { fecha, no_examen } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `UPDATE EVALUACION.CORRELATIVO SET fecha = TO_DATE(:fecha,'YYYY-MM-DD'), no_examen = :no_examen
       WHERE id_correlativo = :id`,
      { fecha, no_examen, id: parseInt(req.params.id) }, { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM EVALUACION.CORRELATIVO WHERE id_correlativo = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;