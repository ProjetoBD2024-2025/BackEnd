-- DROP TABLES Clientes, Projeto; --
CREATE DATABASE Projeto_bd
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE Projeto_bd;

CREATE TABLE Clientes(
	Nome varchar(100) NOT NULL,
    ID_Cliente int PRIMARY KEY AUTO_INCREMENT,
    CPF_CNPJ char(15) NOT NULL,
    Telefone varchar(20) NOT NULL,
    Email varchar(60) NOT NULL,
    Endereço varchar (50) NOT NULL
    );
    
CREATE TABLE Projeto(
	Nome varchar(100) NOT NULL,
    ID_Projeto int PRIMARY KEY AUTO_INCREMENT,
    Descricao varchar(250) NOT NULL,
    Data_Inicio date NOT NULL,
    Data_Fim_Prev date NOT NULL,
    Status_ varchar(15) NOT NULL,
    Orcamento_previsto int NOT NULL,
    Id_contratante int NOT NULL,
    FOREIGN KEY (Id_contratante) REFERENCES Clientes(ID_Cliente),
    CHECK (Status_ = "Planejado" OR Status_ = "Em andamento" OR Status_ = "Concluido")
    );
    
CREATE TABLE Engenheiro(
	ID_Engenheiro int PRIMARY KEY AUTO_INCREMENT,
	Nome varchar(100) NOT NULL,
	CREA char(10) NOT NULL UNIQUE,
	Telefone varchar(20) NOT NULL,
	Email varchar(60) NOT NULL
	);

CREATE TABLE Equipe(
	ID_Equipe int PRIMARY KEY AUTO_INCREMENT,
    Nome varchar(100) NOT NULL,
    Supervisor int NOT NULL,
    FOREIGN KEY (Supervisor) REFERENCES Engenheiro(ID_Engenheiro)
	);
    
CREATE TABLE Tarefa(
	ID_Tarefa int PRIMARY KEY AUTO_INCREMENT,
    ID_Projeto int NOT NULL,
    Nome varchar(100) NOT NULL,
    Descricao varchar(250) NOT NULL,
    Data_Inicio date NOT NULL,
    Data_Fim_Prev date NOT NULL,
    Status_ varchar(15) NOT NULL,
    FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto),
    CHECK (Status_ = "Pendente" OR Status_ = "Em andamento" OR Status_ = "Concluido")
	);
    
CREATE TABLE Material(
	ID_Material int PRIMARY KEY AUTO_INCREMENT,
    Nome varchar(100) NOT NULL,
    Un_Medida varchar(3) NOT NULL,
    Preco_Un_Medio int NOT NULL,
    Estoque int NOT NULL
    );
    
CREATE TABLE Fornecedor(
	ID_Fornecedor int PRIMARY KEY AUTO_INCREMENT,
    Nome varchar(100) NOT NULL,
	CNPJ char(18) NOT NULL,
	Telefone varchar(20) NOT NULL,
	Email varchar(100)  NOT NULL,
	Endereco varchar(150) NOT NULL
    );
    
CREATE TABLE Cronograma(
	ID_Cronograma int PRIMARY KEY AUTO_INCREMENT,
    ID_Projeto int NOT NULL,
    Data_ date NOT NULL,
    Atividade_descrita varchar(250) NOT NULL,
    Responsavel int NOT NULL,
    FOREIGN KEY (Responsavel) REFERENCES Equipe(ID_Equipe)
    );
    
CREATE TABLE Documento(
	ID_Documento int PRIMARY KEY AUTO_INCREMENT,
    ID_Projeto int NOT NULL,
    Nome_Arquivo varchar(100) NOT NULL,
    Tipo_Arquivo varchar(10) NOT NULL,
    Arquivo_Bin blob NOT NULL,
    FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto)
    );

CREATE TABLE Pagamentos(
	ID_Pagmento int PRIMARY KEY AUTO_INCREMENT,
    ID_Cliente int NOT NULL,
    ID_Projeto int NOT NULL,
    Valor int NOT NULL,
    Data_Pag date NOT NULL,
    Forma_Pag varchar(13) NOT NULL,
    Comprovante int NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Projeto) REFERENCES Projeto(ID_Projeto),
    FOREIGN KEY (Comprovante) REFERENCES Documento(ID_Documento),
    CHECK (Forma_Pag = "Cartao" or Forma_Pag = "Boleto" or Forma_Pag = "Transferencia")
    );