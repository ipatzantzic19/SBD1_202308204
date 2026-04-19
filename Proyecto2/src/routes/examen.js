import oracledb from 'oracledb';
import { Router } from 'express';

import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(`
      SELECT ex.*, r.nombre_completo, c.nombre AS centro_nombre, e.nombre AS escuela_nombre
      FROM EXAMEN ex
      JOIN REGISTRO r ON ex.registro_id_registro = r.id_registro
      JOIN CENTRO   c ON ex.registro_id_centro   = c.id_centro
      JOIN ESCUELA  e ON ex.registro_id_escuela  = e.id_escuela
      ORDER BY ex.id_examen
    `);
    res.json(r.rows);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('SELECT * FROM EXAMEN WHERE id_examen = :id', { id: parseInt(req.params.id) });
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    res.json(r.rows[0]);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const {
    registro_id_registro, correlativo_id_correlativo,
    registro_id_escuela, registro_id_centro,
    registro_municipio_id_municipio, registro_municipio_departamento_id_departamento
  } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO EXAMEN (registro_id_registro, correlativo_id_correlativo,
        registro_id_escuela, registro_id_centro, registro_municipio_id_municipio,
        registro_municipio_departamento_id_departamento)
       VALUES (:reg, :cor, :esc, :cen, :mun, :dep)
       RETURNING id_examen INTO :id`,
      {
        reg: registro_id_registro, cor: correlativo_id_correlativo,
        esc: registro_id_escuela, cen: registro_id_centro,
        mun: registro_municipio_id_municipio, dep: registro_municipio_departamento_id_departamento,
        id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER }
      },
      { autoCommit: true }
    );
    res.status(201).json({ id_examen: r.outBinds.id[0], ...req.body });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.delete('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute('DELETE FROM EXAMEN WHERE id_examen = :id', { id: parseInt(req.params.id) }, { autoCommit: true });
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;