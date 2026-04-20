import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.ESCUELA ORDER BY id_escuela');
    const resultado = r.rows.map(row => ({
      id_escuela: row[0],
      nombre: row[1],
      direccion: row[2],
      acuerdo: row[3]
    }));
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.ESCUELA WHERE id_escuela = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    const row = r.rows[0];
    res.json({
      id_escuela: row[0],
      nombre: row[1],
      direccion: row[2],
      acuerdo: row[3]
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { nombre, direccion, acuerdo } = req.body;
  if (!nombre || !acuerdo) return res.status(400).json({ error: 'nombre y acuerdo son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO EVALUACION.ESCUELA (nombre, direccion, acuerdo) VALUES (:nombre, :direccion, :acuerdo)
       RETURNING id_escuela INTO :id`,
      { nombre, direccion: direccion || null, acuerdo, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_escuela: r.outBinds.id[0], nombre, direccion, acuerdo });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { nombre, direccion, acuerdo } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'UPDATE EVALUACION.ESCUELA SET nombre = :nombre, direccion = :direccion, acuerdo = :acuerdo WHERE id_escuela = :id',
      { nombre, direccion, acuerdo, id: parseInt(req.params.id) }, { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM EVALUACION.ESCUELA WHERE id_escuela = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;