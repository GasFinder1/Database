-- Altera o tamanho da coluna senha para 100 caracteres
ALTER TABLE tbl_usuario
MODIFY COLUMN senha VARCHAR(100) NOT NULL;

-- Remove a restrição NOT NULL da coluna email
ALTER TABLE tbl_usuario
MODIFY COLUMN email VARCHAR(60);