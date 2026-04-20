import oracledb from 'oracledb';
import { Router } from 'express';
import { getConnection } from '../config/db.js';
const router = Router();

router.get('/', async (_req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `SELECT u.*, e.nombre AS escuela_nombre, c.nombre AS centro_nombre
       FROM EVALUACION.UBICACION u
       JOIN EVALUACION.ESCUELA e ON u.escuela_id_escuela = e.id_escuela
       JOIN EVALUACION.CENTRO  c ON u.centro_id_centro   = c.id_centro`
    );
    const resultado = r.rows.map(row => ({
      escuela_id_escuela: row[0],
      centro_id_centro: row[1],
      escuela_nombre: row[2],
      centro_nombre: row[3]
    }));
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.post('/', async (req, res) => {
  let conn;
  const { escuela_id_escuela, centro_id_centro } = req.body;
  if (!escuela_id_escuela || !centro_id_centro)
    return res.status(400).json({ error: 'escuela_id_escuela y centro_id_centro son requeridos' });
  try {
    conn = await getConnection();
    await conn.execute(
      'INSERT INTO EVALUACION.UBICACION (escuela_id_escuela, centro_id_centro) VALUES (:esc, :cen)',
      { esc: escuela_id_escuela, cen: centro_id_centro }, { autoCommit: true }
    );
    res.status(201).json({ escuela_id_escuela, centro_id_centro });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

router.delete('/', async (req, res) => {
  let conn;
  const { escuela_id_escuela, centro_id_centro } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'DELETE FROM EVALUACION.UBICACION WHERE escuela_id_escuela = :esc AND centro_id_centro = :cen',
      { esc: escuela_id_escuela, cen: centro_id_centro }, { autoCommit: true }
    );
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;