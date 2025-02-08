-- Alterar a tabela Tarefa
ALTER TABLE Tarefa
DROP FOREIGN KEY IF EXISTS tarefa_ibfk_1;

ALTER TABLE Tarefa
ADD CONSTRAINT tarefa_ibfk_1 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

-- Alterar a tabela Cronograma
ALTER TABLE Cronograma
DROP FOREIGN KEY IF EXISTS cronograma_ibfk_1;

ALTER TABLE Cronograma
ADD CONSTRAINT cronograma_ibfk_1 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

-- Alterar a tabela Documento
ALTER TABLE Documento
DROP FOREIGN KEY IF EXISTS documento_ibfk_1;

ALTER TABLE Documento
ADD CONSTRAINT documento_ibfk_1 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

-- Alterar a tabela Pagamentos
ALTER TABLE Pagamentos
DROP FOREIGN KEY IF EXISTS pagamentos_ibfk_2;

ALTER TABLE Pagamentos
ADD CONSTRAINT pagamentos_ibfk_2 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

-- Alterar a tabela Equipe_Proj
ALTER TABLE Equipe_Proj
DROP FOREIGN KEY IF EXISTS equipe_proj_ibfk_1;

ALTER TABLE Equipe_Proj
ADD CONSTRAINT equipe_proj_ibfk_1 FOREIGN KEY (Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

-- Alterar a tabela Equipe_Tarefa
ALTER TABLE Equipe_Tarefa
DROP FOREIGN KEY IF EXISTS equipe_tarefa_ibfk_1;

ALTER TABLE Equipe_Tarefa
ADD CONSTRAINT equipe_tarefa_ibfk_1 FOREIGN KEY (Tarefa) REFERENCES Tarefa(ID_Tarefa) ON DELETE CASCADE;

-- Alterar a tabela Mat_Tarefa
ALTER TABLE Mat_Tarefa
DROP FOREIGN KEY IF EXISTS mat_tarefa_ibfk_2;

ALTER TABLE Mat_Tarefa
ADD CONSTRAINT mat_tarefa_ibfk_2 FOREIGN KEY (Tarefa) REFERENCES Tarefa(ID_Tarefa) ON DELETE CASCADE;

ALTER TABLE Documento
DROP FOREIGN KEY documento_ibfk_1;

ALTER TABLE Documento
ADD CONSTRAINT documento_ibfk_1 
FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;


ALTER TABLE Pagamentos
DROP FOREIGN KEY pagamentos_ibfk_3;

ALTER TABLE Pagamentos
ADD CONSTRAINT pagamentos_ibfk_3
FOREIGN KEY (Comprovante) REFERENCES Documento(ID_Documento) ON DELETE CASCADE;

ALTER TABLE Documento MODIFY COLUMN Arquivo_Bin LONGBLOB;
