import oracledb from 'oracledb';
// ── centro.js ───────────────────────────────
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM CENTRO ORDER BY id_centro');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM CENTRO WHERE id_centro = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { nombre } = req.body;
  if (!nombre) return res.status(400).json({ error: 'nombre es requerido' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO CENTRO (nombre) VALUES (:nombre) RETURNING id_centro INTO :id`,
      { nombre, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_centro: r.outBinds.id[0], nombre });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { nombre } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'UPDATE CENTRO SET nombre = :nombre WHERE id_centro = :id',
      { nombre, id: parseInt(req.params.id) }, { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM CENTRO WHERE id_centro = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;