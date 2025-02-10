import mysql.connector

class Projeto:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="develbackend",
            password="uniquepassword",
            database="projeto_db"
        )

        self.cursor = self.connection.cursor()


    def get_all_projetos(self):
        arg = """
            SELECT 
                Projeto.*, 
                
                -- Informações do Cliente (Contratante)
                Clientes.Nome AS Cliente_Nome,
                Clientes.Telefone AS Cliente_Telefone,
                Clientes.Email AS Cliente_Email,
                Clientes.Endereço AS Cliente_Endereco,
                
                -- Informações da Equipe Responsável
                Equipe.Nome AS Equipe_Nome,
                
                -- Pegando o Nome do Supervisor (e não o ID/CREA)
                Engenheiro.Nome AS Supervisor_Nome  

            FROM Projeto
            JOIN Clientes ON Projeto.Contratante = Clientes.CPF_CNPJ
            JOIN Equipe ON Projeto.Equipe_Resp = Equipe.ID_Equipe
            JOIN Engenheiro ON Equipe.Supervisor = Engenheiro.CREA  -- Pega o nome do supervisor corretamente
        """

        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        
        return result


    def get_projeto(self, Identifier):
        arg = f"""
            SELECT 
                Projetos.*, 
                Equipes.*, 
                Clientes.Nome AS Cliente_Nome,
                Clientes.Telefone AS Cliente_Telefone,
                Clientes.Email AS Cliente_Email,
                Clientes.Endereço AS Cliente_Endereco,
                Engenheiro.Nome AS Supervisor_Nome
            FROM (SELECT * FROM Projeto WHERE ID_Projeto = {Identifier}) AS Projetos 
            JOIN Equipe AS Equipes ON Projetos.Equipe_Resp = Equipes.ID_Equipe
            JOIN Clientes ON Projetos.Contratante = Clientes.CPF_CNPJ
            LEFT JOIN Engenheiro ON Equipes.Supervisor = Engenheiro.CREA
        """

        self.cursor.execute(arg)
        result = self.cursor.fetchone()

        return result
    

    def add_projeto(self, values):

        arg = """INSERT INTO Projeto (Nome, Descricao, Data_Inicio, Data_Fim_Prev, Status_, Orcamento_previsto, Contratante, Equipe_Resp)
                    VALUES ('{0}','{1}','{2}','{3}','{4}',{5},'{6}',{7})""".format(values['Nome'],
                                                                                   values['Descricao'],
                                                                                   values['Data_Inicio'],
                                                                                   values['Data_Fim_Prev'],
                                                                                   values['Status'],
                                                                                   values['Orcamento_previsto'],
                                                                                   values['Contratante'],
                                                                                   values['Equipe_Resp'])
        
        self.cursor.execute(arg)
        self.connection.commit()


    def delete_projeto(self, Identifier):

        arg = f"DELETE FROM Projeto WHERE ID_Projeto = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()


    def edit_projeto(self, Identifier, values):
        print(values)
        arg = """UPDATE Projeto SET 
                    Nome = %s,
                    Descricao = %s,
                    Data_Inicio = %s,
                    Data_Fim_Prev = %s,
                    Status_ = %s,
                    Orcamento_previsto = %s,
                    Equipe_Resp = %s,
                    Contratante = %s
                WHERE ID_Projeto = %s"""
        
        # Passando os parâmetros de forma segura
        params = (
            values['Nome'], 
            values['Descricao'], 
            values['Data_Inicio'], 
            values['Data_Fim_Prev'], 
            values['Status'], 
            values['Orcamento_previsto'], 
            values['Equipe_Resp'],  # Adicionando a equipe responsável
            values['Contratante'],  # Adicionando o contratante
            Identifier
        )
        
        self.cursor.execute(arg, params)
        self.connection.commit()

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------

class Documentos:
    def __init__(self):
        self.connection = mysql.connector.connect(
            host="localhost",
            user="develbackend",
            password="uniquepassword",
            database="projeto_db"
        )

        self.cursor = self.connection.cursor()
    def get_documento(self, Identifier):
        arg = f"SELECT * FROM Documento WHERE ID_Projeto = {Identifier}"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        return result

    def get_documentoDownload(self, Identifier):
        arg = f"SELECT * FROM Documento WHERE ID_Documento = {Identifier}"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        return result
    
    def add_documento(self, Identifier, nome_arquivo, tipo_arquivo, documento_blob):
        arg = """INSERT INTO Documento (ID_Projeto, Nome_Arquivo, Tipo_Arquivo, Arquivo_Bin)
                VALUES (%s, %s, %s, %s)"""
        
        params = (Identifier, nome_arquivo, tipo_arquivo, documento_blob)
        
        self.cursor.execute(arg, params)
        self.connection.commit()
    
    def delete_documento(self, Identifier):
        arg = f"DELETE FROM Documento WHERE ID_Documento = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()

class Cliente:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="develbackend",
            password="uniquepassword",
            database="projeto_db"
        )

        self.cursor = self.connection.cursor()


    def get_all_clientes(self):

        arg = "SELECT * FROM Clientes"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()

        return result
    
    def add_cliente(self, data):

        arg = """INSERT INTO Clientes (CPF_CNPJ, Nome, Telefone, Email, Endereço, Senha)
                VALUES (%s, %s, %s, %s, %s, %s)"""
        params = (data["CPF_CNPJ"], data["Nome"], data["Telefone"], data["Email"], data["Endereco"], data["Senha"])
        
        self.cursor.execute(arg, params)
        self.connection.commit()
        
    def update_cliente(self, Identifier, values):
        arg = """UPDATE Clientes SET 
                    Nome = %s,
                    Telefone = %s,
                    Email = %s,
                    Endereço = %s
                WHERE CPF_CNPJ = %s"""
        
        params = (
            values['Nome'],
            values['Telefone'],
            values['Email'],
            values['Endereco'],
            Identifier
        )
        
        self.cursor.execute(arg, params)
        self.connection.commit()
    
    def delete_cliente(self, Identifier):
        arg = f"DELETE FROM Clientes WHERE CPF_CNPJ = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()

class Equipe:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="develbackend",
            password="uniquepassword",
            database="projeto_db"
        )

        self.cursor = self.connection.cursor()


    def get_all_equipes(self):

        arg = "SELECT * FROM Equipe"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()

        return result
    
class Tarefa:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="develbackend",
            password="uniquepassword",
            database="projeto_db"
        )

        self.cursor = self.connection.cursor()


    def add_tarefa(self, project_id, values):

        arg = """INSERT INTO Tarefa (ID_Projeto, Nome, Descricao, Data_Inicio, Data_Fim_Prev, Status_)
                    VALUES ({0},'{1}','{2}','{3}','{4}','{5}')""".format(project_id,
                                                                         values['Nome'],
                                                                         values['Descricao'],
                                                                         values['Data_Inicio'],
                                                                         values['Data_Fim_Prev'],
                                                                         values['Status'])
        
        self.cursor.execute(arg)
        self.connection.commit()


    def get_all_tarefas(self):
        
        arg = f"SELECT * FROM Tarefa"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        
        return result
    
    def get_all_tarefas_projetos(self, Identifier):
        
        arg = f"SELECT * FROM Tarefa WHERE ID_Projeto = {Identifier}"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        
        return result

    def get_tarefa(self, Identifier):

        arg = f"SELECT * FROM Tarefa WHERE ID_Tarefa = {Identifier}"

        self.cursor.execute(arg)
        result = self.cursor.fetchone()

        return result
    

    def delete_tarefa(self, Identifier):

        arg = f"DELETE FROM Tarefa WHERE ID_Tarefa = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()


    def edit_tarefa(self, Identifier, values):

        arg = """UPDATE Tarefa SET 
                    Nome = %s,
                    Descricao = %s,
                    Data_Inicio = %s,
                    Data_Fim_Prev = %s,
                    Status_ = %s
                WHERE ID_Tarefa = %s"""
        params = (
            values["Nome"],
            values["Descricao"],
            values["Data_Inicio"],
            values["Data_Fim_Prev"],
            values["Status"],
            Identifier
        )
        self.cursor.execute(arg, params)
        self.connection.commit()
