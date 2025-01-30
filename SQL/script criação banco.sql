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
    Arquivo_Bin blob NOT NULL
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
ADD FOREIGN KEY (ID_Projeto) REFERENCES Projeto (ID_Projeto);

ALTER TABLE Cronograma
ADD FOREIGN KEY (Responsavel) REFERENCES Equipe (ID_Equipe),
ADD FOREIGN KEY (ID_Projeto) REFERENCES Projeto (ID_Projeto);

ALTER TABLE Documento
ADD FOREIGN KEY (ID_Projeto) REFERENCES Projeto (ID_Projeto);

ALTER TABLE Pagamentos
ADD FOREIGN KEY (ID_Cliente) REFERENCES Clientes (CPF_CNPJ),
ADD FOREIGN KEY (ID_Projeto) REFERENCES Projeto (ID_Projeto),
ADD FOREIGN KEY (Comprovante) REFERENCES Documento (ID_Documento);

ALTER TABLE Mat_Tarefa
ADD FOREIGN KEY (Material) REFERENCES Material (ID_Material),
ADD FOREIGN KEY (Tarefa) REFERENCES Tarefa (ID_Tarefa),
ADD PRIMARY KEY (Tarefa, Material);

ALTER TABLE Equipe_Proj
ADD FOREIGN KEY (Projeto) REFERENCES Projeto (ID_Projeto),
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe),
ADD PRIMARY KEY (Projeto, Equipe);

ALTER TABLE Equipe_Tarefa
ADD FOREIGN KEY (Tarefa) REFERENCES Tarefa (ID_Tarefa),
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe),
ADD PRIMARY KEY (Equipe, Tarefa);

ALTER TABLE Mat_Forn
ADD FOREIGN KEY (Material) REFERENCES Material (ID_Material),
ADD FOREIGN KEY (Fornecedor) REFERENCES Fornecedor (CNPJ),
ADD PRIMARY KEY (Material, Fornecedor);
