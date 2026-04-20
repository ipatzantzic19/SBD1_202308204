import oracledb from 'oracledb';

import { Router } from 'express';

import { getConnection } from '../config/db.js';

const router = Router(); 

// GET todos
router.get('/', async (_req, res) => {
  let conn;
  try {
    // Obtener conexión a la base de datos
    conn = await getConnection();
    // Ejecutar consulta para obtener todos los departamentos ordenados por id_departamento
    const r = await conn.execute('SELECT * FROM EVALUACION.DEPARTAMENTO ORDER BY id_departamento');
    // Devolver resultados como JSON
    const resultado = r.rows.map(row => ({
      id_departamento: row[0],
      nombre: row[1],
      codigo: row[2]
    }));
    res.json(resultado);
  } catch (err) { res.status(500).json({ error: err.message }); }
  // Asegurar que la conexión se cierre después de la operación
  finally { if (conn) await conn.close(); }
});

// GET por id
router.get('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute( 
      'SELECT * FROM EVALUACION.DEPARTAMENTO WHERE id_departamento = :id',
      { id: parseInt(req.params.id) } 
    );
    // Si no se encuentra el departamento, devolver error 404
    if (!r.rows.length) return res.status(404).json({ error: 'No encontrado' });
    // Devolver el departamento encontrado como JSON
    const row = r.rows[0];
    res.json({
      id_departamento: row[0],
      nombre: row[1],
      codigo: row[2]
    });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

// POST crear
router.post('/', async (req, res) => {
  let conn;
  // Extraer nombre y codigo del cuerpo de la solicitud
  const { nombre, codigo } = req.body;
  if (!nombre || !codigo) return res.status(400).json({ error: 'nombre y codigo son requeridos' });
  try {
    conn = await getConnection();
    const r = await conn.execute(
      `INSERT INTO EVALUACION.DEPARTAMENTO (nombre, codigo) VALUES (:nombre, :codigo)
       RETURNING id_departamento INTO :id`,
       // Usar oracledb.BIND_OUT para obtener el id generado automáticamente después de la inserción
      { nombre, codigo, id: { dir: oracledb.BIND_OUT, type: oracledb.NUMBER } },
      // Habilitar autoCommit para que la inserción se confirme automáticamente
      { autoCommit: true }
    );
    // Devolver el nuevo departamento creado, incluyendo el id generado automáticamente por la base de datos
    res.status(201).json({ id_departamento: r.outBinds.id[0], nombre, codigo });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

// PUT actualizar
router.put('/:id', async (req, res) => {
  let conn;
  const { nombre, codigo } = req.body;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'UPDATE EVALUACION.DEPARTAMENTO SET nombre = :nombre, codigo = :codigo WHERE id_departamento = :id',
      { nombre, codigo, id: parseInt(req.params.id) },
      { autoCommit: true }
    );
    // Si no se actualizó ningún registro, significa que el departamento no existe, devolver error 404
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Actualizado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

// DELETE eliminar
router.delete('/:id', async (req, res) => {
  let conn;
  try {
    conn = await getConnection();
    const r = await conn.execute(
      'DELETE FROM EVALUACION.DEPARTAMENTO WHERE id_departamento = :id',
      { id: parseInt(req.params.id) },
      { autoCommit: true }
    );
    if (!r.rowsAffected) return res.status(404).json({ error: 'No encontrado' });
    res.json({ message: 'Eliminado correctamente' });
  } catch (err) { res.status(500).json({ error: err.message }); }
  finally { if (conn) await conn.close(); }
});

export default router;