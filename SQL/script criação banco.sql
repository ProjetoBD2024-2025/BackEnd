-- DROP TABLES Clientes, Projeto;DROP DATABASE Projeto_bd;  --

CREATE DATABASE Projeto_bd CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE Projeto_bd;

CREATE TABLE Clientes (
    Nome varchar(200) NOT NULL,
    CPF_CNPJ varchar(18) PRIMARY KEY,
    Telefone varchar(20) NOT NULL,
    Email varchar(150) NOT NULL,
    Endereço varchar(150) NOT NULL,
    Senha varchar(25) NOT NULL,
    Img_Perfil blob 
);

CREATE TABLE Projeto (
    Nome varchar(200) NOT NULL,
    ID_Projeto int PRIMARY KEY AUTO_INCREMENT,
    Descricao varchar(250) NOT NULL,
    Data_Inicio date NOT NULL,
    Data_Fim_Prev date NOT NULL,
    Status_ varchar(15) NOT NULL,
    Orcamento_previsto double NOT NULL,
    Contratante varchar(18) NOT NULL,
    Equipe_Resp int NOT NULL,
    CHECK (
        Status_ = "Planejado"
        OR Status_ = "Em andamento"
        OR Status_ = "Concluido"
    )
);

CREATE TABLE Engenheiro (
    Nome varchar(200) NOT NULL,
    CREA char(10) PRIMARY KEY,
    Telefone varchar(20) NOT NULL,
    Email varchar(150) NOT NULL,
    Proj_Atual int,
    Equipe int,
    Senha varchar(25) NOT NULL,
    Img_Perfil blob 
);

CREATE TABLE Equipe (
    ID_Equipe int PRIMARY KEY AUTO_INCREMENT,
    Nome varchar(100) NOT NULL,
    Supervisor char(10) NOT NULL
);

CREATE TABLE Tarefa (
    ID_Tarefa int PRIMARY KEY AUTO_INCREMENT,
    ID_Projeto int NOT NULL,
    Nome varchar(100) NOT NULL,
    Descricao varchar(250) NOT NULL,
    Data_Inicio date NOT NULL,
    Data_Fim_Prev date NOT NULL,
    Status_ varchar(15) NOT NULL,
    CHECK (
        Status_ = "Pendente"
        OR Status_ = "Em andamento"
        OR Status_ = "Concluido"
    )
);

CREATE TABLE Material (
    ID_Material int PRIMARY KEY AUTO_INCREMENT,
    Nome varchar(100) NOT NULL,
    Un_Medida varchar(3) NOT NULL,
    Preco_Un_Medio double NOT NULL,
    Estoque int NOT NULL
);

CREATE TABLE Fornecedor (
    Nome varchar(100) NOT NULL,
    CNPJ char(18) PRIMARY KEY,
    Telefone varchar(20) NOT NULL,
    Email varchar(150) NOT NULL,
    Endereco varchar(150) NOT NULL
);

CREATE TABLE Cronograma (
    ID_Cronograma int PRIMARY KEY AUTO_INCREMENT,
    ID_Projeto int NOT NULL,
    Data_ date NOT NULL,
    Atividade_descrita varchar(250) NOT NULL,
    Responsavel int NOT NULL
);

CREATE TABLE Documento (
    ID_Documento int PRIMARY KEY AUTO_INCREMENT,
    ID_Projeto int NOT NULL,
    Nome_Arquivo varchar(100) NOT NULL,
    Tipo_Arquivo varchar(10) NOT NULL,
    Arquivo_Bin longblob NOT NULL
);

CREATE TABLE Pagamentos (
    ID_Pagmento int PRIMARY KEY AUTO_INCREMENT,
    ID_Cliente varchar(18) NOT NULL,
    ID_Projeto int NOT NULL,
    Valor int NOT NULL,
    Data_Pag date NOT NULL,
    Forma_Pag varchar(13) NOT NULL,
    Comprovante int NOT NULL,
    CHECK (
        Forma_Pag = "Cartao"
        or Forma_Pag = "Boleto"
        or Forma_Pag = "Transferencia"
    )
);

CREATE TABLE Mat_Tarefa (
    Material int NOT NULL,
    Tarefa int NOT NULL,
    Quantidade int NOT NULL
);

CREATE TABLE Equipe_Proj (
    Projeto int NOT NULL,
    Equipe int NOT NULL
);

CREATE TABLE Equipe_Tarefa (
    Tarefa int NOT NULL,
    Equipe int NOT NULL
);

CREATE TABLE Mat_Forn (
    Material int NOT NULL,
    Fornecedor char(18) NOT NULL,
    Preco double NOT NULL
);

ALTER TABLE Projeto
ADD FOREIGN KEY (Contratante) REFERENCES Clientes (CPF_CNPJ),
ADD FOREIGN KEY (Equipe_Resp) REFERENCES Equipe (ID_Equipe);

ALTER TABLE Engenheiro
ADD FOREIGN KEY (Proj_Atual) REFERENCES Projeto (ID_Projeto),
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe);

ALTER TABLE Equipe
ADD FOREIGN KEY (Supervisor) REFERENCES Engenheiro (CREA);

ALTER TABLE Tarefa
ADD CONSTRAINT tarefa_ibfk_1 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

ALTER TABLE Cronograma
ADD FOREIGN KEY (Responsavel) REFERENCES Equipe (ID_Equipe),
ADD CONSTRAINT cronograma_ibfk_2 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

ALTER TABLE Documento
ADD CONSTRAINT documento_ibfk_1 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE;

ALTER TABLE Pagamentos
ADD CONSTRAINT pagamentos_ibfk_1 FOREIGN KEY (ID_Cliente) REFERENCES Clientes(CPF_CNPJ) ON DELETE CASCADE,
ADD CONSTRAINT pagamentos_ibfk_2 FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE,
ADD CONSTRAINT pagamentos_ibfk_3 FOREIGN KEY (Comprovante) REFERENCES Documento(ID_Documento) ON DELETE CASCADE;

ALTER TABLE Mat_Tarefa
ADD FOREIGN KEY (Material) REFERENCES Material (ID_Material),
ADD CONSTRAINT mat_tarefa_ibfk_2 FOREIGN KEY (Tarefa) REFERENCES Tarefa(ID_Tarefa) ON DELETE CASCADE,
ADD PRIMARY KEY (Tarefa, Material);

ALTER TABLE Equipe_Proj
ADD CONSTRAINT equipe_proj_ibfk_2 FOREIGN KEY (Projeto) REFERENCES Projeto(ID_Projeto) ON DELETE CASCADE,
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe),
ADD PRIMARY KEY (Projeto, Equipe);

ALTER TABLE Equipe_Tarefa
ADD CONSTRAINT equipe_tarefa_ibfk_2 FOREIGN KEY (Tarefa) REFERENCES Tarefa(ID_Tarefa) ON DELETE CASCADE,
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe),
ADD PRIMARY KEY (Equipe, Tarefa);

ALTER TABLE Mat_Forn
ADD FOREIGN KEY (Material) REFERENCES Material (ID_Material),
ADD FOREIGN KEY (Fornecedor) REFERENCES Fornecedor (CNPJ),
ADD PRIMARY KEY (Material, Fornecedor);

CREATE VIEW DetalhesCompletosProjeto AS
SELECT 
    p.ID_Projeto,
    p.Nome AS Nome_Projeto,
    p.Descricao AS Descricao_Projeto,
    p.Data_Inicio AS Inicio_Projeto,
    p.Data_Fim_Prev AS Fim_Previsto_Projeto,
    p.Status_ AS Status_Projeto,
    p.Orcamento_previsto AS Orcamento_Projeto,
    c.Nome AS Nome_Cliente,
    c.CPF_CNPJ AS CPF_CNPJ_Cliente,
    e.Nome AS Nome_Equipe,
    e.ID_Equipe,
    t.ID_Tarefa,
    t.Nome AS Nome_Tarefa,
    t.Descricao AS Descricao_Tarefa,
    t.Data_Inicio AS Inicio_Tarefa,
    t.Data_Fim_Prev AS Fim_Previsto_Tarefa,
    t.Status_ AS Status_Tarefa,
    m.Nome AS Nome_Material,
    m.Un_Medida AS Unidade_Medida,
    mt.Quantidade AS Quantidade_Material,
    f.Nome AS Nome_Fornecedor,
    f.CNPJ AS CNPJ_Fornecedor,
    cr.Data_ AS Data_Cronograma,
    cr.Atividade_descrita AS Atividade_Cronograma,
    eq.Nome AS Responsavel_Cronograma
FROM 
    Projeto p
JOIN 
    Clientes c ON p.Contratante = c.CPF_CNPJ
JOIN 
    Equipe e ON p.Equipe_Resp = e.ID_Equipe
LEFT JOIN 
    Tarefa t ON p.ID_Projeto = t.ID_Projeto
LEFT JOIN 
    Mat_Tarefa mt ON t.ID_Tarefa = mt.Tarefa
LEFT JOIN 
    Material m ON mt.Material = m.ID_Material
LEFT JOIN 
    Mat_Forn mf ON m.ID_Material = mf.Material
LEFT JOIN 
    Fornecedor f ON mf.Fornecedor = f.CNPJ
LEFT JOIN 
    Cronograma cr ON p.ID_Projeto = cr.ID_Projeto
LEFT JOIN 
    Equipe eq ON cr.Responsavel = eq.ID_Equipe;

DELIMITER $$

CREATE PROCEDURE alocacao_engenheiro (IN identifier INT)
BEGIN
    DECLARE projeto_atual INT;

    SELECT Proj_Atual INTO projeto_atual FROM Engenheiro WHERE CREA = identifier;

    IF  projeto_atual IS NOT Null THEN
        SELECT Nome FROM Projeto WHERE ID_Projeto = projeto_atual;
    ELSE
        SELECT 'O Engenheiro não possui projeto atual!' AS mensagem;
    END IF; 
END $$

DELIMITER ;