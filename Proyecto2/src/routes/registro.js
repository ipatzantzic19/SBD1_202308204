import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM REGISTRO ORDER BY id_registro');
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM REGISTRO WHERE id_registro = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const {
    ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
    municipio_id_municipio, municipio_departamento_id_departamento,
    fecha, tipo_tramite, tipo_licencia, nombre_completo, genero
  } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO REGISTRO (ubicacion_escuela_id_escuela, ubicacion_centro_id_centro,
        municipio_id_municipio, municipio_departamento_id_departamento,
        fecha, tipo_tramite, tipo_licencia, nombre_completo, genero)
       VALUES (:esc, :cen, :mun, :dep, TO_DATE(:fecha,'YYYY-MM-DD'), :tramite, :licencia, :nombre, :genero)
       RETURNING id_registro INTO :id`,
      {
        esc: ubicacion_escuela_id_escuela, cen: ubicacion_centro_id_centro,
        mun: municipio_id_municipio, dep: municipio_departamento_id_departamento,
        fecha, tramite: tipo_tramite, licencia: tipo_licencia,
        nombre: nombre_completo, genero,
        id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
      },
      { autoCommit: true }
    );
    res.status(201).json({ id_registro: r.outBinds.id[0], ...req.body });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.put('/:id', async (req, res) => {
  let conn;
  const { nombre_completo, tipo_licencia, genero } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `UPDATE REGISTRO SET nombre_completo = :nombre, tipo_licencia = :licencia, genero = :genero
       WHERE id_registro = :id`,
      { nombre: nombre_completo, licencia: tipo_licencia, genero, id: parseInt(req.params.id) },
      { autoCommit: true }
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
    const r = await conn.execute('DELETE FROM REGISTRO WHERE id_registro = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;