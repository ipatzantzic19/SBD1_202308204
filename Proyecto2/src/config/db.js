import oracledb from 'oracledb';
import { config } from 'dotenv';

// Cargar variables de entorno
config();

// Modo thin: necesario para Oracle XE en contenedores
// oracledb.initOracleClient(); // Descomenta si tienes Oracle Client instalado

export async function getConnection() {
  try {
    const connection = await oracledb.getConnection({
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING
    });
    return connection;
  } catch (err) {
    console.error('Error de conexión a Oracle:', err);
    throw err;
  }
}