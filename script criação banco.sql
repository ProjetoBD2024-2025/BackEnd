-- DROP TABLES Clientes, Projeto;DROP DATABASE Projeto_bd;  --

CREATE DATABASE Projeto_bd CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE Projeto_bd;

CREATE TABLE Clientes (
    Nome varchar(100) NOT NULL,
    CPF_CNPJ varchar(18) PRIMARY KEY,
    Telefone varchar(20) NOT NULL,
    Email varchar(60) NOT NULL,
    Endereço varchar(50) NOT NULL
);

CREATE TABLE Projeto (
    Nome varchar(100) NOT NULL,
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
    Nome varchar(100) NOT NULL,
    CREA char(10) PRIMARY KEY,
    Telefone varchar(20) NOT NULL,
    Email varchar(60) NOT NULL,
    Proj_Atual int,
    Equipe int
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
    Email varchar(100) NOT NULL,
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
ADD FOREIGN KEY (Responsavel) REFERENCES Equipe (ID_Equipe);

ALTER TABLE Documento
ADD FOREIGN KEY (ID_Projeto) REFERENCES Projeto (ID_Projeto);

ALTER TABLE Pagamentos
ADD FOREIGN KEY (ID_Cliente) REFERENCES Clientes (CPF_CNPJ),
ADD FOREIGN KEY (ID_Projeto) REFERENCES Projeto (ID_Projeto),
ADD FOREIGN KEY (Comprovante) REFERENCES Documento (ID_Documento);

ALTER TABLE Mat_Tarefa
ADD FOREIGN KEY (Material) REFERENCES Material (ID_Material),
ADD FOREIGN KEY (Tarefa) REFERENCES Tarefa (ID_Tarefa);

ALTER TABLE Equipe_Proj
ADD FOREIGN KEY (Projeto) REFERENCES Projeto (ID_Projeto),
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe);

ALTER TABLE Equipe_Tarefa
ADD FOREIGN KEY (Tarefa) REFERENCES Tarefa (ID_Tarefa),
ADD FOREIGN KEY (Equipe) REFERENCES Equipe (ID_Equipe);

ALTER TABLE Mat_Forn
ADD FOREIGN KEY (Material) REFERENCES Material (ID_Material),
ADD FOREIGN KEY (Fornecedor) REFERENCES Fornecedor (CNPJ);

ALTER TABLE Mat_Tarefa ADD PRIMARY KEY (Tarefa, Material);

ALTER TABLE Equipe_Proj ADD PRIMARY KEY (Projeto, Equipe);

ALTER TABLE Equipe_Tarefa ADD PRIMARY KEY (Equipe, Tarefa);

ALTER TABLE Mat_Forn ADD PRIMARY KEY (Material, Fornecedor);

-- Inserindo dados na tabela Clientes
INSERT INTO
    Clientes (
        Nome,
        CPF_CNPJ,
        Telefone,
        Email,
        Endereço
    )
VALUES (
        'João Silva',
        '12345678901',
        '11912345678',
        'joao@gmail.com',
        'Rua A, 123'
    ),
    (
        'Maria Santos',
        '23456789012',
        '21987654321',
        'maria@hotmail.com',
        'Rua B, 456'
    ),
    (
        'Pedro Oliveira',
        '34567890123',
        '31965432109',
        'pedro@gmail.com',
        'Av. C, 789'
    ),
    (
        'Ana Costa',
        '45678901234',
        '41976543210',
        'ana@yahoo.com',
        'Trav. D, 321'
    ),
    (
        'Lucas Lima',
        '56789012345',
        '51987654321',
        'lucas@hotmail.com',
        'Rua E, 654'
    ),
    (
        'Juliana Souza',
        '67890123456',
        '61998765432',
        'juliana@gmail.com',
        'Av. F, 987'
    ),
    (
        'Carla Mendes',
        '78901234567',
        '71954321098',
        'carla@yahoo.com',
        'Rua G, 567'
    ),
    (
        'Rafael Pereira',
        '89012345678',
        '81965432109',
        'rafael@hotmail.com',
        'Trav. H, 123'
    );

-- Inserindo dados na tabela Engenheiro
INSERT INTO
    Engenheiro (
        Nome,
        CREA,
        Telefone,
        Email,
        Proj_Atual,
        Equipe
    )
VALUES (
        'Carlos Almeida',
        '1234567890',
        '11987654321',
        'carlos@gmail.com',
        NULL,
        NULL
    ),
    (
        'Fernanda Ramos',
        '2345678901',
        '21976543210',
        'fernanda@yahoo.com',
        NULL,
        NULL
    ),
    (
        'Paulo Teixeira',
        '3456789012',
        '31954321098',
        'paulo@hotmail.com',
        NULL,
        NULL
    ),
    (
        'Gabriela Pinto',
        '4567890123',
        '41943210987',
        'gabriela@gmail.com',
        NULL,
        NULL
    ),
    (
        'Leonardo Nunes',
        '5678901234',
        '51932109876',
        'leonardo@yahoo.com',
        NULL,
        NULL
    ),
    (
        'Vanessa Lopes',
        '6789012345',
        '61921098765',
        'vanessa@hotmail.com',
        NULL,
        NULL
    ),
    (
        'Ricardo Dias',
        '7890123456',
        '71910987654',
        'ricardo@gmail.com',
        NULL,
        NULL
    ),
    (
        'Mariana Rocha',
        '8901234567',
        '81998765432',
        'mariana@yahoo.com',
        NULL,
        NULL
    );

-- Inserindo dados na tabela Equipe
INSERT INTO
    Equipe (Nome, Supervisor)
VALUES ('Equipe A', '1234567890'),
    ('Equipe B', '2345678901'),
    ('Equipe C', '3456789012'),
    ('Equipe D', '4567890123'),
    ('Equipe E', '5678901234'),
    ('Equipe F', '6789012345'),
    ('Equipe G', '7890123456'),
    ('Equipe H', '8901234567');

-- Inserindo dados na tabela Projeto
INSERT INTO
    Projeto (
        Nome,
        Descricao,
        Data_Inicio,
        Data_Fim_Prev,
        Status_,
        Orcamento_previsto,
        Contratante,
        Equipe_Resp
    )
VALUES (
        'Residencial Alpha',
        'Construção de condomínio de alto padrão',
        '2025-01-01',
        '2025-12-31',
        'Planejado',
        1000000.00,
        '12345678901',
        1
    ),
    (
        'Comercial Beta',
        'Construção de centro comercial',
        '2025-02-01',
        '2026-01-31',
        'Planejado',
        5000000.00,
        '23456789012',
        2
    ),
    (
        'Residencial Gama',
        'Construção de prédio residencial de médio porte',
        '2025-03-01',
        '2026-02-28',
        'Planejado',
        2000000.00,
        '34567890123',
        3
    ),
    (
        'Shopping Delta',
        'Construção de shopping center moderno',
        '2025-05-01',
        '2027-04-30',
        'Planejado',
        10000000.00,
        '45678901234',
        4
    ),
    (
        'Escritório Sigma',
        'Construção de prédio comercial para escritórios',
        '2025-07-01',
        '2026-06-30',
        'Planejado',
        5000000.00,
        '56789012345',
        5
    );

INSERT INTO
    Tarefa (
        ID_Projeto,
        Nome,
        Descricao,
        Data_Inicio,
        Data_Fim_Prev,
        Status_
    )
VALUES (
        1,
        'Fundação',
        'Execução da fundação do prédio',
        '2025-01-10',
        '2025-02-15',
        'Pendente'
    ),
    (
        1,
        'Estrutura',
        'Montagem da estrutura principal',
        '2025-02-16',
        '2025-05-30',
        'Pendente'
    ),
    (
        2,
        'Terraplenagem',
        'Preparação do terreno',
        '2025-02-01',
        '2025-02-20',
        'Pendente'
    ),
    (
        2,
        'Alvenaria',
        'Construção das paredes externas',
        '2025-03-01',
        '2025-05-15',
        'Pendente'
    ),
    (
        3,
        'Cobertura',
        'Instalação do telhado',
        '2025-06-01',
        '2025-06-20',
        'Pendente'
    ),
    (
        3,
        'Acabamento',
        'Realização dos acabamentos internos',
        '2025-06-21',
        '2025-08-31',
        'Pendente'
    ),
    (
        4,
        'Pintura',
        'Pintura externa do prédio',
        '2025-09-01',
        '2025-09-15',
        'Pendente'
    ),
    (
        4,
        'Revisão',
        'Inspeção final e ajustes',
        '2025-09-16',
        '2025-09-30',
        'Pendente'
    );

INSERT INTO
    Material (
        Nome,
        Un_Medida,
        Preco_Un_Medio,
        Estoque
    )
VALUES ('Cimento', 'kg', 25.50, 1000),
    ('Areia', 'm3', 40.00, 500),
    ('Brita', 'm3', 50.00, 300),
    (
        'Bloco de Concreto',
        'un',
        5.00,
        2000
    ),
    ('Vergalhão', 'm', 10.00, 1000),
    ('Tinta', 'l', 20.00, 400),
    ('Telha', 'un', 30.00, 600),
    ('Madeira', 'm3', 120.00, 150);

INSERT INTO
    Fornecedor (
        Nome,
        CNPJ,
        Telefone,
        Email,
        Endereco
    )
VALUES (
        'Construtora Alpha',
        '11122233344455',
        '11987654321',
        'contato@alpha.com',
        'Rua A, 123'
    ),
    (
        'Materiais Beta',
        '22233344455566',
        '21976543210',
        'vendas@beta.com',
        'Av. B, 456'
    ),
    (
        'Tintas Gama',
        '33344455566677',
        '31954321098',
        'suporte@gama.com',
        'Rua C, 789'
    ),
    (
        'Madeiras Delta',
        '44455566677788',
        '41943210987',
        'comercial@delta.com',
        'Trav. D, 321'
    ),
    (
        'Metais Epsilon',
        '55566677788899',
        '51932109876',
        'info@epsilon.com',
        'Rua E, 654'
    ),
    (
        'Cerâmica Zeta',
        '66677788899900',
        '61921098765',
        'ceramicas@zeta.com',
        'Av. F, 987'
    ),
    (
        'Telhas Theta',
        '77788899900011',
        '71910987654',
        'contato@theta.com',
        'Rua G, 567'
    ),
    (
        'Equipamentos Iota',
        '88899900011122',
        '81998765432',
        'vendas@iota.com',
        'Trav. H, 123'
    );

INSERT INTO
    Cronograma (
        ID_Projeto,
        Data_,
        Atividade_descrita,
        Responsavel
    )
VALUES (
        1,
        '2025-01-10',
        'Início da fundação',
        1
    ),
    (
        1,
        '2025-02-16',
        'Início da estrutura',
        1
    ),
    (
        2,
        '2025-02-01',
        'Terraplenagem iniciada',
        2
    ),
    (
        2,
        '2025-03-01',
        'Alvenaria das paredes externas',
        2
    ),
    (
        3,
        '2025-06-01',
        'Cobertura em execução',
        3
    ),
    (
        3,
        '2025-06-21',
        'Acabamentos internos',
        3
    ),
    (
        4,
        '2025-09-01',
        'Pintura externa',
        4
    ),
    (
        4,
        '2025-09-16',
        'Revisão e ajustes finais',
        4
    );

INSERT INTO
    Documento (
        ID_Projeto,
        Nome_Arquivo,
        Tipo_Arquivo,
        Arquivo_Bin
    )
VALUES (
        1,
        'Planta_Fundacao.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        1,
        'Planta_Estrutura.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        2,
        'Planta_Terraplenagem.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        2,
        'Planta_Alvenaria.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        3,
        'Planta_Cobertura.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        3,
        'Planta_Acabamentos.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        4,
        'Relatorio_Pintura.pdf',
        'PDF',
        'BinaryContent'
    ),
    (
        4,
        'Inspecao_Final.pdf',
        'PDF',
        'BinaryContent'
    );

INSERT INTO
    Pagamentos (
        ID_Cliente,
        ID_Projeto,
        Valor,
        Data_Pag,
        Forma_Pag,
        Comprovante
    )
VALUES (
        '12345678901',
        1,
        100000,
        '2025-01-05',
        'Boleto',
        1
    ),
    (
        '23456789012',
        2,
        200000,
        '2025-01-10',
        'Transferencia',
        2
    ),
    (
        '34567890123',
        3,
        150000,
        '2025-01-15',
        'Cartao',
        3
    ),
    (
        '45678901234',
        4,
        180000,
        '2025-01-20',
        'Boleto',
        4
    ),
    (
        '56789012345',
        1,
        200000,
        '2025-02-05',
        'Cartao',
        5
    ),
    (
        '67890123456',
        2,
        250000,
        '2025-02-10',
        'Transferencia',
        6
    ),
    (
        '78901234567',
        3,
        300000,
        '2025-02-15',
        'Boleto',
        7
    ),
    (
        '89012345678',
        4,
        100000,
        '2025-02-20',
        'Cartao',
        8
    );

INSERT INTO
    Mat_Forn (Material, Fornecedor, Preco)
VALUES (1, '11122233344455', 25.00),
    (2, '22233344455566', 40.00),
    (3, '33344455566677', 50.00),
    (4, '44455566677788', 5.00),
    (5, '55566677788899', 10.00),
    (6, '66677788899900', 20.00),
    (7, '77788899900011', 30.00),
    (8, '88899900011122', 120.00);

INSERT INTO
    Mat_Tarefa (Material, Tarefa, Quantidade)
VALUES (1, 1, 200), -- Projeto 1, Fundação
    (2, 1, 50), -- Projeto 1, Fundação
    (3, 2, 100), -- Projeto 1, Estrutura
    (4, 2, 300), -- Projeto 1, Estrutura
    (5, 3, 150), -- Projeto 2, Terraplenagem
    (6, 4, 200), -- Projeto 2, Alvenaria
    (7, 5, 400), -- Projeto 3, Cobertura
    (8, 6, 250);
-- Projeto 3, Acabamento
INSERT INTO
    Equipe_Proj (Projeto, Equipe)
VALUES (1, 1), -- Residencial Alpha - Equipe A
    (2, 2), -- Comercial Beta - Equipe B
    (3, 3), -- Residencial Gama - Equipe C
    (4, 4), -- Shopping Delta - Equipe D
    (5, 5), -- Escritório Sigma - Equipe E
    (1, 6), -- Residencial Alpha - Equipe F
    (2, 7), -- Comercial Beta - Equipe G
    (3, 8);
-- Residencial Gama - Equipe H
INSERT INTO
    Equipe_Tarefa (Tarefa, Equipe)
VALUES (1, 1), -- Fundação - Equipe A
    (2, 1), -- Estrutura - Equipe A
    (3, 2), -- Terraplenagem - Equipe B
    (4, 2), -- Alvenaria - Equipe B
    (5, 3), -- Cobertura - Equipe C
    (6, 3), -- Acabamento - Equipe C
    (7, 4), -- Pintura - Equipe D
    (8, 4);
-- Revisão - Equipe D