import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();
// GET todos
router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EVALUACION.MUNICIPIO ORDER BY id_municipio');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});
// Obtener un municipio por id
router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'SELECT * FROM EVALUACION.MUNICIPIO WHERE id_municipio = :id',
      { id: parseInt(req.params.id) }
    );
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    const row = r.rows[0];
    res.json({
      id_municipio: row[0],
      nombre: row[1],
      codigo: row[2],
      departamento_id_departamento: row[3]
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});
// Crear un nuevo municipio
router.post('/', async (req, res) => {
  let conn;
  const { nombre, codigo, departamento_id_departamento } = req.body;
  if (!nombre || !codigo || !departamento_id_departamento)
    return res.status(400).json({ error: 'nombre, codigo y departamento_id_departamento son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO EVALUACION.MUNICIPIO (nombre, codigo, departamento_id_departamento)
       VALUES (:nombre, :codigo, :dep_id) RETURNING id_municipio INTO :id`,
      { nombre, codigo, dep_id: departamento_id_departamento,
        id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      { autoCommit: true }
    );
    res.status(201).json({ id_municipio: r.outBinds.id[0], nombre, codigo, departamento_id_departamento });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});
// Actualizar un municipio por id
router.put('/:id', async (req, res) => {
  let conn;
  const { nombre, codigo, departamento_id_departamento } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `UPDATE EVALUACION.MUNICIPIO SET nombre = :nombre, codigo = :codigo,
       departamento_id_departamento = :dep_id WHERE id_municipio = :id`,
      { nombre, codigo, dep_id: departamento_id_departamento, id: parseInt(req.params.id) },
      { autoCommit: true }
    );
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Actualizado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});
// Eliminar un municipio por id
router.delete('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'DELETE FROM EVALUACION.MUNICIPIO WHERE id_municipio = :id',
      { id: parseInt(req.params.id) }, { autoCommit: true }
    );
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;