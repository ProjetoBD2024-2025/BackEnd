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