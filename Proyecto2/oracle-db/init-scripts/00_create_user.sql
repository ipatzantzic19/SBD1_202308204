-- ============================================================
-- 00_create_user.sql  —  Crear usuario EVALUACION en PDB XEPDB1
-- Sistema: Centros de Evaluación de Manejo — Guatemala
-- Proyecto 2 · SBD1 · USAC 1S 2026
-- ============================================================

-- Cambiar contexto al PDB XEPDB1
ALTER SESSION SET CONTAINER = XEPDB1;

-- Crear usuario local en el PDB (sin prefijo c##)
CREATE USER EVALUACION IDENTIFIED BY "Proyecto123";

-- Otorgar permisos necesarios
GRANT CREATE SESSION TO EVALUACION;
GRANT CONNECT TO EVALUACION;
GRANT RESOURCE TO EVALUACION;
GRANT CREATE TABLE TO EVALUACION;
GRANT CREATE SEQUENCE TO EVALUACION;
GRANT CREATE PROCEDURE TO EVALUACION;
GRANT UNLIMITED TABLESPACE TO EVALUACION;

-- Ejecutar los siguientes scripts como EVALUACION
COMMIT;
/

-- Los siguientes archivos (01_ddl.sql, 02_dml.sql) deben ejecutarse conectando como:
-- sqlplus EVALUACION/Proyecto123@//localhost:1521/XEPDB1 @01_ddl.sql
-- sqlplus EVALUACION/Proyecto123@//localhost:1521/XEPDB1 @02_dml.sql

