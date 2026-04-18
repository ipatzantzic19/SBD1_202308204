-- ============================================================
-- 00_create_user.sql  —  Crear usuario EVALUACION
-- Sistema: Centros de Evaluación de Manejo — Guatemala
-- Proyecto 2 · SBD1 · USAC 1S 2026
-- ============================================================

CREATE USER c##EVAL IDENTIFIED BY "Proyecto123";
GRANT CONNECT TO c##EVAL;
GRANT RESOURCE TO c##EVAL;
GRANT CREATE TABLE TO c##EVAL;
GRANT CREATE SEQUENCE TO c##EVAL;
GRANT CREATE PROCEDURE TO c##EVAL;
ALTER USER c##EVAL QUOTA UNLIMITED ON USERS;

COMMIT;
/
